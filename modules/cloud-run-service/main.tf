resource "google_cloud_run_v2_service" "service" {
  project  = var.project_id
  name     = var.service_name
  location = var.region

  # Si internal_only es true, el ingreso es solo interno. Si no, es para todo el tráfico.
  ingress = var.internal_only ? "INGRESS_TRAFFIC_INTERNAL_ONLY" : "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.image_url

      # Montar conexión a Cloud SQL si se provee el string de conexión
      dynamic "volume_mounts" {
        for_each = var.sql_connection_string != null ? { "cloudsql" = "/cloudsql" } : {}
        content {
          name       = volume_mounts.key
          mount_path = volume_mounts.value
        }
      }

      # Añadir variables de entorno dinámicamente
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      # Montar secretos como variables de entorno dinámicamente
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

    # Definir el volumen para la conexión a Cloud SQL
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
}

# Permitir acceso público solo si internal_only es false
resource "google_cloud_run_service_iam_member" "public_access" {
  # Solo crea este recurso si la variable internal_only es false
  count    = var.internal_only ? 0 : 1
  project  = google_cloud_run_v2_service.service.project
  location = google_cloud_run_v2_service.service.location
  service  = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
