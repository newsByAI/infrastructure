# Crear una Service Account dedicada para este servicio.
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "${var.service_name}-sa" # Crea un ID único, ej: "backend-dev-sa"
  display_name = "Service Account for ${var.service_name}"
}

# Darle permiso a la NUEVA Service Account para acceder a los secretos.
resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  for_each = var.secrets

  project   = var.project_id
  secret_id = split(":", each.value)[0]
  role      = "roles/secretmanager.secretAccessor"

  # Apunta a la Service Account que acabamos de crear.
  member = "serviceAccount:${google_service_account.sa.email}"
}

# Permiso para que la Service Account pueda conectarse a instancias de Cloud SQL.
resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Crear el servicio de Cloud Run, diciéndole que use la Service Account ya configurada.
resource "google_cloud_run_v2_service" "service" {
  project  = var.project_id
  name     = var.service_name
  location = var.region

  deletion_protection = false # Puedes cambiarlo a true después del primer despliegue exitoso

  ingress = var.internal_only ? "INGRESS_TRAFFIC_INTERNAL_ONLY" : "INGRESS_TRAFFIC_ALL"

  template {
    # Use the configured service account
    service_account = google_service_account.sa.email

    containers {
      image = var.image_url

      ports {
        container_port = var.container_port
      }

      dynamic "volume_mounts" {
        for_each = var.sql_connection_string != null ? { "cloudsql" = "/cloudsql" } : {}
        content {
          name       = volume_mounts.key
          mount_path = volume_mounts.value
        }
      }

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = var.secrets
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = split(":", env.value)[0]
              version = split(":", env.value)[1]
            }
          }
        }
      }
    }

    dynamic "volumes" {
      for_each = var.sql_connection_string != null ? { "cloudsql" = var.sql_connection_string } : {}
      content {
        name = volumes.key
        cloud_sql_instance {
          instances = [volumes.value]
        }
      }
    }
  }

  # Hacemos que la creación del servicio espere a que el permiso IAM esté aplicado.
  depends_on = [
    google_secret_manager_secret_iam_member.secret_accessor
  ]
}

# Permiso para invocar el servicio (si es público)
resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.internal_only ? 0 : 1

  project  = google_cloud_run_v2_service.service.project
  location = google_cloud_run_v2_service.service.location
  service  = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
