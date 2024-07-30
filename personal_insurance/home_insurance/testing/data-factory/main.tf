module "resource_group" {
  source = "../../modules/resource_group"


  resource_group_name     = var.resource_group_name
  resource_group_location = var.location
  default_tags            = var.default_tags
}

module "data_factory" {
  source = "../../modules/data_factory"

  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  feature_flags       = var.feature_flags
  github_config       = var.github_config
  vsts_config         = merge(var.vsts_config, { tenant_id = data.azurerm_client_config.current.tenant_id})

  default_tags = var.default_tags

  depends_on = [module.resource_group]
}
