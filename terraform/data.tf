data "google_client_config" "provider" {}

data "google_container_cluster" "airflow_cluster" {
  name     = google_container_cluster.airflow_cluster.name
  location = google_container_cluster.airflow_cluster.location
}

# data "google_sql_database_instance" "airflow_instance" {
#   name               = google_sql_database_instance.airflow_instance.name
#   private_ip_address = google_sql_database_instance.airflow_instance.private_ip_address
# }

# data "local_file" "git_key" {
#   filename = "../credentials/keys"
# }