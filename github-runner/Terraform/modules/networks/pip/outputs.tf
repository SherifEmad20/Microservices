output "public_ip_id" {
    value       = azurerm_public_ip.this.id
    description = "The ID of the Public IP."
}

output "public_ip_address" {
    value       = azurerm_public_ip.this.ip_address
    description = "The IP address of the Public IP."
}

output "public_ip_fqdn" {
    value       = azurerm_public_ip.this.fqdn
    description = "The FQDN of the Public IP."
}

output "public_ip_name" {
    value       = azurerm_public_ip.this.name
    description = "The name of the Public IP."
}

