resource "azurerm_virtual_network" "this" {
    name                = var.virtual_network_name
    address_space       = var.address_space_list
    location            = var.location
    resource_group_name = var.resource_group_name

    tags = {
        environment = var.environment
        project     = var.project
    }

}
