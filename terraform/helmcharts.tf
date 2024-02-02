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
    name = "installCRDs" 
    value= true
  }

  depends_on = [kubernetes_namespace.namespaces]
}