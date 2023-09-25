locals {
  is_os_type_windows = var.os_type == "windows" ? true : false
  is_os_type_linux   = var.os_type == "linux" ? true : false
}


resource "azurerm_monitor_data_collection_rule" "dcr_linux" {
  count = local.is_os_type_linux == true ? 1 : 0

  name                = "dcr_linux"
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = var.azurerm_log_analytics_workspace_id
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
      workspace_resource_id = var.azurerm_log_analytics_workspace_id
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
  scopes               = [var.azurerm_log_analytics_workspace_id]
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

  depends_on = [azurerm_monitor_action_group.monitor_act_group_vm]
}


resource "azurerm_monitor_diagnostic_setting" "example" {
  name                       = "example"
  target_resource_id         = var.virtual_machine_id
  log_analytics_workspace_id = var.azurerm_log_analytics_workspace_id


  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

}