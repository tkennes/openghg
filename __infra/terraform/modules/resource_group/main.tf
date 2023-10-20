#Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group
  location = var.location
  tags     = var.tags
}
