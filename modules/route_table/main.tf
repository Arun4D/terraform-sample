resource "azurerm_route_table" "my_route_table" {
  name                          = "example-route-table"
  location                      = var.resource_group_rg_location
  resource_group_name           = var.resource_group_rg_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  route {
    name           = var.route_name
    address_prefix = var.route_address_prefix
    next_hop_type  = var.route_next_hop_type
  }

  tags = var.default_tags
}