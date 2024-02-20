output "airflow_instance" {
  value = google_sql_database_instance.airflow_instance.private_ip_address
}
