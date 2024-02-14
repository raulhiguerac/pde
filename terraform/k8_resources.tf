data "kubectl_filename_list" "manifests" {
  pattern = "../configuration/*.yaml"
}

resource "kubectl_manifest" "test" {
  count      = length(data.kubectl_filename_list.manifests.matches)
  yaml_body  = file(element(data.kubectl_filename_list.manifests.matches, count.index))
  depends_on = [google_service_account_iam_binding.sa_iam_member_bind]
}