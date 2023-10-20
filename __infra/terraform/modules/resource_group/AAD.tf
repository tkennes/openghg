#Create the reader AAD Group to provide access control.
resource "azuread_group" "rg_reader_group" {
  display_name            = "${local.resource_group_full}-readers"
  owners                  = concat([data.azuread_client_config.current.object_id])
  description             = "Reader rights for resource group: ${local.resource_group}"
  prevent_duplicate_names = true
  security_enabled        = true
  assignable_to_role      = false
}

resource "azuread_group_member" "rg_readers" {
  count            = length(var.readers)
  group_object_id  = azuread_group.rg_reader_group.id
  member_object_id = var.readers[count.index]
}

resource "azurerm_role_assignment" "rg_readers_role_assignment" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.rg_reader_group.object_id
}

#Create the reader AAD Group to provide access control.
resource "azuread_group" "rg_contributors_group" {
  display_name            = "${local.resource_group_full}-contributors"
  owners                  = concat([data.azuread_client_config.current.object_id])
  description             = "Contributor rights for resource group: ${local.resource_group}"
  prevent_duplicate_names = true
  security_enabled        = true
  assignable_to_role      = false
}

resource "azuread_group_member" "rg_contributors" {
  count            = length(var.contributors)
  group_object_id  = azuread_group.rg_contributors_group.id
  member_object_id = var.contributors[count.index]
}

resource "azurerm_role_assignment" "rg_contributors_role_assignment" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.rg_contributors_group.object_id
}

#Create the Owner AAD Group to provide access control.
resource "azuread_group" "rg_owner_group" {
  display_name            = "${local.resource_group_full}-owners"
  owners                  = concat([data.azuread_client_config.current.object_id])
  description             = "Owner rights for resource group: ${local.resource_group}"
  prevent_duplicate_names = true
  security_enabled        = true
  assignable_to_role      = false
}

resource "azuread_group_member" "rg_owners" {
  count            = length(var.owners)
  group_object_id  = azuread_group.rg_owner_group.id
  member_object_id = var.owners[count.index]
}

resource "azurerm_role_assignment" "rg_owners_role_assignment" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.rg_owner_group.object_id
}
