output "azurerm_disk_encryption_set_id" {
  value = azurerm_disk_encryption_set.example.id
}

output "encryp_set_key_vault_key_id" {
  value = azurerm_disk_encryption_set.example.key_vault_key_id
}
output "encryp_key_vault_id" {
  value = azurerm_key_vault.example.id
}

output "encryp_key_vault_uri" {
  value = azurerm_key_vault.example.vault_uri
}

output "encryp_key_vault_key_id" {
  value = azurerm_key_vault_key.example.id
}

output "encryp_key_vault_access_policy_id" {
  value = azurerm_key_vault_access_policy.ad-disk-encryption.id
}

