resource "google_compute_global_address" "private_ip_address" {
  provider      = google-beta
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "airflow_instance" {
  name             = var.db_instance_name
  database_version = var.db_version

  region = var.project_region

  settings {
    tier      = var.db_tier
    edition   = var.db_edition
    disk_size = var.db_disk_size
    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.vpc_network.id
    }
  }

  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "airflow" {
  name     = "airflow_db"
  instance = google_sql_database_instance.airflow_instance.name

  depends_on = [google_sql_database_instance.airflow_instance]
}