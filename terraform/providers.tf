terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
  }
}

provider "google" {
  user_project_override = true
  project               = var.project
  credentials           = file(var.service_account)
}