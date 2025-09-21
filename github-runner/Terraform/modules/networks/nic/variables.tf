variable "nic_name" {
    description = "The name of the network interface."
    type        = string
}

variable "location" {
    description = "The location where the network interface will be created."
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which to create the network interface."
    type        = string
}

variable "subnet_id" {
    description = "The ID of the subnet to which the network interface will be connected."
    type        = string
}

variable "private_ip_address_allocation" {
    description = "The private IP address allocation method. Possible values are 'Static' or 'Dynamic'."
    type        = string
    default     = "Dynamic"
}

variable "public_ip_address_id" {
    description = "The ID of the public IP address to associate with the network interface."
    type        = string
    default     = null
}

variable "ip_configuration_name" {
    description = "The name of the IP configuration."
    type        = string
    default     = "internal"
}
