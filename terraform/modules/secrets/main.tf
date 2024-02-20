resource "google_secret_manager_secret" "secrets" {
  for_each  = tomap(var.airflow_secrets)
  secret_id = each.key

  labels = {
    label = "airflow"
  }

  replication {
    auto {}
  }

  # depends_on = [google_project_service.gcp_services]
}

resource "google_secret_manager_secret_version" "data" {
  for_each    = tomap(var.airflow_secrets)
  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value
  depends_on  = [google_secret_manager_secret.secrets]
}