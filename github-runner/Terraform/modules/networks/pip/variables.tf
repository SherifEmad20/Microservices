variable "public_ip_name" {
    description = "The name of the Public IP"
    type        = string
}

variable "location" {
    description = "The Azure location where the Public IP will be created"
    type        = string
}

variable "resource_group_name" {
    description = "The name of the Azure Resource Group"
    type        = string
}

variable "allocation_method" {
    description = "The allocation method for the Public IP (Static or Dynamic)"
    type        = string
    default     = "Static"
}

variable "environment" {
    description = "The environment tag for the Public IP"
    type        = string
    default     = "Development"
}

variable "project" {
    description = "The project tag for the Public IP"
    type        = string
    default     = "Github Runner"
}

