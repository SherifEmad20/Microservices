variable "security_group_name" {
    description = "The name of the Network Security Group"
    type        = string
}

variable "location" {
    description = "The Azure region where the Network Security Group will be created"
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which to create the Network Security Group"
    type        = string
}

variable "allowed_ssh_cidr" {
    description = "The CIDR block allowed to access SSH (port 22)"
    type        = string
    default     = "0.0.0.0/0"
}
