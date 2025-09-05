
# output "frontend_cloud_run_url" {
#   description = "URL generada por Cloud Run para el servicio de frontend."
#   value       = module.frontend_service.service_url
# }

# output "frontend_custom_domain_url" {
#   description = "URL del dominio personalizado para el frontend."
#   value       = "https://${module.domain_mapping.domain_name}"
# }

# output "dns_records_for_godaddy" {
#   description = "Registros DNS que debes configurar manualmente en GoDaddy."
#   value       = module.domain_mapping.dns_records
#   sensitive   = true # Oculta los valores en la salida de la consola por defecto
# }


# Expose Vertex AI Index ID from the module
output "VERTEX_INDEX_ID" {
  description = "Vertex AI index ID from the vector-search module"
  value       = module.vector-search.VERTEX_INDEX_ID
}

# Expose Vertex AI Endpoint ID from the module
output "VERTEX_ENDPOINT_ID" {
  description = "Vertex AI endpoint ID from the vector-search module"
  value       = module.vector-search.VERTEX_ENDPOINT_ID
}

# Expose Deployed Index ID from the module
output "DEPLOYED_INDEX_ID" {
  description = "Deployed index ID from the vector-search module"
  value       = module.vector-search.DEPLOYED_INDEX_ID
}

# Expose GCS bucket URI from the module
output "VECTOR_BUCKET_URI" {
  description = "GCS bucket URI from the vector-search module"
  value       = module.vector-search.VECTOR_BUCKET_URI
}
