# resource "google_artifact_registry_repository" "custom_images_repository" {
#   location      = var.project_region
#   repository_id = var.repository_id
#   description   = "docker repository for custom images"
#   format        = var.repository_format

#   docker_config {
#     immutable_tags = var.repository_tags
#   }
# }