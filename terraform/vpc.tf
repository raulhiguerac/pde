resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  project                 = var.project
  routing_mode            = var.vpc_routing_mode
  auto_create_subnetworks = var.vpc_subnetworks
  depends_on              = [google_project_service.gcp_services]
}

resource "google_compute_subnetwork" "private_subnet" {
  name               = var.vpc_subnet_name
  ip_cidr_range      = "10.0.0.0/16"
  region             = var.project_region
  network            = google_compute_network.vpc_network.id
  secondary_ip_range = [for r in var.vpc_secondary_ip_ranges : r.secondary_range]
}