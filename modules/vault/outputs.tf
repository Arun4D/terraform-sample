output "azurerm_key_vault_secret_value" {
  value = azurerm_key_vault_secret.kv_vm_secret.value
}