# Retrieve the active subscription name, used in AAD group naming
data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}
