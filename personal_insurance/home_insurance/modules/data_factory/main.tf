resource "azurerm_data_factory" "github_data_factory" {

  count = var.feature_flags.create_github_config ? 1 : 0

  name                = "ad-github-data-factory"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.default_tags

  dynamic "github_configuration" {
    for_each = var.feature_flags.create_github_config ? [1] : [0]
    content {
      account_name    = var.github_config.account_name
      branch_name     = var.github_config.branch_name
      git_url         = var.github_config.git_url
      repository_name = var.github_config.repository_name
      root_folder     = var.github_config.root_folder
    }
  }
}

resource "azurerm_data_factory" "vsts_data_factory" {

  count = var.feature_flags.create_vsts_config ? 1 : 0

  name                = "ad-vstsc-data-factory"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.default_tags


  dynamic "vsts_configuration" {
    for_each = var.feature_flags.create_vsts_config ? [1] : [0]
    content {
      account_name    = var.vsts_config.account_name
      branch_name     = var.vsts_config.branch_name
      project_name    = var.vsts_config.project_name
      repository_name = var.vsts_config.repository_name
      root_folder     = var.vsts_config.root_folder
      tenant_id       = var.vsts_config.tenant_id
    }
  }
}

resource "azurerm_data_factory" "data_factory" {

  count = !var.feature_flags.create_vsts_config && !var.feature_flags.create_github_config ? 1 : 0

  name                = "ad-data-factory"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.default_tags
}

