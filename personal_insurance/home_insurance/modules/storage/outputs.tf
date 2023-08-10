output "storage_account" {
  value = azurerm_storage_account.my_storage_account.id
}

output "storage_account_name" {
  value = azurerm_storage_account.my_storage_account.name
}


output "storage_account_primary_access_key" {
  value = azurerm_storage_account.my_storage_account.primary_access_key
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.my_storage_account.primary_blob_endpoint
}