output "nic_id" {
    description = "The ID of the network interface."
    value       = azurerm_network_interface.this.id
}

output "nic_private_ip_address" {
    description = "The private IP address of the network interface."
    value       = azurerm_network_interface.this.private_ip_address
}

output "nic_ip_configuration" {
    description = "The IP configuration of the network interface."
    value       = azurerm_network_interface.this.ip_configuration
}

output "nic_name" {
    description = "The name of the network interface."
    value       = azurerm_network_interface.this.name
}