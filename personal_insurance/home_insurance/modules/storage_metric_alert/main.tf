
resource "azurerm_monitor_action_group" "monitor_act_group_main" {
  name                = "storage-actiongroup"
  resource_group_name = var.resource_group_rg_name
  short_name          = "storageact"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_metric_alert" {
  name                = "storage-metricalert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Action will be triggered when storageAccounts used capacity reached threshold."

  severity            = "3"
  window_size        = "PT1H"

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}