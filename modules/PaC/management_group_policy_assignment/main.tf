
resource "azurerm_management_group_policy_assignment" "management_group_policy_assignment" {
  for_each = var.policy_definition_ids

  name                 = each.value["name"]
  policy_definition_id = each.value["policy_definition_id"]
  management_group_id  = var.scope_id
}
