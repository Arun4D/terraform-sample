output "enforce_nsg_on_subnet_policy_assignment_id" {
  value = azurerm_resource_group_policy_assignment.enforce_nsg_on_subnet_policy_assignment.id
}
output "resource_group_id" {
  value = var.resource_group_id
}

output "resource_group_name" {
  value = var.resource_group_name
}