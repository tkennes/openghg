variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create the vnet in"
}


variable "name" {
  type        = string
  description = "Name of the VNET to create"
  validation {
    condition     = can(regex("^vnet-.*$", var.name))
    error_message = "The VNET name must start with vnet-"
  }
}

variable "address_spaces" {
  type        = list(string)
  description = "The addres spaces used for this virtual network"
}

variable "tags" {
  type        = map(any)
  description = "The tags for the resources"
}
