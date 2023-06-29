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

variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
  default = {
    environment = "prod"
    department  = "finance"
    source      = "terraform"
  }
}

variable "key_vault_name" {
  default     = "kv"
  description = "key vault name."
}

variable "key_vault_sku_name" {
  default     = "standard"
  description = "key vault sku name."
}

variable "key_vault_vm_secret_name" {
  default     = "kv_vm_secret_name"
  description = "key vault vm secret name."
}

variable "disable_bgp_route_propagation" {
  type        = bool
  default     = false
  description = "If you plan to associate the route table to a subnet in a virtual network that's connected to your on-premises network through a VPN gateway, and you don't want to propagate your on-premises routes to the network interfaces in the subnet, set Virtual network gateway route propagation to Disabled."
}

variable "route_name" {
  default     = "myRoute"
  description = "Route name."
}

variable "route_address_prefix" {
  default     = "10.1.0.0/16"
  description = "Classless Inter-Domain Routing (CIDR) notation, that you want to route traffic to. The prefix can't be duplicated in more than one route within the route table, though the prefix can be within another prefix. For example, if you defined 10.0.0.0/16 as a prefix in one route, you can still define another route with the 10.0.0.0/22 address prefix. Azure selects a route for traffic based on longest prefix match"
}

variable "route_next_hop_type" {
  default     = "VnetLocal"
  description = "Route next hop type."
}

variable "monitor_resource_ids" {
  type        = list(string)
  default     = []
  description = "List of resources to monitor."
}