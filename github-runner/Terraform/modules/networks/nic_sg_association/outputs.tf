output "network_interface_security_group_association_id" {
    description = "The ID of the network interface security group association."
    value       = azurerm_network_interface_security_group_association.this.id
}

