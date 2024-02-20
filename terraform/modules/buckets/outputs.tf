output "GCS_Bucket" {
  value = google_storage_bucket.airflow_logging.name
}