output "mgmt_grp_level0_id" {
  value = azurerm_management_group.level_0.id
}
output "mgmt_grp_level1_ids" {
  value = {for level1 in azurerm_management_group.level_1 : level1.display_name => level1.id}
}
output "mgmt_grp_level02_ids" {
  value = {for level2 in azurerm_management_group.level_2 : level2.display_name => level2.id}
}