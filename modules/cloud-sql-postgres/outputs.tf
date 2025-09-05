output "instance_connection_name" {
  description = "El connection name de la instancia para usar en Cloud Run."
  value       = google_sql_database_instance.postgres_instance.connection_name
}

output "database_name" {
  description = "El nombre de la base de datos."
  value       = google_sql_database.db.name
}

output "db_user_name" {
  description = "El nombre del usuario de la base de datos."
  value       = google_sql_user.db_user.name
}

output "password_secret_name" {
  description = "El nombre del secreto que contiene la contraseña de la BD."
  value       = google_secret_manager_secret.password_secret.secret_id
}
