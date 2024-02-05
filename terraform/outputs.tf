output "kubernetes_cluster_name" {
  value       = google_container_cluster.airflow_cluster.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.airflow_cluster.endpoint
  description = "GKE Cluster Host"
}

output "services_accounts" {
  value = [for sa in google_service_account.service_account : sa.email]
}