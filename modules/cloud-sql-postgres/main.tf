# Generador de contraseñas aleatorias para no hardcodearlas
resource "random_password" "db_password" {
  length  = 24
  special = true
}

# Recurso para guardar la contraseña de forma segura en Secret Manager
resource "google_secret_manager_secret" "password_secret" {
  project   = var.project_id
  secret_id = "${var.instance_name}-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "password_secret_version" {
  secret      = google_secret_manager_secret.password_secret.id
  secret_data = random_password.db_password.result
}

# Creación de la instancia de Cloud SQL
resource "google_sql_database_instance" "postgres_instance" {
  project          = var.project_id
  name             = var.instance_name
  database_version = "POSTGRES_17"
  region           = var.region
  settings {
    tier = var.tier
  }
  # Previene la eliminación accidental en producción
  deletion_protection = false # Cambiar a 'true' para producción
}

# Creación de la base de datos
resource "google_sql_database" "db" {
  project  = var.project_id
  instance = google_sql_database_instance.postgres_instance.name
  name     = var.database_name
}

# Creación del usuario
resource "google_sql_user" "db_user" {
  project  = var.project_id
  instance = google_sql_database_instance.postgres_instance.name
  name     = var.db_user_name
  password = random_password.db_password.result
}
