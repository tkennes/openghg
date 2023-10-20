module "vnet" {
  source = "./modules/virtual_network"

  resource_group_name = module.rg.name
  name                = "vnet-${var.identifier}"
  address_spaces      = ["10.30.0.0/16"]

  tags = {
    "ManagedBy" = "Terraform"
  }


  depends_on = [module.rg]
}

module "subnet" {
  source = "./modules/subnet"

  name                 = "snet-${var.identifier}"
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.30.0.0/21"]

  depends_on = [
    module.vnet
  ]
}
