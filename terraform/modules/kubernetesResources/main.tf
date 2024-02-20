resource "kubernetes_namespace" "namespaces" {
  for_each = { for i, values in var.namespaces : i => values }
  metadata {
    annotations = {
      name = var.namespaces[each.key].name
    }
    name = var.namespaces[each.key].name
  }
  # depends_on = [google_container_node_pool.gke_nodes]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"

  depends_on = [kubernetes_namespace.namespaces]
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  repository = "https://charts.external-secrets.io"
  namespace  = "external-secrets"

  set {
    name  = "installCRDs"
    value = true
  }

  depends_on = [kubernetes_namespace.namespaces]
}