variable "virtual_network_name" {
    description = "The name of the Virtual Network"
    type        = string
}

variable "address_space_list" {
    description = "The address space list for the Virtual Network"
    type        = list(string)
}

variable "location" {
    description = "The Azure location where the Virtual Network will be created"
    type        = string
}

variable "resource_group_name" {
    description = "The name of the Azure Resource Group"
    type        = string
}

variable "environment" {
    description = "The environment tag for the Virtual Network"
    type        = string
    default     = "Development"
}

variable "project" {
    description = "The project tag for the Virtual Network"
    type        = string
    default     = "Github runner"
}

