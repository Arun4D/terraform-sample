
resource "azurerm_monitor_action_group" "monitor_act_group_bk" {
  name                = "backup-actiongroup"
  resource_group_name = var.resource_group_rg_name
  short_name          = "exampleact"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_backup_metric_alert" {
  name                = "backup-metricalert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description              = "Alert on Backup Health Events"
  target_resource_type     = "Microsoft.RecoveryServices/vaults"
  auto_mitigate            = true
  frequency                = "PT1H"
  window_size              = "P1D"

  criteria {
    metric_namespace = "Microsoft.RecoveryServices/vaults"
    metric_name      = "BackupHealthEvent"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = "0"

    dimension {
      name     = "dataSourceURL"
      operator = "Include"
      values   = [
        "*"
      ]
    }

    dimension {
      name     = "healthStatus"
      operator = "Exclude"
      values   = ["Healthy"]
    } 
  }
  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_bk.id
  }

  tags = var.default_tags
}