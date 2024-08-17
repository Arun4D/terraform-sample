
resource "azurerm_monitor_action_group" "monitor_act_group_main" {
  name                = "network-actiongroup"
  resource_group_name = var.resource_group_rg_name
  short_name          = "networkact"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }

  tags = var.default_tags
}

/* resource "azurerm_monitor_activity_log_alert" "activity_log_alert_nw_delete" {
  name                = "Activity Log Alert for Create or Update Security Group"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Monitoring for Create or Update Network Security Group events gives insight into network access changes and may reduce the time it takes to detect suspicious activity"
  tags = var.default_tags
  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/virtualNetworks/delete"
  }

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/networkInterfaces/delete"
  }

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/routeTables/delete"
  }

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/expressRouteCircuits/delete"
  }

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/virtualNetworkGateways/delete"
  }

  action {
    action_group_id =  azurerm_monitor_action_group.monitor_act_group_main.id
  }
} */

resource "azurerm_monitor_activity_log_alert" "monitor_metric_alert_nw_delete" {
  name                = "network-nw-delete-ma"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Activity Log Alert for virtualNetworks delete."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/virtualNetworks/delete"
    level          = "Critical"
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_activity_log_alert" "monitor_metric_alert_nwi_delete" {
  name                = "network-nwi-ma"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Activity Log Alert for networkInterfaces delete."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/networkInterfaces/delete"
    level          = "Critical"
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_activity_log_alert" "monitor_metric_alert_routetable_delete" {
  name                = "network-rt-ma"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Activity Log Alert for routeTables delete."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/routeTables/delete"
    level          = "Critical"
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_activity_log_alert" "monitor_metric_alert_exp_route_circuits_delete" {
  name                = "network-exp-route-ma"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Activity Log Alert for expressRouteCircuits delete."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/expressRouteCircuits/delete"
    level          = "Critical"
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_activity_log_alert" "monitor_metric_alert_vng_delete" {
  name                = "network-vng-ma"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Activity Log Alert for virtualNetworkGateways delete."

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Network/virtualNetworkGateways/delete"
    level          = "Critical"
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}