resource "google_storage_bucket" "airflow_logging" {
  name                        = var.bucket_name //necessary
  location                    = var.project_region // necessary
  force_destroy               = var.bucket_destroy
  storage_class               = var.bucket_class //necessary
  public_access_prevention    = var.bucket_access
  uniform_bucket_level_access = true
}