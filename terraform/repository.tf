resource "google_artifact_registry_repository" "custom_images_repository" {
  location      = var.project_region
  repository_id = var.repository_id
  description   = "docker repository for custom images"
  format        = var.repository_format

  docker_config {
    immutable_tags = var.repository_tags
  }

  provisioner "local-exec" {
    command = "docker login -u _json_key --password-stdin https://${var.project_region}-docker.pkg.dev < ../credentials/${var.service_account_name}"
  }

  provisioner "local-exec" {
    command = "docker build -t custom-airflow:1.0 -f ../docker/dockerfile ../docker"
  }

  provisioner "local-exec" {
    command = "docker tag custom-airflow:1.0 ${var.project_region}-docker.pkg.dev/${var.project}/${var.repository_id}/custom-airflow:1.0"
  }

  provisioner "local-exec" {
    command = "docker push ${var.project_region}-docker.pkg.dev/${var.project}/${var.repository_id}/custom-airflow:1.0"
  }
}