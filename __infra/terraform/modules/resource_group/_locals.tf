locals {
  resource_group = "rg-${var.name}"

  # <subscription>-<resource-group>
  resource_group_full = "${data.azurerm_subscription.current.display_name}-${local.resource_group}"
}
