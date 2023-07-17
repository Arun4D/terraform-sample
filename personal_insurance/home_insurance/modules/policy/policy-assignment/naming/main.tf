resource "azurerm_resource_group_policy_assignment" "naming_policy_assign" {
  name                 = "${var.env}-naming-policy-assign"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id

  parameters = jsonencode({
    "namePattern" : { "value" : var.naming_regx }
  })
}
