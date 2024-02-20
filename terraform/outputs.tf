# output "kubernetes_cluster_name" {
#   value       = google_container_cluster.airflow_cluster.name
#   description = "GKE Cluster Name"
# }

# output "kubernetes_cluster_host" {
#   value       = google_container_cluster.airflow_cluster.endpoint
#   description = "GKE Cluster Host"
# }

# output "airflow_instance" {
#   value = google_sql_database_instance.airflow_instance.private_ip_address
# }

# output "services_accounts" {
#   value = [for sa in google_service_account.service_account : sa.email]
# }