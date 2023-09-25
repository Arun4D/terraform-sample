
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-01"
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "vminsights" {
  solution_name         = "vminsights"
  location              = var.resource_group_rg_location
  resource_group_name   = var.resource_group_rg_name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
  depends_on = [azurerm_log_analytics_workspace.law]
}

