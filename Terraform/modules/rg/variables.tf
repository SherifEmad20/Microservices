variable "location" {
  default = "East US"
  description = "Azure region for resources"
}

variable "resource_group_name" {
  default = "aks-resource-group"
  description = "Name of the Resource Group"
}

variable "environment" {
  default = "Development"
  description = "Environment tag for resources"
}

variable "project" {
  default = "Python Microservices Project"
  description = "Project tag for resources"
}
