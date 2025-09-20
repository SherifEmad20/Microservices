# Output for Resource Group ID and Name
output "resource_group_id" {
    value = module.resource_group.resource_group_id
    description = "Value of the ID of the resource group"
}

# Output for Resource Group Name
output "resource_group_name" {
    value = module.resource_group.resource_group_name
    description = "Value of the name of the resource group"
}

# Output for ACR Login Server
output "acr_login_server" {
    value = module.acr.acr_login_server
    description = "The login server URL of the Azure Container Registry."
}

# Output for ACR Admin Username
output "acr_admin_username" {
    value = module.acr.acr_admin_username
    description = "The admin username for the Azure Container Registry."
}

# Output for ACR Admin Password
output "acr_admin_password" {
    value = module.acr.acr_admin_password
    description = "The admin password for the Azure Container Registry."
    sensitive = true
}

# Output for ACR Resource ID
output "acr_id" {
    value = module.acr.acr_id
    description = "The resource ID of the Azure Container Registry."
}

# Outputs for AKS Cluster kubeconfig
output "kube_config" {
    description = "Kube config for the AKS cluster"
    value       = module.aks.kube_config
    sensitive   = true
    }

# Outputs for AKS Cluster kubeconfig
output "kube_config_raw" {
    description = "Raw kube config for the AKS cluster"
    value       = module.aks.kube_config_raw
    sensitive   = true
    }

# Output for AKS Cluster ID
output "aks_cluster_id" {
    description = "The ID of the AKS cluster"
    value       = module.aks.aks_cluster_id
    }

# Output for AKS Cluster Name
output "aks_cluster_name" {
    description = "The name of the AKS cluster"
    value       = module.aks.aks_cluster_name
}

# Outputs for Helm Release cert-manager
output "cert-manager_helm_release_name" {
    description = "The name of the cert-manager helm release"
    value       = module.cert-manager.helm_release_name
}

# Outputs for Helm Release cert-manager
output "cert_manager-helm_release_version" {
    description = "The version of the cert-manager helm release"
    value       = module.cert-manager.helm_release_version
}

# Outputs for Helm Release cert-manager namespace
output "cert_manager-helm_release_namespace" {
    description = "The namespace of the cert-manager helm release"
    value       = module.cert-manager.helm_release_namespace
}

# Outputs for Helm Release cert-manager status
output "cert_manager-helm_release_status" {
    description = "The status of the cert-manager helm release"
    value       = module.cert-manager.helm_release_status
}


# Outputs for Helm Release nginx-ingress
output "nginx-ingress_helm_release_name" {
    description = "The name of the nginx-ingress helm release"
    value       = module.nginx-ingress.helm_release_name
}

# Outputs for Helm Release nginx-ingress
output "nginx_ingress-helm_release_version" {
    description = "The version of the nginx-ingress helm release"
    value       = module.nginx-ingress.helm_release_version
}

# Outputs for Helm Release nginx-ingress namespace
output "nginx_ingress-helm_release_namespace" {
    description = "The namespace of the nginx-ingress helm release"
    value       = module.nginx-ingress.helm_release_namespace
}

# Outputs for Helm Release nginx-ingress status
output "nginx_ingress-helm_release_status" {
    description = "The status of the nginx-ingress helm release"
    value       = module.nginx-ingress.helm_release_status
}
