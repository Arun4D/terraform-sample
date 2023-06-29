module "resource_group" {
  source = "../modules/resource_group"

  resource_group_name_prefix = var.resource_group_name_prefix
  resource_group_location    = var.resource_group_location
  default_tags               = var.default_tags
}

module "network" {
  source = "../modules/network"

  vnet_name                                   = var.vnet_name
  vnet_address_space                          = var.vnet_address_space
  resource_group_rg_location                  = var.resource_group_location
  resource_group_rg_name                      = module.resource_group.resource_group_name
  subnet_name                                 = var.subnet_name
  subnet_address_prefixes                     = var.subnet_address_prefixes
  public_ip_name                              = var.public_ip_name
  public_ip_allocation_method                 = var.public_ip_allocation_method
  nic_name                                    = var.nic_name
  nic_ip_config_name                          = var.nic_ip_config_name
  nic_ip_config_private_ip_address_allocation = var.nic_ip_config_private_ip_address_allocation
  nsg_name                                    = var.nsg_name
  default_tags                                = var.default_tags
  depends_on                                  = [module.resource_group]

}

module "storage" {
  source = "../modules/storage"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  default_tags               = var.default_tags
  depends_on                 = [module.resource_group]

}

module "ssh_keys" {
  source = "../modules/ssh_keys"

}

module "route_table" {
  source = "../modules/route_table"

  resource_group_rg_location    = var.resource_group_location
  resource_group_rg_name        = module.resource_group.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  route_name                    = var.route_name
  route_address_prefix          = var.route_address_prefix
  route_next_hop_type           = var.route_next_hop_type
  default_tags                  = var.default_tags
  depends_on                    = [module.resource_group]
}


module "virtual_machine" {
  source = "../modules/virtual_machine"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  public_key_openssh         = module.ssh_keys.public_key_openssh
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
  default_tags               = var.default_tags
  depends_on                 = [module.resource_group, module.network, module.ssh_keys, module.storage]
}

module "monitor" {
  source = "../modules/monitor"

  resource_group_rg_name     = module.resource_group.resource_group_name
  monitor_resource_ids = [module.virtual_machine.terraform_vm_id]
   default_tags               = var.default_tags
   depends_on = [ module.virtual_machine ]
}