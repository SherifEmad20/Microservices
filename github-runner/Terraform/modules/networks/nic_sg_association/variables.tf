variable "network_interface_id" {
  description = "The ID of the Network Interface to associate with the Network Security Group."
  type        = string
}

variable "network_security_group_id" {
  description = "The ID of the Network Security Group to associate with the Network Interface."
  type        = string
}
