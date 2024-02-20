variable "project" {
  description = "name of the gcp project"
  type        = string
}

variable "services_list" {
  description = "Enable required api's to the project"
  type        = list(string)
  default = [
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}