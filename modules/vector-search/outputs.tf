output "VERTEX_INDEX_ID" {
  description = "Vertex AI index ID for vector search"
  value       = google_vertex_ai_index.vector_index.id
}


output "VERTEX_ENDPOINT_ID" {
  description = "Vertex AI endpoint ID associated with the index"
  value       = google_vertex_ai_index_endpoint.vector_endpoint.id
}


output "DEPLOYED_INDEX_ID" {
  description = "Deployed index ID inside the Vertex AI endpoint"
  value       = google_vertex_ai_index_endpoint_deployed_index.vector_deployed_index.deployed_index_id
}


output "VECTOR_BUCKET_URI" {
  description = "GCS bucket URI used to store vector embeddings"
  value       = google_storage_bucket.vector_search_bucket.url
}
