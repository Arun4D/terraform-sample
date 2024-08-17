
resource "azurerm_monitor_action_group" "monitor_act_group_main" {
  name                = "network-actiongroup"
  resource_group_name = var.resource_group_rg_name
  short_name          = "networkact"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://network.com/alert"
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_network_bits_in_warning_metric_alert" {
  name                = "network-bitsin-metric-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Action will be triggered when expressRouteCircuits BitsOutPerSecond reach above threshold."

  severity = 2

  target_resource_type = "Microsoft.Network/expressRouteCircuits"

  criteria {
    metric_namespace = "Microsoft.Network/expressRouteCircuits"
    metric_name      = "BitsInPerSecond"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }


  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_network_bits_in_critical_metric_alert" {
  name                = "network-bitsin-metric-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Action will be triggered when expressRouteCircuits BitsOutPerSecond reach above threshold."

  severity             = 0
  target_resource_type = "Microsoft.Network/expressRouteCircuits"
  criteria {
    metric_namespace = "Microsoft.Network/expressRouteCircuits"
    metric_name      = "BitsInPerSecond"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }


  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_network_bits_out_warning_metric_alert" {
  name                = "network-bits-out-metric-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Action will be triggered when expressRouteCircuits BitsOutPerSecond reach above threshold."

  severity             = 2
  target_resource_type = "Microsoft.Network/expressRouteCircuits"
  criteria {
    metric_namespace = "Microsoft.Network/expressRouteCircuits"
    metric_name      = "BitsOutPerSecond"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }


  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_network_bits_out_critical_metric_alert" {
  name                = "network-bits-out-metric-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Action will be triggered when expressRouteCircuits BitsOutPerSecond reach above threshold."

  severity             = 0
  target_resource_type = "Microsoft.Network/expressRouteCircuits"
  criteria {
    metric_namespace = "Microsoft.Network/expressRouteCircuits"
    metric_name      = "BitsOutPerSecond"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }


  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}

resource "azurerm_monitor_metric_alert" "monitor_network_Bgp_critical_metric_alert" {
  name                = "network-nwg-bgp-metric-alert"
  resource_group_name = var.resource_group_rg_name
  scopes              = var.monitor_resource_ids
  description         = "Action will be triggered when virtualnetworkgateways reach above threshold."

  severity             = 0
  target_resource_type = "Microsoft.Network/expressRouteCircuits"
  criteria {
    metric_namespace = "microsoft.network/virtualnetworkgateways"
    metric_name      = "BgpPeerStatus"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }


  action {
    action_group_id = azurerm_monitor_action_group.monitor_act_group_main.id
  }

  tags = var.default_tags
}