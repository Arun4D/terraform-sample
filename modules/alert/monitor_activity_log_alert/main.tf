resource "azurerm_monitor_activity_log_alert" "vm_deallocate_alert" {
  name                = "vm-deallocate-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids

  description = "Alert when a Virtual Machine is started or stopped or restarted"
  enabled     = true

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    status         = "Accepted"
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_activity_log_alert" "vm_start_alert" {
  name                = "vm-start-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids

  description = "Alert when a Virtual Machine is started or stopped or restarted"
  enabled     = true

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Compute/virtualMachines/start/action"
    status         = "Accepted"
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_activity_log_alert" "vm_restart_alert" {
  name                = "vm-restart-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids

  description = "Alert when a Virtual Machine is started or stopped or restarted"
  enabled     = true

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Compute/virtualMachines/restart/action"
    status         = "Accepted"
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.default_tags
}
