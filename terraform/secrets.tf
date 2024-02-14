resource "google_secret_manager_secret" "secreto_prueba" {
  for_each  = local.airflow_secrets
  secret_id = each.key

  labels = {
    label = "airflow"
  }

  replication {
    auto {}
  }

  depends_on = [google_project_service.gcp_services]
}

resource "google_secret_manager_secret_version" "supersecret_data" {
  for_each = local.airflow_secrets
  # secret      = google_secret_manager_secret.secreto_prueba[each.key == "git-secret" ? file(each.key) : each.key].id
  secret      = google_secret_manager_secret.secreto_prueba[each.key].id
  secret_data = each.value
  depends_on  = [google_secret_manager_secret.secreto_prueba]
}