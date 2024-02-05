variable "service_account" {
  description = "service account to authenticate gcp project"
  type        = string
}

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

########################## db

variable "project_region" {
  description = "region of the resources in the project"
  type        = string
}

variable "project_region_zone" {
  description = "zone of the region of the resources in the project"
  type        = string
}

variable "db_instance_name" {
  description = "name of the sql instance"
  type        = string
}

variable "db_version" {
  description = "version of the sql db"
  type        = string
}

variable "db_tier" {
  description = "type of the db to use"
  type        = string
}

variable "db_edition" {
  description = "edition type of the db"
  type        = string
}

variable "db_disk_size" {
  description = "db disk size in GB"
  type        = string
}


########################## repository

variable "repository_id" {
  description = "name of the artifact registry repo"
  type        = string
}

variable "repository_format" {
  description = "format of the artifact registry repo"
  type        = string
}

variable "repository_tags" {
  description = "format of the artifact registry repo"
  type        = bool
  default     = true
}

########################## bucket

variable "bucket_name" {
  description = "name of the bucket to store airflow logs"
  type        = string
}

variable "bucket_destroy" {
  description = "enforce to delete all objects of the bucket"
  type        = bool
  default     = true
}

variable "bucket_class" {
  description = "storage class of the bucket"
  type        = string
}

variable "bucket_access" {
  description = "storage class of the bucket"
  type        = string
  default     = "enforced"
}

########################## vpc

variable "vpc_name" {
  description = "name of the vpc network"
  type        = string
}

variable "vpc_subnetworks" {
  description = "subnetworks of vpc"
  type        = bool
  default     = false
}

variable "vpc_routing_mode" {
  description = "routing mode of the vpc"
  type        = string
  default     = "GLOBAL"
}

variable "vpc_subnet_name" {
  description = "name of the vpc subnet"
  type        = string
}

variable "vpc_secondary_ip_ranges" {
  type = map(object({
    secondary_range = object({
      range_name    = string
      ip_cidr_range = string
    })
  }))
  default = {
    gke-pods = {
      secondary_range = {
        range_name    = "gke-pods"
        ip_cidr_range = "192.168.10.0/24"
      }
    }
    gke-services = {
      secondary_range = {
        range_name    = "gke-services"
        ip_cidr_range = "192.170.10.0/24"
      }
    }
  }
}

########################## gke

variable "gke_name" {
  description = "gke cluster name"
  type        = string
}

variable "namespaces" {
  type = list(object({
    name = string
  }))
  default = [
    { name = "argocd" },
    { name = "external-secrets" },
    { name = "airflow" }
  ]
}


########################## service accounts

variable "service_accounts_roles" {
  type = map(any)
  default = {
    "airflow"          = "roles/storage.admin"
    "external-secrets" = "roles/secretmanager.admin"
  }
}