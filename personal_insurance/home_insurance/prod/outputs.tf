output "resource_group_name" {
  value = module.resource_group.resource_group_name
}
output "vnet_name" {
  value = module.network.vnet_name
}

output "terraform_nic_id" {
  value = module.network.terraform_nic_id
}

output "terraform_nsg_id" {
  value = module.network.terraform_nsg_id
}

output "storage_account_id" {
  value = module.storage.storage_account
}

output "primary_blob_endpoint" {
  value = module.storage.primary_blob_endpoint
}

output "tls_private_key_id" {
  value = module.ssh_keys.tls_private_key_id
}

output "public_key_openssh" {
  value = module.ssh_keys.public_key_openssh
}

output "terraform_vm_id" {
  value = module.virtual_machine.terraform_vm_id
}

output "public_ip_address" {
  value = module.virtual_machine.public_ip_address
}

output "route_table_id" {
  value = module.route_table.route_table_id
}

output "azurerm_monitor_metric_alert_id" {
  value = module.monitor.azurerm_monitor_metric_alert_id
}