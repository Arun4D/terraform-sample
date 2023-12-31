output "backup_enable_for_vm_policy_assign_id" {
  value = azurerm_resource_group_policy_assignment.backup_enable_for_vm_policy_assign.id
}
output "resource_group_id" {
  value = var.resource_group_id
}

output "resource_group_name" {
  value = var.resource_group_name
}