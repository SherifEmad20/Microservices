output "vnet_id" {
    value       = azurerm_virtual_network.this.id
    description = "ID of the VNet."
}

output "vnet_name" {
    value       = azurerm_virtual_network.this.name
    description = "Name of the VNet."
}