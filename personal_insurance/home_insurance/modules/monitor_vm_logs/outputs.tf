output "azurerm_log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}
output "azurerm_log_analytics_solution_id" {
  value = azurerm_log_analytics_solution.vminsights.id
}
