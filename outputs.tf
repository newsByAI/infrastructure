
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
