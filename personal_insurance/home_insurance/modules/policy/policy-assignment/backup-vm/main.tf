resource "azurerm_resource_group_policy_assignment" "backup_enable_for_vm_policy_assign" {
  name                 = "${var.env}_backup_enable_for_vm_policy_assignn"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id
}

