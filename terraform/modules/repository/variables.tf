variable "project" {
  description = "name of the gcp project"
  type        = string
}

variable "project_region" {
  description = "region of the resources in the project"
  type        = string
}

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
  default     = false
}

variable "service_account_name" {
  type = string
}