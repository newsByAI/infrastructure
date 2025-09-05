variable "service_name" {
  description = "Nombre del servicio en Cloud Run."
  type        = string
}

variable "image_url" {
  description = "URL completa de la imagen de contenedor en Artifact Registry."
  type        = string
}

variable "project_id" {
  description = "El ID del proyecto de Google Cloud."
  type        = string
}

variable "region" {
  description = "La región donde se desplegará el servicio."
  type        = string
}

variable "internal_only" {
  description = "Si es true, el servicio solo será accesible desde dentro de la red de GCP."
  type        = bool
  default     = false
}

variable "sql_connection_string" {
  description = "El 'connection_name' de la instancia de Cloud SQL a la que se conectará."
  type        = string
  default     = null # No se conecta a SQL por defecto
}

variable "env_vars" {
  description = "Un mapa de variables de entorno para el servicio."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Un mapa de secretos a montar como variables de entorno. Formato: { ENV_VAR_NAME = \"secret_name:version\" }"
  type        = map(string)
  default     = {}
}

variable "container_port" {
  description = "El puerto en el contenedor que el servicio expondrá."
  type        = number
  default     = 8080
}
