variable "charts_name" {
  description = "The name of the cert-manager chart"
  type        = string
} 

variable "repository" {
  description = "The Helm repository URL"
  type        = string
}

variable "namespace" {
  description = "The namespace to install into"
  type        = string
}

variable "charts_version" {
  description = "The version of the chart to use"
  type        = string
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "install_crds" {
  description = "Whether to install the CRDs"
  type        = bool
  default     = true
}

variable "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  type        = string
}

variable "aks_host" {
  description = "The AKS cluster host"
  type        = string
}
variable "aks_cluster_ca_certificate" {
  description = "The AKS cluster CA certificate in base64"
  type        = string
}

variable "aks_client_certificate" {
  description = "The AKS client certificate in base64"
  type        = string
}

variable "aks_client_key" {
  description = "The AKS client key in base64"
  type        = string
}
