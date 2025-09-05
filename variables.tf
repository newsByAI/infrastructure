

# Vector search related variables
variable "app_name" {
  description = "Nombre de la aplicación para prefijar recursos."
  type        = string
  default     = "news-app"
}

variable "vector_search_machine_type" {
  description = "Tipo de máquina para el endpoint de Vector Search."
  type        = string
  default     = "n1-standard-16"
}

variable "gcs_bucket_uri" {
  description = "The URI of the GCS bucket for the index content (e.g., 'gs://my-bucket-vs/')."
  type        = string
}