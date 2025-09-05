terraform {
  backend "gcs" {
    bucket = "automations-466723-tfstate"
    prefix = "infra/dev"
  }
}
