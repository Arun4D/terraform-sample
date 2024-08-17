variable "resource_group_rg_location" {
  default     = ""
  description = "resource_group rg location."
}

variable "resource_group_rg_name" {
  default     = ""
  description = "resource_group rg name."
}

variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
}

variable "virtual_machine_id" {
  type        = string
  description = "virtual machine id."
}
variable "os_type" {
  type        = string
  description = "virtual machine os type."
}

variable "azurerm_log_analytics_workspace_id" {
  type        = string
  description = ""
}