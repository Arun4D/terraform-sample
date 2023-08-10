locals {
  is_os_type_windows = var.os_type == "windows" ? true : false
  is_os_type_linux   = var.os_type == "linux" ? true : false
}
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-01"
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "vminsights" {
  solution_name         = "vminsights"
location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
  depends_on = [ azurerm_log_analytics_workspace.law ]
}

resource "azurerm_monitor_data_collection_rule" "dcr_linux" {
  count = local.is_os_type_linux == true ? 1 : 0

  name                = "dcr_linux"
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law.id
      name                  = "destination-log"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["destination-log"]
  }

  data_sources {
    syslog {
      facility_names = ["daemon", "syslog"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "datasource-syslog"
    }
  }
}

resource "azurerm_virtual_machine_extension" "vm_ext_linux" {

  count = local.is_os_type_linux == true ? 1 : 0

  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}


/* resource "azurerm_virtual_machine_extension" "oms_mma02" {
   count = local.is_os_type_linux == true ? 1 : 0
  name                       = "OMSExtension"
  virtual_machine_id         =  var.virtual_machine_id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.14"
  #auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "workspaceId" : "${azurerm_log_analytics_workspace.law.workspace_id}",
      "skipDockerProviderInstall" : true
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey" : "${azurerm_log_analytics_workspace.law.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}
 */

resource "azurerm_monitor_data_collection_rule_association" "dcr_linux_association" {
  count = local.is_os_type_linux == true ? 1 : 0

  name                    = "DCR-Linux-VM-Association"
  target_resource_id      = var.virtual_machine_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_linux[0].id
  description             = "Association between the Data Collection Rule and the Linux VM."
  depends_on              = [azurerm_monitor_data_collection_rule.dcr_linux]
}


resource "azurerm_monitor_data_collection_rule" "dcr_windows" {
  count               = local.is_os_type_windows == true ? 1 : 0
  name                = "dcr_windows"
  resource_group_name = var.resource_group_rg_name
  location            = var.resource_group_rg_location

  destinations {
   log_analytics {
     workspace_resource_id = azurerm_log_analytics_workspace.law.id
     name                  = "log-analytics"
   }
  }
 
 data_flow {
   streams      = ["Microsoft-Event"]
   destinations = ["log-analytics"]
 }
 
 data_sources {
   windows_event_log {
     streams = ["Microsoft-Event"]
     x_path_queries = ["Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]",
       "Security!*[System[(band(Keywords,13510798882111488))]]",
     "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"]
     name = "eventLogsDataSource"
   }
 }
  
  depends_on = [
    azurerm_log_analytics_solution.vminsights
  ]
}

/* data "template_file" "json" {
  template = "${file("diagnostics.json.tpl")}"
} */

resource "azurerm_virtual_machine_extension" "vm_ext_windows" {
  count                      = local.is_os_type_windows == true ? 1 : 0
  name                       = "VMExtensionWindows"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

/*
Microsoft.Azure.Monitor.AzureMonitorWindowsAgent 1.18.0.0
Microsoft.Azure.Diagnostics.IaaSDiagnostics 1.22.0.1
Microsoft.Azure.Monitoring.DependencyAgent.DependencyAgentWindows
*/
resource "azurerm_virtual_machine_extension" "vm_ext_iaas_windows" {
  count                      = local.is_os_type_windows == true ? 1 : 0
  name                       = "IaaSDiagnostics"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.22"

/*  settings = templatefile(format("%sdiagnostics.json.tpl", path.module), {
    resource_id  = var.virtual_machine_id
    storage_name = var.storage_account_name
  })
 */
   settings = templatefile(format("%s/diagnostics.json", path.module), {
    resource_id  = var.virtual_machine_id
    storage_name = var.storage_account_name
  })

 /*  settings = <<SETTINGS
    {
        "xmlCfg": "${base64encode(data.template_file.json.rendered)}",
        "storageAccount": "${var.storage_account_name}"
    }
SETTINGS */

  protected_settings = <<SETTINGS
    {
        "storageAccountName": "${var.storage_account_name}",
        "storageAccountKey": "${var.storage_account_primary_access_key}"
    }
SETTINGS
}



resource "azurerm_virtual_machine_extension" "vm_ext_win_agent_windows" {
  count                      = local.is_os_type_windows == true ? 1 : 0
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.18"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

settings = jsonencode({
    workspaceId               = azurerm_log_analytics_workspace.law.id
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
    "workspaceKey" = azurerm_log_analytics_workspace.law.primary_shared_key
  })

  
}


resource "azurerm_monitor_data_collection_rule_association" "dcr_windows_association" {
  count                   = local.is_os_type_windows == true ? 1 : 0
  name                    = "DCR-Windows-VM-Association"
  target_resource_id      = var.virtual_machine_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_windows[0].id
  description             = "Association between the Data Collection Rule and the Linux VM."
  depends_on              = [azurerm_monitor_data_collection_rule.dcr_windows]
}

resource "azurerm_monitor_action_group" "monitor_act_group_vm" {
  name                = "monitorvm-actiongroup"
  resource_group_name = var.resource_group_rg_name
  short_name          = "VmActGrp"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }

  tags = var.default_tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "linuxVMalert" {
  name                = "alert-vm-issue"
  resource_group_name = var.resource_group_rg_name
  location            = var.resource_group_rg_location

  evaluation_frequency = "PT10M"
  window_duration      = "PT10M"
  scopes               = [azurerm_log_analytics_workspace.law.id]
  severity             = 1
  criteria {
    query                   = <<-QUERY
      AzureActivity
        | where OperationName == "Deallocate Virtual Machine" and ActivityStatus == "Succeeded"
        | where TimeGenerated > ago(5m)
      QUERY
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "LessThanOrEqual"
  }

  auto_mitigation_enabled          = true
  workspace_alerts_storage_enabled = false
  description                      = "alert vm issue"
  display_name                     = "alert-vm-issue"
  enabled                          = true
  query_time_range_override        = "PT1H"
  skip_query_validation            = true
  action {
    action_groups = [azurerm_monitor_action_group.monitor_act_group_vm.id]
  }

  tags = var.default_tags

  depends_on = [  azurerm_monitor_action_group.monitor_act_group_vm, azurerm_log_analytics_workspace.law]
}


resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example"
  target_resource_id = var.virtual_machine_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id


  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

  depends_on = [ azurerm_virtual_machine_extension.vm_ext_iaas_windows ]

}