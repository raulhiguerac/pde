# resource "google_sql_database_instance" "airflow_instance" {
#   name             = var.db_instance_name
#   database_version = var.db_version

#   region = var.project_region

#   settings {
#     tier      = var.db_tier
#     edition   = var.db_edition
#     disk_size = var.db_disk_size
#     ip_configuration {

#     }
#   }
# }

# resource "google_sql_database" "airflow" {
#   name     = "airflow_db"
#   instance = google_sql_database_instance.airflow_instance.name

#   depends_on = [ google_sql_database_instance.airflow_instance ]
# }