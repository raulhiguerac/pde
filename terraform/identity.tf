resource "kubernetes_service_account" "airflow_k8sa" {
  metadata {
    name      = "airflow-sa"
    namespace = "external-secrets"
    annotations = {
        "iam.gke.io/gcp-service-account": "airflow-sa@${var.project}.iam.gserviceaccount.com"
    }
  }
  depends_on = [ google_container_cluster.airflow_cluster ]
}

resource "google_service_account" "service_account" {
  account_id   = "airflow-sa"
  display_name = "airflow-sa"
  description  = "Service account to access the secret manager for External Secrets application."
  project      = var.project
  depends_on = [ kubernetes_service_account.airflow_k8sa ]
}

resource "google_project_iam_member" "project_iam_member" {
  project = var.project
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
  depends_on = [ kubernetes_service_account.airflow_k8sa ]
}

resource "google_service_account_iam_binding" "sa_iam_member_bind" {
  service_account_id = google_service_account.service_account.id
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.project}.svc.id.goog[external-secrets/airflow-sa]"]
  depends_on = [ kubernetes_service_account.airflow_k8sa ]
}