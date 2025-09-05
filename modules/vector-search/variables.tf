variable "project_id" {
  description = "El ID del proyecto de GCP."
  type        = string
}

variable "region" {
  description = "La región donde se desplegarán los recursos."
  type        = string
}

variable "display_name_prefix" {
  description = "Un prefijo para nombrar los recursos de Vector Search."
  type        = string
}

variable "dimensions" {
  description = "El número de dimensiones de los vectores de embedding. Por ejemplo, 768 para textembedding-gecko@003."
  type        = number
}

variable "vpc_network" {
  description = "Opcional. La red VPC para crear un endpoint privado. Si es nulo, se crea un endpoint público."
  type        = string
  default     = null
}

variable "machine_type" {
  description = "El tipo de máquina para el nodo de predicción del endpoint."
  type        = string
  default     = "n1-standard-16"
}