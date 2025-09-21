output "subnet_id" {
    value       = azurerm_subnet.this.id
    description = "ID of the Subnet."
}

output "subnet_name" {
    value       = azurerm_subnet.this.name
    description = "Name of the Subnet."
}
