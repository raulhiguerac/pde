variable "project_region" {
  description = "region of the resources in the project"
  type        = string
}

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