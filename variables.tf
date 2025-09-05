variable "project_id" {
  description = "ID del proyecto de Google Cloud para staging."
  type        = string
}

variable "region" {
  description = "Región de GCP para los recursos de staging."
  type        = string
  default     = "us-central1"
}

variable "frontend_image_url" {
  description = "URL de la imagen del contenedor del frontend."
  type        = string
}

variable "backend_image_url" {
  description = "URL de la imagen del contenedor del backend."
  type        = string
}

variable "custom_domain" {
  description = "Dominio personalizado para el frontend."
  type        = string
}

variable "db_tier" {
  description = "El tier o tamaño de la máquina para la instancia de la base de datos."
  type        = string
  default     = "db-perf-optimized-N-2"
}

variable "backend_port" {
  description = "El puerto que el backend expondrá."
  type        = number
  default     = 8080
}
