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