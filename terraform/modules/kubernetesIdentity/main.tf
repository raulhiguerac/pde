resource "google_service_account" "service_account" {
  for_each     = toset(var.service_accounts)
  account_id   = each.key
  display_name = each.key
  description  = "Service account to access the secret manager for External Secrets application."
  project      = var.project
}

resource "google_project_iam_member" "project_iam_member" {
  for_each = { for i, values in var.service_accounts_roles : i => values }
  project  = var.project
  role = var.service_accounts_roles[each.key].permissions
  member = "serviceAccount:${google_service_account.service_account[var.service_accounts_roles[each.key].name].email}"
  # depends_on = [google_storage_bucket.airflow_logging]
}

resource "kubernetes_service_account" "airflow_k8sa" {
  for_each = { for i, values in var.service_accounts_binding : i => values }
  metadata {
    name      = var.service_accounts_binding[each.key].ksa-name
    namespace = var.service_accounts_binding[each.key].namespace
    annotations = {
      "iam.gke.io/gcp-service-account" : "${var.service_accounts_binding[each.key].sa-name}@${var.project}.iam.gserviceaccount.com"
    }
  }
  # depends_on = [helm_release.external_secrets]
}

resource "google_service_account_iam_binding" "sa_iam_member_bind" {
  for_each           = { for i, values in var.service_accounts_binding : i => values }
  service_account_id = google_service_account.service_account[var.service_accounts_binding[each.key].sa-name].id
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.project}.svc.id.goog[${var.service_accounts_binding[each.key].namespace}/${var.service_accounts_binding[each.key].ksa-name}]"]
  depends_on         = [kubernetes_service_account.airflow_k8sa]
}