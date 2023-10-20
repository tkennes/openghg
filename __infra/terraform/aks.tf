module "aks" {
  source = "./modules/aks"

  name                = "aks${var.identifier}"
  resource_group_name = module.rg.name
  dns_prefix          = "openghg"

  default_pool_name = "default"

  user_assigned_identity_id = azurerm_user_assigned_identity.main.id

  enable_azure_active_directory   = true
  rbac_aad_managed                = true
  rbac_aad_admin_group_object_ids = [azuread_group.k8sadmins.object_id]

  node_resource_group = "aks-${var.identifier}"

  private_cluster_enabled = false

  enable_auto_scaling  = true
  max_pods             = 100
  orchestrator_version = "1.26.3"
  vnet_subnet_id       = module.subnet.id
  max_count            = 3
  min_count            = 1
  node_count           = 1

  enable_log_analytics_workspace = true

  network_plugin = "azure"
  network_policy = "calico"

  kubernetes_version = "1.26.3"

  only_critical_addons_enabled = true

  node_pools = [
    {
      name                 = "generic"
      availability_zones   = []
      enable_auto_scaling  = true
      max_pods             = 30
      orchestrator_version = "1.26.3"
      priority             = "Regular"
      max_count            = 2
      min_count            = 1
      node_count           = 1
      os_disk_size_gb      = 128
      vm_size              = "Standard_B2s"
    }
  ]

  tags = {
    "ManagedBy" = "Terraform"
  }

  depends_on = [
    module.rg,
    module.subnet,
    azurerm_role_assignment.network
  ]
}