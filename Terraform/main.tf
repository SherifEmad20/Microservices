# Define Resource Group
module "resource_group" {
  source              = "./modules/rg"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
  project             = var.project
}

# Define Azure Container Registry
module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  environment         = var.environment
  project             = var.project
}

# Define Azure Kubernetes Service
module "aks" {
  source              = "./modules/aks" 
  aks_cluster_name    = var.aks_cluster_name
  node_pool_name      = var.node_pool_name
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  environment         = var.environment
  project             = var.project
}

# Deploy cert-manager Helm Charts to AKS
module "cert-manager" {
  source = "./modules/helm_charts"

  # Optional: Override default values if needed
  charts_name      = var.cert_manager-name
  repository       = var.cert_manager-repository
  namespace        = var.cert_manager-namespace
  charts_version   = var.cert_manager-version
  aks_host         = module.aks.kube_config.0.host
  aks_cluster_ca_certificate = module.aks.kube_config.0.cluster_ca_certificate
  aks_client_certificate     = module.aks.kube_config.0.client_certificate
  aks_client_key             = module.aks.kube_config.0.client_key
  aks_cluster_id             = module.aks.aks_cluster_id

}

# Deploy nginx-ingress Helm Charts to AKS
module "nginx-ingress" {
  source = "./modules/helm_charts"

  # Optional: Override default values if needed
  charts_name      = var.nginx_ingress-name
  repository       = var.nginx_ingress-repository
  namespace        = var.nginx_ingress-namespace
  charts_version   = var.nginx_ingress-version
  aks_host         = module.aks.kube_config.0.host
  aks_cluster_ca_certificate = module.aks.kube_config.0.cluster_ca_certificate
  aks_client_certificate     = module.aks.kube_config.0.client_certificate
  aks_client_key             = module.aks.kube_config.0.client_key
  aks_cluster_id             = module.aks.aks_cluster_id

}

# Deploy monitoring-stack Helm Charts to AKS
module "monitoring-stack" {
  source = "./modules/helm_charts"

  # Optional: Override default values if needed
  charts_name      = var.monitoring_stack-name
  repository       = var.monitoring_stack-repository
  namespace        = var.monitoring_stack-namespace
  charts_version   = var.monitoring_stack-version
  aks_host         = module.aks.kube_config.0.host
  aks_cluster_ca_certificate = module.aks.kube_config.0.cluster_ca_certificate
  aks_client_certificate     = module.aks.kube_config.0.client_certificate
  aks_client_key             = module.aks.kube_config.0.client_key
  aks_cluster_id             = module.aks.aks_cluster_id

}