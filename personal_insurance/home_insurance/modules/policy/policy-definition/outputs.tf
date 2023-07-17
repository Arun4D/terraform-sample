/* output "allowed_location_policy_set_def_id" {
  value = azurerm_policy_set_definition.allowed_location_policy_set_def.id
}

output "allowed_location_policy_set_def_name" {
  value = azurerm_policy_set_definition.allowed_location_policy_set_def.name
} */

output "allowed_location_policy_def_id" {
  value = azurerm_policy_definition.allowed_location_policy_def.id
}

output "allowed_location_policy_def_name" {
  value = azurerm_policy_definition.allowed_location_policy_def.name
}

output "naming_policy_def_id" {
  value = azurerm_policy_definition.naming_policy_def.id
}

output "naming_policy_def_name" {
  value = azurerm_policy_definition.naming_policy_def.name
}

output "tagging_policy_name" {
  value = azurerm_policy_set_definition.tagging-policy.name
}
output "tagging_policy_id" {
  value = azurerm_policy_set_definition.tagging-policy.id
}

output "allowed_vm_sku_policy_name" {
  value = azurerm_policy_definition.allowed_vm_sku_policy_def.name
}
output "allowed_vm_sku_policy_id" {
  value = azurerm_policy_definition.allowed_vm_sku_policy_def.id
}


output "not_allowed_vm_ext_policy_name" {
  value = azurerm_policy_definition.not_allowed_vm_ext_policy_def.name
}
output "not_allowed_vm_ext_policy__id" {
  value = azurerm_policy_definition.not_allowed_vm_ext_policy_def.id
}