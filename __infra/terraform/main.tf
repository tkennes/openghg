module "rg" {
  source = "./modules/resource_group"

  name     = "${var.identifier}"
  location = var.location
}