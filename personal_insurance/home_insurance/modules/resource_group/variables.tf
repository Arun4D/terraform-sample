variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."

  validation {
    condition     = contains(["eastus", "westus"], lower(var.resource_group_location))
    error_message = "Unsupported Azure Region specified. Supported regions include: eastus, westus"
  }
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}


variable "resource_group_name" {
  default     = ""
  description = "Resource group name."
}


variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
}