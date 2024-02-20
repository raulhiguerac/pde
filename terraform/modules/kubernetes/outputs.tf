output "vpc_network" {
  value = google_compute_network.vpc_network.id
}


output "instance_ip_cluster" {
  value = google_container_cluster.airflow_cluster.id
}

output "kubernetes_name" {
  value = google_container_cluster.airflow_cluster.name
}

output "kubernetes_location" {
  value = google_container_cluster.airflow_cluster.location
}