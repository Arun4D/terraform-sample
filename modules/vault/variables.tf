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

variable "key_vault_name" {
  default     = "kv"
  description = "key vault name."
}

variable "key_vault_sku_name" {
  default     = "standard"
  description = "key vault sku name."
}

variable "key_vault_vm_secret_name" {
  type        = string
  default     = "kv-vm-secret-name"
  description = "key vault vm secret name."
}

