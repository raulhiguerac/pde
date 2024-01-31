data "google_client_config" "provider" {}

data "google_container_cluster" "airflow_cluster" {
  name     = google_container_cluster.airflow_cluster.name
  location = google_container_cluster.airflow_cluster.location
}