resource "azurerm_resource_group_policy_assignment" "enforce_nsg_on_subnet_policy_assignment" {
  name                 = "${var.env}_enforce_nsg_on_subnet_policy_assignment_policy_assign"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id

  parameters = jsonencode({
    "nsgId" : { "value" : var.nsgId }
  })
}

