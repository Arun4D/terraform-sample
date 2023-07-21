resource "azurerm_resource_group_policy_assignment" "tagging_policy_assign" {
  name                 = "${var.env}-tagging-policy-assign"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id
  location = var.resource_group_location
  identity {
    type = "SystemAssigned"
  }
}
