# Este archivo contiene los valores específicos para el ambiente de staging
# ¡NUNCA subas secretos a este archivo!

project_id = "tu-gcp-project-id"
region     = "us-central1"

# Asegúrate de que estas imágenes ya existan en tu Artifact Registry
frontend_image_url = "us-central1-docker.pkg.dev/tu-gcp-project-id/mi-repo/mi-frontend-imagen:staging"
backend_image_url  = "us-central1-docker.pkg.dev/tu-gcp-project-id/mi-repo/mi-backend-imagen:staging"
