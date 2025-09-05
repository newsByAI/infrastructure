variable "project_id" {
  description = "El ID del proyecto de Google Cloud."
  type        = string
}

variable "region" {
  description = "La región donde se desplegará la base de datos."
  type        = string
}

variable "instance_name" {
  description = "Nombre para la instancia de Cloud SQL."
  type        = string
}

variable "database_name" {
  description = "Nombre de la base de datos a crear."
  type        = string
}

variable "db_user_name" {
  description = "Nombre del usuario de la base de datos."
  type        = string
}

variable "tier" {
  description = "El tier o tamaño de la máquina para la instancia."
  type        = string
  default     = "db-f1-micro"
}
