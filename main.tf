
resource "google_project_service" "vertex_ai_api" {
  project                    = var.gcp_project_id
  service                    = "aiplatform.googleapis.com"
  disable_dependent_services = false
}

# Llama al módulo de Vector Search.
module "vector-search" {
  source = "./modules/vector-search"

  depends_on = [google_project_service.vertex_ai_api]

  project_id          = var.gcp_project_id
  region              = var.gcp_region
  display_name_prefix = var.app_name
  machine_type        = var.vector_search_machine_type
  dimensions = 768
  gcs_bucket_uri     = var.gcs_bucket_uri

}
