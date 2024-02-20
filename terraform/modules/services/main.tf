resource "google_project_service" "cloudresourcemanager_api" {
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "gcp_services" {
  for_each                   = toset(var.services_list)
  project                    = var.project //necessary
  service                    = each.key
  disable_dependent_services = true
  depends_on                 = [google_project_service.cloudresourcemanager_api]
}