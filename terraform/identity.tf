# resource "kubernetes_service_account" "airflow_k8sa" {
#   metadata {
#     name      = keys(var.service_accounts)[1]
#     namespace = "external-secrets"
#     annotations = {
#       "iam.gke.io/gcp-service-account" : "${keys(var.service_accounts)[1]}@${var.project}.iam.gserviceaccount.com"
#     }
#   }
#   depends_on = [helm_release.external_secrets]
# }

resource "kubernetes_annotations" "airflow_k8sa" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = keys(var.service_accounts)[1]
    namespace = "external-secrets"
  }
  annotations = {
    "iam.gke.io/gcp-service-account" : "${keys(var.service_accounts)[1]}@${var.project}.iam.gserviceaccount.com"
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

# resource "google_service_account" "service_account" {
#   for_each     = var.service_accounts_roles
#   account_id   = each.key
#   display_name = each.key
#   description  = "Service account to access the secret manager for External Secrets application."
#   project      = var.project
#   # depends_on   = [kubernetes_service_account.airflow_k8sa]
# }

resource "google_service_account" "service_account" {
  for_each     = var.service_accounts
  account_id   = each.key
  display_name = each.key
  description  = "Service account to access the secret manager for External Secrets application."
  project      = var.project
  # depends_on   = [kubernetes_service_account.airflow_k8sa]
}

resource "google_project_iam_member" "project_iam_member" {
  # for_each = var.service_accounts_roles
  for_each = { for i, values in var.service_accounts_roles : i => values }
  project  = var.project
  # role     = [for k,v in each.value : v]
  # role     = [for i in values(var.service_accounts_roles.airflow) : i]
  # role = flatten([for key, list_value in each.value: [ for item in list_value: item]])
  # role = element([for item in each.value : item],)
  role = var.service_accounts_roles[each.key].permissions
  # member   = "serviceAccount:${google_service_account.service_account[each.key].email}"
  member = "serviceAccount:${google_service_account.service_account[var.service_accounts_roles[each.key].name].email}"
  # depends_on = [kubernetes_service_account.airflow_k8sa]
}

resource "google_service_account_iam_binding" "sa_iam_member_bind" {
  for_each           = var.service_accounts
  service_account_id = google_service_account.service_account[each.key].id
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.project}.svc.id.goog[${each.key}/${each.key}]"]
  # depends_on         = [kubernetes_service_account.airflow_k8sa]
  depends_on         = [kubernetes_annotations.airflow_k8sa]
}