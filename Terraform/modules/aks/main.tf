# Define Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name                = var.aks_cluster_name
    location            = var.location
    resource_group_name = var.resource_group_name
    dns_prefix          = var.dns_prefix

    identity {
        type = var.identity_type
    }

    default_node_pool {
        name       = var.node_pool_name
        node_count = var.node_count
        vm_size    = var.node_vm_size
    }

    tags = {
        environment = var.environment
        project     = var.project
    }
}
