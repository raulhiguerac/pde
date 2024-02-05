resource "google_container_cluster" "airflow_cluster" {
  name     = var.gke_name
  location = var.project_region_zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.private_subnet.id

  default_max_pods_per_node = 55

  ip_allocation_policy {
    cluster_secondary_range_name  = var.vpc_secondary_ip_ranges.gke-pods.secondary_range.range_name
    services_secondary_range_name = var.vpc_secondary_ip_ranges.gke-services.secondary_range.range_name
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  depends_on = [google_compute_subnetwork.private_subnet, google_project_service.gcp_services]

  deletion_protection = false
}

resource "google_container_node_pool" "gke_nodes" {
  name       = "airflow-nodes-pool"
  location   = var.project_region_zone
  cluster    = google_container_cluster.airflow_cluster.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_size_gb = 10

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [google_container_cluster.airflow_cluster]
}

# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     annotations = {
#       name = "argocd"
#     }
#     labels = {
#       istio-injection = "enabled"
#     }
#     name = "argocd"
#   }
#   depends_on = [google_container_node_pool.gke_nodes]
# }

resource "kubernetes_namespace" "namespaces" {
  for_each = { for i, values in var.namespaces : i => values }
  metadata {
    annotations = {
      name = var.namespaces[each.key].name
    }
    name = var.namespaces[each.key].name
  }
  depends_on = [google_container_node_pool.gke_nodes]
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  # version              = "25.0.0"
  project_id           = var.project
  cluster_name         = data.google_container_cluster.airflow_cluster.name
  location             = data.google_container_cluster.airflow_cluster.location
  use_private_endpoint = false

  depends_on = [google_container_cluster.airflow_cluster]
}