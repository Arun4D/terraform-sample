output "terraform_vm_id" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.id
}
output "vm_public_ip_address" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}
