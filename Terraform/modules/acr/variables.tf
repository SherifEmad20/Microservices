variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the ACR."
  type        = string
}

variable "location" {
  description = "The location/region where the ACR will be created."
  type        = string
}

variable "environment" {
  description = "The environment tag for the ACR."
  type        = string
}

variable "project" {
  description = "The project tag for the ACR."
  type        = string
}

variable "sku" {
  description = "The SKU of the Azure Container Registry."
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled."
  type        = bool
  default     = true
}
