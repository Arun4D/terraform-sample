output "azurerm_log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
output "azurerm_log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "azurerm_log_analytics_workspace_primary_shared_key" {
  value = azurerm_log_analytics_workspace.law.primary_shared_key
}


output "azurerm_log_analytics_solution_id" {
  value = azurerm_log_analytics_solution.vminsights.id
}
