resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = var.address_spaces

  tags = var.tags
}
