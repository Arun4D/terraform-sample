
resource "azurerm_monitor_action_group" "monitor_act_group_main" {
  name                = "example-actiongroup"
  resource_group_name = var.resource_group_rg_name
  short_name          = "exampleact"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_server_metric_alert" {
  name                = "example-metricalert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Action will be triggered when virtualMachines CPU / Disk or Memeory reach above threshold."


  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "OS Disk Bandwidth Consumed Percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }


  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }



  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}