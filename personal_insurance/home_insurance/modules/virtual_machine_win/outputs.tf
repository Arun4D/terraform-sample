output "my_windows_vm_id" {
  value = azurerm_windows_virtual_machine.my_windows_vm.id
}
output "win_public_ip_address" {
  value = azurerm_windows_virtual_machine.my_windows_vm.public_ip_address
}

output "azurerm_user_assigned_identity_id" {
  value = azurerm_user_assigned_identity.example.id
}
