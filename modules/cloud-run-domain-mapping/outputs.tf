output "dns_records" {
  description = "Los registros DNS que deben ser configurados en el proveedor de dominio."
  value       = google_cloud_run_domain_mapping.mapping.status[0].resource_records
}

output "domain_name" {
  description = "El nombre de dominio personalizado mapeado."
  value       = google_cloud_run_domain_mapping.mapping.name
}
