resource "google_secret_manager_secret" "secreto_prueba" {
  secret_id = "supersecret"

  labels = {
    label = "prueba"
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "supersecret_data" {
  secret = google_secret_manager_secret.secreto_prueba.id

  secret_data = "esto-es-una-prueba"
}