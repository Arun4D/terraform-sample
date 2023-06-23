output "vnet_name" {
  value = azurerm_virtual_network.my_terraform_network.name
}

output "terraform_nic_id" {
  value = azurerm_network_interface.my_terraform_nic.id
}
output "terraform_nsg_id" {
  value = azurerm_network_security_group.my_terraform_nsg.id
}