# --- Configuración General ---
provider "google" {
  project = var.project_id
  region  = var.region
}

# --- Base de Datos (usando el módulo) ---
module "database" {
  source        = "../../modules/cloud-sql-postgres"
  project_id    = var.project_id
  region        = var.region
  instance_name = "staging-db-instance"
  database_name = "app-db-staging"
  db_user_name  = "app-user-staging"
  tier          = "db-f1-micro"
}

# --- Backend (usando el módulo) ---
module "backend_service" {
  source                = "../../modules/cloud-run-service"
  project_id            = var.project_id
  region                = var.region
  service_name          = "backend-staging"
  image_url             = var.backend_image_url
  internal_only         = true
  sql_connection_string = module.database.instance_connection_name

  env_vars = {
    FRONTEND_URL = module.frontend_service.service_url
    DB_NAME      = module.database.database_name
    DB_USER      = module.database.db_user_name
  }

  secrets = {
    DB_PASSWORD = "${module.database.password_secret_name}:latest"
  }
}

# --- Frontend (usando el módulo) ---
module "frontend_service" {
  source        = "../../modules/cloud-run-service"
  project_id    = var.project_id
  region        = var.region
  service_name  = "frontend-staging"
  image_url     = var.frontend_image_url
  internal_only = false

  env_vars = {
    BACKEND_API_URL = module.backend_service.service_url
  }
}

# --- Mapeo de Dominio para el Frontend (NUEVO) ---
module "domain_mapping" {
  source       = "../../modules/cloud-run-domain-mapping"
  project_id   = var.project_id
  location     = var.region
  domain_name  = var.custom_domain
  service_name = module.frontend_service.service.name # Obtenemos el nombre del servicio del módulo frontend
}
