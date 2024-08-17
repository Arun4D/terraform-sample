
resource "azurerm_monitor_action_group" "servicenow_monitor_act_group" {
  name                = "servicenow-vm-actiongroup"
  resource_group_name = var.resource_group_rg_name
  short_name          = "snowvmgrp"

  webhook_receiver {
    name                    = "servicenow"
    service_uri             = var.servicenow_uri
    use_common_alert_schema = true
  }

  tags = var.default_tags
}
