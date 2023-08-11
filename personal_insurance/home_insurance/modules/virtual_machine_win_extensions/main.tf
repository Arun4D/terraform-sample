

resource "azurerm_virtual_machine_extension" "vm_ext_windows" {
  name                       = "VMExtensionWindows"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "vm_ext_iaas_windows" {
  name                       = "IaaSDiagnostics"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.22"

   settings = templatefile(format("%s/diagnostics.json", path.module), {
    resource_id  = var.virtual_machine_id
    storage_name = var.storage_account_name
  })

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${var.storage_account_name}",
        "storageAccountKey": "${var.storage_account_primary_access_key}"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "vm_ext_win_agent_windows" {
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.18"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

settings = jsonencode({
    workspaceId               = var.azurerm_log_analytics_workspace_id
    azureResourceId           = var.virtual_machine_id
    stopOnMultipleConnections = false

    authentication = {
      managedIdentity = {
        identifier-name  = "mi_res_id"
        identifier-value = var.azurerm_user_assigned_identity_id
      }
    }

  })
  protected_settings = jsonencode({
    "workspaceKey" = var.azurerm_log_analytics_workspace_primary_shared_key
  })
}
