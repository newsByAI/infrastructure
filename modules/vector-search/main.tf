
resource "google_storage_bucket" "vector_search_bucket" {
  project      = var.project_id
  name         = "bkt-${var.project_id}-${var.display_name_prefix}-vs" 
  location     = var.region
  uniform_bucket_level_access = true
}


resource "google_vertex_ai_index" "vector_index" {
  project       = var.project_id
  region        = var.region
  display_name  = "${var.display_name_prefix}-index"
  description   = "Índice para búsqueda vectorial con actualizaciones en streaming."
  
  
  metadata {
  
    contents_delta_uri = google_storage_bucket.vector_search_bucket.url
    
    config {
  
      dimensions = var.dimensions
      
      distance_measure_type = "COSINE_DISTANCE"
      feature_norm_type = "UNIT_L2_NORM"
      shard_size = "SHARD_SIZE_SMALL"
      approximate_neighbors_count = 100
      
      
      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count = 500
        }
      }
    }
  }

  index_update_method = "STREAM_UPDATE" 
}

resource "google_vertex_ai_index_endpoint" "vector_endpoint" {
  project      = var.project_id
  region       = var.region
  display_name = "${var.display_name_prefix}-endpoint"
  description  = "Endpoint para el índice de búsqueda vectorial."
  

  network = var.vpc_network
}

resource "google_vertex_ai_index_endpoint_deployed_index" "vector_deployed_index" {
  region          = var.region
  index_endpoint  = google_vertex_ai_index_endpoint.vector_endpoint.id
  
  deployed_index_id = "${var.display_name_prefix}_deployed" 
  display_name      = "${var.display_name_prefix}_deployed_index"
  enable_access_logging = false
  index = google_vertex_ai_index.vector_index.id
  
  dedicated_resources {
    machine_spec {
      machine_type = var.machine_type
    }
    min_replica_count = 1
    max_replica_count = 1 
  }
}