resource "google_storage_bucket" "airflow_logging" {
  name                        = var.bucket_name
  location                    = var.project_region
  force_destroy               = var.bucket_destroy
  storage_class               = var.bucket_class
  public_access_prevention    = var.bucket_access
  uniform_bucket_level_access = true
}