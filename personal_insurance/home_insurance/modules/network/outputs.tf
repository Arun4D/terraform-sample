output "vnet_name" {
  value = azurerm_virtual_network.my_terraform_network.name
}

output "terraform_nic_id" {
  value = azurerm_network_interface.my_terraform_nic.id
}
output "terraform_nsg_id" {
  value = azurerm_network_security_group.my_terraform_nsg.id
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.my_terraform_public_ip.fqdn
}

output "public_ip_address" {
  value = azurerm_public_ip.my_terraform_public_ip.ip_address
}
