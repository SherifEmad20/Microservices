variable "vm_name" {
    description = "The name of the Virtual Machine."
    type        = string
}

variable "location" {
    description = "The Azure region where the Virtual Machine will be created."
    type        = string
}

variable "resource_group_name" {
    description = "The name of the Resource Group in which to create the Virtual Machine."
    type        = string
}

variable "vm_size" {
    description = "The size of the Virtual Machine."
    type        = string
    default     = "Standard_B2s"
}

variable "admin_username" {
    description = "The admin username for the Virtual Machine."
    type        = string
    default     = "azureuser"
}

variable "admin_password" {
    description = "The admin password for the Virtual Machine. Not used if SSH key is provided."
    type        = string
    sensitive   = true
}

variable "network_interface_id" {
    description = "The ID of the Network Interface to attach to the Virtual Machine."
    type        = string
}

