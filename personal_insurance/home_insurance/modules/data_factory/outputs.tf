output "data_factory_id" {
  value = !var.feature_flags.create_vsts_config && !var.feature_flags.create_github_config ? (length(azurerm_data_factory.data_factory) > 0 ? azurerm_data_factory.data_factory[0].id : null) : null
}

output "vsts_data_factory_id" {
  value = var.feature_flags.create_vsts_config ? (length(azurerm_data_factory.vsts_data_factory) > 0 ? azurerm_data_factory.vsts_data_factory[0].id : null) : null
}

output "github_data_factory_id" {
  value = var.feature_flags.create_github_config ? (length(azurerm_data_factory.github_data_factory) > 0 ? azurerm_data_factory.github_data_factory[0].id : null) : null
}
