# Output for ACR Login Server
output "acr_login_server" {
    value = azurerm_container_registry.acr.login_server
    description = "The login server URL of the Azure Container Registry."
}

# Output for ACR Admin Username
output "acr_admin_username" {
    value = azurerm_container_registry.acr.admin_username
    description = "The admin username for the Azure Container Registry."
}

# Output for ACR Admin Password
output "acr_admin_password" {
    value = azurerm_container_registry.acr.admin_password
    description = "The admin password for the Azure Container Registry."
    sensitive = true
}

# Output for ACR Resource ID
output "acr_id" {
    value = azurerm_container_registry.acr.id
    description = "The resource ID of the Azure Container Registry."
}