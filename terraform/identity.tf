resource "kubernetes_service_account" "airflow_k8sa" {
  metadata {
    name      = keys(var.service_accounts_roles)[1]
    namespace = "external-secrets"
    annotations = {
      "iam.gke.io/gcp-service-account" : "${keys(var.service_accounts_roles)[1]}@${var.project}.iam.gserviceaccount.com"
    }
  }
  depends_on = [helm_release.external_secrets]
}

# resource "google_service_account" "service_account" {
#   account_id   = "airflow-sa"
#   display_name = "airflow-sa"
#   description  = "Service account to access the secret manager for External Secrets application."
#   project      = var.project
#   depends_on   = [kubernetes_service_account.airflow_k8sa]
# }

resource "google_service_account" "service_account" {
  for_each     = var.service_accounts_roles
  account_id   = each.key
  display_name = each.key
  description  = "Service account to access the secret manager for External Secrets application."
  project      = var.project
  # depends_on   = [kubernetes_service_account.airflow_k8sa]
}

resource "google_project_iam_member" "project_iam_member" {
  for_each = var.service_accounts_roles
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.service_account[each.key].email}"
  # depends_on = [kubernetes_service_account.airflow_k8sa]
}

resource "google_service_account_iam_binding" "sa_iam_member_bind" {
  for_each           = var.service_accounts_roles
  service_account_id = google_service_account.service_account[each.key].id
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.project}.svc.id.goog[${each.key}/${each.key}]"]
  depends_on         = [kubernetes_service_account.airflow_k8sa]
}