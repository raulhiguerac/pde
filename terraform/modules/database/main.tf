resource "google_compute_global_address" "private_ip_address" {
  provider      = google-beta
  name          = var.name_private_ip_adress
  purpose       = var.purpose_private_ip_adress
  address_type  = var.adress_type_private_ip_adress
  prefix_length = var.prefix_private_ip_adress
  network       = var.network_private_ip_adress //necessary
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = var.network_vpc_connection //necessary
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "airflow_instance" {
  name             = var.db_instance_name //necessary
  database_version = var.db_version //necessary

  region = var.project_region

  settings {
    tier      = var.db_tier //necessary
    edition   = var.db_edition //necessary
    disk_size = var.db_disk_size //necessary
    ip_configuration {
      ipv4_enabled    = true // to connect from external ip 
      private_network = var.instance_private_network //necessary
    }
  }

  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "airflow" {
  name     = var.database_name
  instance = google_sql_database_instance.airflow_instance.name

  depends_on = [google_sql_database_instance.airflow_instance]
}

resource "google_sql_user" "airflow_user" {
  name     = var.airflow_secrets.airflow-db-user
  password = var.airflow_secrets.airflow-db-password
  instance = google_sql_database_instance.airflow_instance.name

  depends_on = [google_sql_database_instance.airflow_instance]
}