
output "naming_rg_policy_def_id" {
  value = azurerm_policy_definition.naming_rg_policy_def.id
}

output "naming_rg_policy_def_name" {
  value = azurerm_policy_definition.naming_rg_policy_def.name
}

output "tagging_policy_name" {
  value = azurerm_policy_set_definition.tagging-policy.name
}
output "tagging_policy_id" {
  value = azurerm_policy_set_definition.tagging-policy.id
}

output "enforce_nsg_on_subnet_policy_def_name" {
  value = azurerm_policy_definition.enforce_nsg_on_subnet_policy_def.name
}
output "enforce_nsg_on_subnet_policy_def_id" {
  value = azurerm_policy_definition.enforce_nsg_on_subnet_policy_def.id
}

output "no_network_peerings_to_er_network_policy_def_name" {
  value = azurerm_policy_definition.no_network_peerings_to_er_network_policy_def.name
}
output "no_network_peerings_to_er_network_policy_def_id" {
  value = azurerm_policy_definition.no_network_peerings_to_er_network_policy_def.id
}

output "vm_creation_in_approved_vnet_policy_def_name" {
  value = azurerm_policy_definition.vm_creation_in_approved_vnet_policy_def.name
}
output "vm_creation_in_approved_vnet_policy_def_id" {
  value = azurerm_policy_definition.vm_creation_in_approved_vnet_policy_def.id
} 