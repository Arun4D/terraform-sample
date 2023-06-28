# Generate random text for a unique key vault
resource "random_id" "id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.resource_group_rg_name
  }

  byte_length = 8
}

data "azurerm_client_config" "current" {} 

locals {

  l_keyVaultName = "${var.default_tags.environment}-${var.key_vault_name}-${random_id.id.hex}"
}

resource "azurerm_key_vault" "my_key_vault" {
  name                     = local.l_keyVaultName
  location                 = var.resource_group_rg_location
  resource_group_name      = var.resource_group_rg_name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = var.key_vault_sku_name

 /* access_policy  {
    tenant_id = data.azurerm_client_config.current.tenant_id

    ## Need to check.. Object_id is null. Temp fix is added tenant_id instead of object_id
    object_id = data.azurerm_client_config.current.tenant_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]

    storage_permissions = [
      "Get",
    ]

  }*/

  tags                     = var.default_tags
  
} 

resource "random_password" "vm_password" {
  length = 16
  special = true
  override_special = "!#$%&,."
}

resource "azurerm_key_vault_secret" "kv_vm_secret" {
  key_vault_id = azurerm_key_vault.my_key_vault.id
  name = var.key_vault_vm_secret_name
  value = random_password.vm_password.result
}