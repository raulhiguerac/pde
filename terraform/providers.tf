terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.25.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "google" {
  user_project_override = true
  project               = var.project
  credentials           = file(var.service_account)
}

provider "kubernetes" {
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
    host                   = module.gke_auth.host
    token                  = module.gke_auth.token
  }
}