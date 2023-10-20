variable "name" {
  type        = string
  default     = ""
  description = "Name of the resource group"
  validation {
    condition     = can(regex("^rg-", var.name)) == false
    error_message = "The name must NOT start with rg- . This will be added in the module."
  }
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "westeurope"
}

variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of specific tags to assign to the resource group"
  default     = {}
}

variable "readers" {
  description = "List of principal id's to add to the read group"
  type        = list(string)
  default     = []
}

variable "contributors" {
  description = "List of principal id's to add to the contributor group"
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "List of principal id's to add to the owner group"
  type        = list(string)
  default     = []
}

