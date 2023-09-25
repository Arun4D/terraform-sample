data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                        = "ad-test-des-kv8"
  location                    = var.resource_group_rg_location
  resource_group_name         = var.resource_group_rg_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.key_vault_sku_name
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
  
    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Sign", "UnwrapKey", "Verify", 
      "WrapKey", "Release", "Rotate", "GetRotationPolicy" , "SetRotationPolicy"
    ]
 
    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Set"
    ]
 
    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers"
    ]
  }

}

resource "azurerm_key_vault_key" "example" {
  name         = "ad-test-des-key8"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  depends_on = [
    azurerm_key_vault.example
  ]
}

resource "azurerm_disk_encryption_set" "example" {
  name                = "ad-test-des8"
  resource_group_name = var.resource_group_rg_name
  location            = var.resource_group_rg_location
  key_vault_key_id    = azurerm_key_vault_key.example.id

  identity {
    type = "SystemAssigned"
  }

  tags = var.default_tags

  depends_on = [ azurerm_key_vault_key.example ]
}



 resource "azurerm_key_vault_access_policy" "ad-disk-encryption" {
  key_vault_id = azurerm_key_vault.example.id

  tenant_id = azurerm_disk_encryption_set.example.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.example.identity.0.principal_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "GetRotationPolicy",
    "UnwrapKey",
    "WrapKey",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
  storage_permissions = [
    "Get",
  ]

depends_on = [ azurerm_disk_encryption_set.example ,azurerm_key_vault.example]
} 

resource "azurerm_role_assignment" "example-disk" {
  scope                = azurerm_key_vault.example.id
  role_definition_name = "Reader"
  principal_id         = azurerm_disk_encryption_set.example.identity.0.principal_id
  depends_on = [ azurerm_disk_encryption_set.example ,azurerm_key_vault.example]
}