resource "azurerm_recovery_services_vault" "vault" {
  name                = var.recovery_services_vault_name
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  sku                 = var.recovery_services_vault_sku
  tags                = var.default_tags
}

resource "azurerm_storage_account" "ad_in_file_share_sa" {
  name                     = var.storage_account_name
  location                 = var.resource_group_rg_location
  resource_group_name      = var.resource_group_rg_name
  account_tier             = var.storage_account_account_tier
  account_replication_type = var.storage_account_account_replication_type
  tags                     = var.default_tags
}

resource "azurerm_storage_share" "example" {
  name                 = var.storage_share
  storage_account_name = azurerm_storage_account.ad_in_file_share_sa.name
  quota                = 1
}


resource "azurerm_backup_container_storage_account" "protection-container" {
  resource_group_name = var.resource_group_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  storage_account_id  = azurerm_storage_account.ad_in_file_share_sa.id
}

resource "azurerm_backup_policy_file_share" "example" {
  name                = var.backup_policy_file_share_name
  resource_group_name = var.resource_group_rg_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  backup {
    frequency = var.backup_policy_file_share_backup_frequency
    time      = var.backup_policy_file_share_backup_time
  }

  retention_daily {
    count = var.backup_policy_file_share_retention_daily_count
  }
  tags = var.default_tags
}

resource "azurerm_backup_protected_file_share" "share1" {
  resource_group_name       = var.resource_group_rg_name
  recovery_vault_name       = azurerm_recovery_services_vault.vault.name
  source_storage_account_id = azurerm_backup_container_storage_account.protection-container.storage_account_id
  source_file_share_name    = azurerm_storage_share.example.name
  backup_policy_id          = azurerm_backup_policy_file_share.example.id
}