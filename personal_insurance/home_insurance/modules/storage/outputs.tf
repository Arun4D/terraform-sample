output "storage_account" {
  value = azurerm_storage_account.my_storage_account.id
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.my_storage_account.primary_blob_endpoint
}