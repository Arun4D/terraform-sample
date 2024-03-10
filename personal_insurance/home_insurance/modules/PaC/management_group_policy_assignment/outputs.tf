output "output_management_group_policy_assignment" {
  value = {for mgps in azurerm_management_group_policy_assignment.management_group_policy_assignment : mgps.name => mgps.id }
}