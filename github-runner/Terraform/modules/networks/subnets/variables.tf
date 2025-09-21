variable "subnet_name" {
    description = "The name of the Subnet"
    type        = string
}

variable "address_prefixes" {
    description = "The address prefixes for the Subnet"
    type        = list(string)
}

variable "resource_group_name" {
    description = "The name of the Azure Resource Group"
    type        = string
}

variable "virtual_network_name" {
    description = "The name of the Virtual Network"
    type        = string
}
