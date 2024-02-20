locals {
  airflow_secrets = {
    "fernet-key"    = var.airflow_secrets.fernet-key
    "webserver-key" = var.airflow_secrets.webserver-key
    "git-secret"    = file(var.airflow_secrets.git-secret)
    "db-conn"       = "postgresql://${var.airflow_secrets.airflow-db-user}:${var.airflow_secrets.airflow-db-password}@${module.database.airflow_instance}:5432/airflow_db"
  }

  #   depends_on = [google_sql_database.airflow]
}