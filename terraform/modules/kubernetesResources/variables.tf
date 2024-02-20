variable "namespaces" {
  type = list(
    object({
        name = string
    })
  )
  default = [
    { name = "argocd" },
    { name = "external-secrets" },
    { name = "airflow" }
  ]
}
