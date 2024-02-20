variable "project" {
  description = "name of the gcp project"
  type        = string
}

variable "service_accounts" {
  type    = list(string)
  default = ["airflow", "external-secrets"]
}

variable "service_accounts_roles" {
  type = list(object({
    name        = string
    permissions = string
  }))
  default = [
    {
      name        = "airflow"
      permissions = "roles/storage.admin"
    },
    {
      name        = "airflow"
      permissions = "roles/artifactregistry.reader"
    },
    {
      name        = "airflow"
      permissions = "roles/storage.objectViewer"
    },
    {
      name        = "external-secrets"
      permissions = "roles/secretmanager.admin"
    }
  ]
}

variable "service_accounts_binding" {
  type = list(object({
    ksa-name  = string
    namespace = string
    sa-name   = string
  }))
  default = [
    {
      ksa-name  = "external-secrets-sa"
      namespace = "external-secrets"
      sa-name   = "external-secrets"
    },
    {
      ksa-name  = "airflow-sa"
      namespace = "airflow"
      sa-name   = "airflow"
    }
  ]
}