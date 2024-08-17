output "vm_deallocate_alert_id" {
  value = azurerm_monitor_activity_log_alert.vm_deallocate_alert.id
}

output "vm_restart_alert_id" {
  value = azurerm_monitor_activity_log_alert.vm_restart_alert.id
}

output "vm_start_alert_id" {
  value = azurerm_monitor_activity_log_alert.vm_start_alert.id
}
