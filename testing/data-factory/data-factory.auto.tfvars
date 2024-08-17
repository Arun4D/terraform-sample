
resource_group_name = "ad-terr-rg1"
location            = "eastus"

default_tags = {
  environment = "prod"
  department  = "finance"
  source      = "terraform"
}
feature_flags = {
  create_github_config = true
  create_vsts_config   = false
}

github_config = {
  account_name    = "arun4d"
  branch_name     = "main"
  git_url         = "https://github.com/Arun4D/azure-data-factory-sample.git"
  repository_name = "azure-data-factory-sample"
  root_folder     = "/"
}

vsts_config = {
  account_name    = "arun4d"
  branch_name     = "main"
  project_name    = "https://github.com/Arun4D/azure-data-factory-sample.git"
  repository_name = "azure-data-factory-sample"
  root_folder     = "/"
}

