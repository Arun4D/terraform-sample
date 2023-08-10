module "resource_group" {
  source = "../modules/resource_group"


  resource_group_name     = var.resource_group_names
  resource_group_location = var.resource_group_location
  default_tags            = var.default_tags
}


# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  tags                = var.default_tags

  depends_on = [module.resource_group]
}

resource "azurerm_virtual_network_peering" "peer_a2b" {
  name                         = "peer-vnet-a-with-b"
  resource_group_name          = module.resource_group.resource_group_name
  virtual_network_name         = azurerm_virtual_network.my_terraform_network.name
  remote_virtual_network_id    = var.site_b_vnet_id
  allow_virtual_network_access = true

  depends_on = [module.resource_group, azurerm_virtual_network.my_terraform_network]
}