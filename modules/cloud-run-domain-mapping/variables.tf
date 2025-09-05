variable "domain_name" {
  description = "El dominio personalizado que se va a mapear (ej. www.mi-app.com)."
  type        = string
}

variable "service_name" {
  description = "El nombre del servicio de Cloud Run al que se apuntará el dominio."
  type        = string
}

variable "project_id" {
  description = "El ID del proyecto de Google Cloud."
  type        = string
}

variable "location" {
  description = "La ubicación del servicio de Cloud Run."
  type        = string
}
