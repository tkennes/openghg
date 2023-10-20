variable "name" {
  type        = string
  description = "Name of the subnet to create"
  validation {
    condition     = can(regex("^snet-.*$", var.name))
    error_message = "The subnet name must start with snet-"
  }
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network name"
  type        = string
}

variable "address_prefixes" {
  description = "The address prefix list to use for the subnet."
  type        = list(string)
}

variable "subnet_delegation" {
  description = <<EOD
Configuration delegations on subnet
object({
  name = object({
    name = string,
    actions = list(string)
  })
})
EOD
  type        = map(list(any))
  default     = {}
}
