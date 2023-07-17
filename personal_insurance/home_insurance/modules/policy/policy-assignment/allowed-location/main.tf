resource "azurerm_resource_group_policy_assignment" "allowed_location_policy_assign" {
  name                 = "${var.env}-allowed_location_policy_assign"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id

  parameters = jsonencode({
    "allowedLocations" : { "value" : var.allowedLocations }
  })
}

