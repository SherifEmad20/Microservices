# Terraform variables

# Subscription ID for the Azure resources
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "f2df3cc0-75b8-4b87-8230-ab589470a407"
}

# Resources location
variable "location" {
  default = "East US"
  description = "Azure region for resources"
}

# Name of the Resource Group
variable "resource_group_name" {
  default = "aks-resource-group"
  description = "Name of the Resource Group"
}

# Used as tag for resources
variable "environment" {
  default = "Development"
  description = "Environment tag for resources"
}

# Used as tag for resources
variable "project" {
  default = "Python Microservices Project"
  description = "Project tag for resources"
}

# Azure Container Registry name
variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
  default     = "microservicesAcrRegistry"
}

# Azure Kubernetes Service cluster name
variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
  default     = "myAKSCluster"
}

# Default node pool name
variable "node_pool_name" {
  description = "The name of the default node pool."
  type        = string
  default     = "default"
}

# Number of nodes in the default node pool
variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
  default     = 1
}

# Size of the VM for the nodes in the default node pool
variable "node_vm_size" {
  description = "The size of the VM for the nodes in the default node pool."
  type        = string
  default     = "Standard_D4ads_v6"
}

# Helm chart variables for cert-manager
variable "cert_manager-name" {
  description = "The name of the cert-manager chart"
  type        = string
  default     = "cert-manager"
} 

variable "cert_manager-repository" {
  description = "The Helm repository for cert-manager"
  type        = string
  default     = "https://charts.jetstack.io"
}

variable "cert_manager-namespace" {
  description = "The namespace to install cert-manager into"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager-version" {
  description = "The version of the cert-manager chart to use"
  type        = string
  default     = "v1.18.2"
}

variable "cert_manager-create_namespace_bool" {
  description = "Whether to create the namespace for cert-manager"
  type        = bool
  default     = true
}

variable "cert_manager-install_crds_bool" {
  description = "Whether to install the cert-manager CRDs"
  type        = bool
  default     = true
}

# Helm chart variables for nginx-ingress
variable "nginx_ingress-name" {
  description = "The name of the nginx-ingress chart"
  type        = string
  default     = "nginx-ingress"
} 

variable "nginx_ingress-repository" {
  description = "The Helm repository for nginx-ingress"
  type        = string
  default     = "https://helm.nginx.com/stable"
}

variable "nginx_ingress-namespace" {
  description = "The namespace to install nginx-ingress into"
  type        = string
  default     = "nginx-ingress"
}

variable "nginx_ingress-version" {
  description = "The version of the nginx-ingress chart to use"
  type        = string
  default     = "v2.3.0"
}

variable "nginx_ingress-create_namespace_bool" {
  description = "Whether to create the namespace for nginx-ingress"
  type        = bool
  default     = true
}

variable "nginx_ingress-install_crds_bool" {
  description = "Whether to install the nginx-ingress CRDs"
  type        = bool
  default     = true
}

# Helm chart variables for monitoring stack
variable "monitoring_stack-name" {
  description = "The name of the monitoring stack"
  type        = string
  default     = "kube-prometheus-stack"
} 

variable "monitoring_stack-repository" {
  description = "The Helm repository for monitoring stack"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "monitoring_stack-namespace" {
  description = "The namespace to install monitoring stack into"
  type        = string
  default     = "monitoring-stack"
}

variable "monitoring_stack-version" {
  description = "The version of the monitoring stack chart to use"
  type        = string
  default     = "v77.9.1"
}

variable "monitoring_stack-create_namespace_bool" {
  description = "Whether to create the namespace for monitoring stack"
  type        = bool
  default     = true
}

variable "monitoring_stack-install_crds_bool" {
  description = "Whether to install the monitoring stack CRDs"
  type        = bool
  default     = true
}