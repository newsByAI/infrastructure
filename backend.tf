terraform {
  backend "gcs" {
    bucket = "enube-ai-tfstate"
    prefix = "infra/main-back"
  }
}
