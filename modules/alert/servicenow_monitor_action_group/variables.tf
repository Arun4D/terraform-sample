variable "resource_group_rg_location" {
  default     = ""
  description = "resource_group rg location."
}

variable "resource_group_rg_name" {
  default     = ""
  description = "resource_group rg name."
}

variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
}

variable "servicenow_uri" {}
