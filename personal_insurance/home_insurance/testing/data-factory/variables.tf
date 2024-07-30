variable "resource_group_name" {
}

variable "location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
  default = {
    environment = "prod"
    department  = "finance"
    source      = "terraform"
  }
}
variable "feature_flags" {
  type = object({
    create_github_config = bool
    create_vsts_config   = bool
  })
  default = {
    create_github_config = true
    create_vsts_config   = true
  }

}

variable "github_config" {
  description = "create github configuration"
  type = object({
    account_name    = string
    branch_name     = string
    git_url         = string
    repository_name = string
    root_folder     = string
  })
  default = {
    account_name    = ""
    branch_name     = ""
    git_url         = ""
    repository_name = ""
    root_folder     = ""
  }
}


variable "vsts_config" {
  description = "create vsts configuration"
  type = object({
    account_name    = string
    branch_name     = string
    project_name    = string
    repository_name = string
    root_folder     = string
  })
  default = {
    account_name    = ""
    branch_name     = ""
    project_name    = ""
    repository_name = ""
    root_folder     = ""
    tenant_id       = ""
  }
}
