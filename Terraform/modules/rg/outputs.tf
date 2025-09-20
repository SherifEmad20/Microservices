output "resource_group_id" {
    value = azurerm_resource_group.aks_rg.id
    description = "Value of the ID of the resource group"
}

output "resource_group_name" {
    value = azurerm_resource_group.aks_rg.name
    description = "Value of the name of the resource group"
}
