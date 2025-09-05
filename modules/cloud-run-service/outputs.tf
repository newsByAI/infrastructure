output "service_url" {
  description = "La URL del servicio desplegado."
  value       = google_cloud_run_v2_service.service.uri
}
