resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  project                 = var.project
  routing_mode            = var.vpc_routing_mode
  auto_create_subnetworks = var.vpc_subnetworks
  # depends_on              = [google_project_service.gcp_services]
}

resource "google_compute_subnetwork" "private_subnet" {
  name               = var.vpc_subnet_name
  ip_cidr_range      = var.vpc_cidr_range
  region             = var.project_region
  network            = google_compute_network.vpc_network.id
  secondary_ip_range = [for r in var.vpc_secondary_ip_ranges : r.secondary_range]
}

resource "google_container_cluster" "airflow_cluster" {
  name     = var.gke_name
  location = var.project_region_zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.private_subnet.id

  default_max_pods_per_node = var.gke_pods

  ip_allocation_policy {
    cluster_secondary_range_name  = var.vpc_secondary_ip_ranges.gke-pods.secondary_range.range_name
    services_secondary_range_name = var.vpc_secondary_ip_ranges.gke-services.secondary_range.range_name
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  depends_on = [google_compute_subnetwork.private_subnet]

  deletion_protection = false
}

resource "google_container_node_pool" "gke_nodes" {
  name       = var.name_node_pool
  location   = var.project_region_zone
  cluster    = google_container_cluster.airflow_cluster.name
  node_count = var.number_nodes

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [google_container_cluster.airflow_cluster]
}