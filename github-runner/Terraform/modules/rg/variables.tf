variable "location" {
  default = "UK West"
  description = "Azure region for resources"
}

variable "resource_group_name" {
  default = "gh-runner-rg"
  description = "Name of the Resource Group"
}

variable "environment" {
  default = "Development"
  description = "Environment tag for resources"
}

variable "project" {
  default = "Github runner"
  description = "Project tag for resources"
}
