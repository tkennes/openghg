resource "azurerm_kubernetes_cluster" "aks" {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].tags
    ]
  }

  name                             = var.name
  location                         = data.azurerm_resource_group.rg.location
  resource_group_name              = data.azurerm_resource_group.rg.name
  dns_prefix                       = var.dns_prefix
  azure_policy_enabled             = var.enable_azure_policy
  http_application_routing_enabled = var.enable_http_application_routing
  workload_identity_enabled        = var.workload_identity_enabled
  oidc_issuer_enabled              = var.oidc_issuer_enabled

  default_node_pool {
    name                         = var.default_pool_name
    vm_size                      = var.vm_size
    zones                        = var.availability_zones
    enable_auto_scaling          = var.enable_auto_scaling
    enable_host_encryption       = var.enable_host_encryption
    enable_node_public_ip        = var.enable_node_public_ip
    max_pods                     = var.max_pods
    node_labels                  = var.node_labels
    only_critical_addons_enabled = var.only_critical_addons_enabled
    orchestrator_version         = var.orchestrator_version
    os_disk_size_gb              = var.os_disk_size_gb
    os_disk_type                 = var.os_disk_type
    type                         = var.agent_type
    vnet_subnet_id               = var.vnet_subnet_id

    temporary_name_for_rotation = "${var.default_pool_name}tmp"

    max_count  = var.enable_auto_scaling == true ? var.max_count : null
    min_count  = var.enable_auto_scaling == true ? var.min_count : null
    node_count = var.node_count

    dynamic "upgrade_settings" {
      for_each = var.max_surge == null ? [] : ["upgrade_settings"]
      content {
        max_surge = var.max_surge
      }
    }

    tags = var.agent_tags
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  dynamic "oms_agent" {
    for_each = var.enable_log_analytics_workspace ? ["oms_agent"] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id == null ? azurerm_log_analytics_workspace.main[0].id : var.log_analytics_workspace_id
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_azure_active_directory && var.rbac_aad_managed ? ["rbac"] : []
    content {
      managed                = true
      admin_group_object_ids = var.rbac_aad_admin_group_object_ids
    }
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    outbound_type      = var.outbound_type
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
    load_balancer_sku  = var.load_balancer_sku
  }

  automatic_channel_upgrade       = var.automatic_channel_upgrade
  kubernetes_version              = var.kubernetes_version
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  disk_encryption_set_id          = var.disk_encryption_set_id
  private_cluster_enabled         = var.private_cluster_enabled
  private_dns_zone_id             = var.private_dns_zone_id
  node_resource_group             = var.node_resource_group
  sku_tier                        = var.sku_tier

  tags = var.tags
}


module "node-pools" {
  source = "../../modules/aks-node-pools"

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = var.vnet_subnet_id

  node_pools = var.node_pools
}
