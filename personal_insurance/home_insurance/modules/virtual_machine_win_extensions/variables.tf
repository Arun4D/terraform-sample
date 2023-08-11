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

variable "storage_account_name" {
  type        = string
  description = ""
}
variable "azurerm_user_assigned_identity_id" {
  type        = string
  description = ""
}


variable "storage_account_primary_access_key" {
  type        = string
  description = ""
}

variable "azurerm_log_analytics_workspace_id" {
  type        = string
  description = ""
}
variable "azurerm_log_analytics_workspace_primary_shared_key" {
  type        = string
  description = ""
}
