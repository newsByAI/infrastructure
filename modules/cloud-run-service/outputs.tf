output "service_url" {
  description = "La URL del servicio desplegado."
  value       = google_cloud_run_v2_service.service.uri
}

output "service_name" {
  description = "El nombre del servicio de Cloud Run."
  value       = google_cloud_run_v2_service.service.name
}
