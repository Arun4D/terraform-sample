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

variable "availability_set_name" {
  type        = string
  default     = "example-avail-set"
  description = ""
}

variable "platform_fault_domain_count" {
  type        = number
  default     = 3
  description = "Specifies the number of fault domains that are used"
}
variable "platform_update_domain_count" {
  type        = number
  default     = 5
  description = "Specifies the number of update domains that are used"
}