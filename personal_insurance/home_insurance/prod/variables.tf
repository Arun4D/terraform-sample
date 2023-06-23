variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "vnet_name" {
  default     = "myVnet"
  description = "Vnet name."
}

variable "vnet_address_space" {
  default     = ["10.0.0.0/16"]
  type        = list(string)
  description = "Vnet address space."
}

variable "subnet_name" {
  default     = "mySubnet"
  description = "Subnet name"
}

variable "subnet_address_prefixes" {
  default     = ["10.0.1.0/24"]
  type        = list(string)
  description = "Subnet address prefixes."
}

variable "public_ip_name" {
  default     = "myPublicIP"
  description = "Public IP"
}

variable "public_ip_allocation_method" {
  default     = "Dynamic"
  description = "Public IP allocation method"
}

variable "nic_name" {
  default     = "myNIC"
  description = "NIC name"
}

variable "nic_ip_config_name" {
  default     = "my_nic_configuration"
  description = "NIC ip config name"
}

variable "nic_ip_config_private_ip_address_allocation" {
  default     = "Dynamic"
  description = "NIC ip config private ip address allocation"
}

variable "nsg_name" {
  default     = "myNetworkSecurityGroup"
  description = "Network security group name"
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