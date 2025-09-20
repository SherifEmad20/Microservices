provider "helm" {
  kubernetes = {
    host                   = var.aks_host
    cluster_ca_certificate = base64decode(var.aks_cluster_ca_certificate)
    client_certificate     = base64decode(var.aks_client_certificate)
    client_key             = base64decode(var.aks_client_key)
  }
}


resource "helm_release" "this" {
  name = var.charts_name

  repository       = var.repository
  chart            = var.charts_name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  version          = var.charts_version

  set = [
    {
      name  = "installCRDs"
      value = var.install_crds ? "true" : "false"
    }
  ]

  depends_on = [var.aks_cluster_id]
}