terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.1.1"
    }
  }
}
locals {
  environment = terraform.workspace
}


# --- Base de Datos (usando el módulo) ---
module "database" {
  source        = "./modules/cloud-sql-postgres"
  project_id    = var.project_id
  region        = var.region
  instance_name = "news-db-instance-${local.environment}"
  database_name = "news-db-${local.environment}"
  db_user_name  = "news-db-user-${local.environment}"
  tier          = var.db_tier
}

# --- Backend (usando el módulo) ---
module "backend_service" {
  source                = "./modules/cloud-run-service"
  project_id            = var.project_id
  region                = var.region
  service_name          = "backend-${local.environment}"
  image_url             = var.backend_image_url
  internal_only         = false
  sql_connection_string = module.database.instance_connection_name
  container_port        = var.backend_port

  env_vars = {
    # FRONTEND_URL  = module.frontend_service.service_url
    POSTGRES_USER = module.database.db_user_name
    POSTGRES_DB   = module.database.database_name
    POSTGRES_HOST = "/cloudsql/${module.database.instance_connection_name}"
  }

  secrets = {
    POSTGRES_PASSWORD = "${module.database.password_secret_name}:latest"
    # NEWS_API_KEY       = ""
    # CORE_API_KEY       = ""
    # GCP_PROJECT_ID     = "enube-ai"
    # GCP_LOCATION       = "us-central1"
    # VERTEX_INDEX_ID    = ""
    # VERTEX_ENDPOINT_ID = ""
    # DEPLOYED_INDEX_ID  = ""
    # PERIGON_API_KEY    = ""
    # NEWSAI_API_KEY     = ""
  }
}

# --- Frontend (usando el módulo) ---
# module "frontend_service" {
#   source        = "./modules/cloud-run-service"
#   project_id    = var.project_id
#   region        = var.region
#   service_name  = "frontend-staging"
#   image_url     = var.frontend_image_url
#   internal_only = false

#   env_vars = {
#     BACKEND_API_URL = module.backend_service.service_url
#   }
# }

# # --- Mapeo de Dominio para el Frontend (NUEVO) ---
# module "domain_mapping" {
#   source       = "./modules/cloud-run-domain-mapping"
#   project_id   = var.project_id
#   location     = var.region
#   domain_name  = var.custom_domain
#   service_name = module.frontend_service.service.name # Obtenemos el nombre del servicio del módulo frontend
# }

resource "google_project_service" "vertex_ai_api" {
  project                    = var.project_id
  service                    = "aiplatform.googleapis.com"
  disable_dependent_services = false
}

module "vector-search" {
  source = "./modules/vector-search"

  depends_on = [google_project_service.vertex_ai_api]

  project_id          = var.project_id
  region              = var.region
  display_name_prefix = var.app_name
  machine_type        = var.vector_search_machine_type
  dimensions = 768

}
