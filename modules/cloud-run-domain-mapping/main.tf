resource "google_cloud_run_domain_mapping" "mapping" {
  project  = var.project_id
  location = var.location
  name     = var.domain_name

  metadata {
    namespace = var.namespace
  }

  spec {
    route_name = var.service_name
  }
}
