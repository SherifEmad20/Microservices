output "kube_config" {
    description = "Kube config for the AKS cluster"
    value       = azurerm_kubernetes_cluster.aks_cluster.kube_config
    sensitive   = true
    }

output "kube_config_raw" {
    description = "Raw kube config for the AKS cluster"
    value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
    sensitive   = true
    }


output "aks_cluster_id" {
    description = "The ID of the AKS cluster"
    value       = azurerm_kubernetes_cluster.aks_cluster.id
    }

output "aks_cluster_name" {
    description = "The name of the AKS cluster"
    value       = azurerm_kubernetes_cluster.aks_cluster.name
}