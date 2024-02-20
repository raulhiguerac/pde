variable "service_account" {

}

variable "project" {
  description = "name of the gcp project"
  type        = string
}

variable "bucket_name" {
  description = "name of the bucket to store airflow logs"
  type        = string
}

variable "project_region" {
  description = "region of the resources in the project"
  type        = string
}

variable "project_region_zone" {

}

variable "bucket_class" {
  description = "storage class of the bucket"
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

variable "service_account_name" {
  type = string
}

variable "vpc_name" {
  description = "name of the vpc network"
  type        = string
}

variable "vpc_subnet_name" {
  description = "name of the vpc subnet"
  type        = string
}

variable "gke_name" {
  description = "gke cluster name"
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

variable "airflow_secrets" {
  description = "variable that contains all the secrets (user_db,password)"
  type        = map(any)
}