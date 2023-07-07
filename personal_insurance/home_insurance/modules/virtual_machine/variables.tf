variable "resource_group_rg_location" {
  default     = ""
  description = "resource_group rg location."
}

variable "resource_group_rg_name" {
  default     = ""
  description = "resource_group rg name."
}

variable "public_key_openssh" {
  default     = ""
  description = "public key openssh."
}

variable "primary_blob_endpoint" {
  default     = ""
  description = "primary blob endpoint."
}

variable "my_terraform_nic_id" {
  default     = ""
  description = "my terraform nic id."
}

variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
}

variable "public_ip_fqdn" {
  default     = ""
  description = "public ip fqdn."
}

variable "public_ip_address" {
  default     = ""
  description = "public ip address."
}


variable "availability_set_id" {
  default     = ""
  description = "availability set id."
}