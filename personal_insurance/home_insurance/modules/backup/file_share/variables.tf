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

variable "recovery_services_vault_name" {
  type        = string
  default     = "tfex-recovery-vault"
  description = "Recovery services vault name"
}

variable "recovery_services_vault_sku" {
  type        = string
  default     = "Standard"
  description = "Recovery services vault sku"
}

variable "storage_account_name" {
  type        = string
  default     = "examplesa"
  description = "storage account name."
   validation {
    condition     = (length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24 && length(regex("[a-z0-9]+", var.storage_account_name)) == length(var.storage_account_name))
    error_message = "can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long"
  }
}

variable "storage_account_account_tier" {
  type        = string
  default     = "Standard"
  description = "storage account tier."
}

variable "storage_account_account_replication_type" {
  type        = string
  default     = "LRS"
  description = "storage account replication type."
}

variable "storage_share" {
  type        = string
  default     = "example-share"
  description = "storage share name."
}

variable "backup_policy_file_share_name" {
  type        = string
  default     = "tfex-recovery-vault-policy"
  description = "Backup policy file share name."
}

variable "backup_policy_file_share_backup_frequency" {
  type        = string
  default     = "Daily"
  description = "Backup policy file share backup frequency."
}

variable "backup_policy_file_share_backup_time" {
  type        = string
  default     = "23:00"
  description = "Backup policy file share backup time."
}

variable "backup_policy_file_share_retention_daily_count" {
  type        = number
  default     = 10
  description = "Backup policy file share retention daily count."
}