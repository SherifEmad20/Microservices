variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
  default     = 3
}

variable "node_vm_size" {
  description = "The size of the VM for the nodes in the default node pool."
  type        = string
  default     = "Standard_D4ads_v6"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "node_pool_name" {
  description = "The name of the default node pool."
  type        = string
}

variable "environment" {
  description = "The environment tag for the AKS cluster."
  type        = string
}

variable "project" {
  description = "The project tag for the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region where the AKS cluster will be deployed."
  type        = string
}

variable "identity_type" {
  description = "The type of identity for the AKS cluster."
  type        = string
  default     = "SystemAssigned"
  
}

variable "dns_prefix" {
    description = "The DNS prefix for the AKS cluster."
    type        = string
    default     = "aks-dns-prefix"
}

variable "resource_group_name" {
  description = "The name of the resource group where the AKS cluster will be deployed."
  type        = string
}
