resource "azurerm_storage_account" "audit_storage_account" {
  count = var.enable_log_analytics_workspace && var.log_analytics_workspace_id == null ? 1 : 0

  name                     = "st${replace(var.name, "_", "")}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}