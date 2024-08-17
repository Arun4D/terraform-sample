variable "location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  description = "Resource group name."
}


variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
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
    tenant_id       = string
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


variable "feature_flags" {
  description = "Combined feature flags for validation"
  type = object({
    create_github_config = bool
    create_vsts_config   = bool
  })
  default = {
    create_github_config = true
    create_vsts_config   = true
  }

  validation {
    condition     = !(var.feature_flags.create_github_config && var.feature_flags.create_vsts_config)
    error_message = "Both create_github_config and create_vsts_config cannot be true at the same time."
  }
}