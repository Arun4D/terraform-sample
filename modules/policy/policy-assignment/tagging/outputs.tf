output "tagging_policy_assign_id" {
  value = azurerm_resource_group_policy_assignment.tagging_policy_assign.id
}
output "resource_group_id" {
  value = var.resource_group_id
}

output "resource_group_name" {
  value = var.resource_group_name
}