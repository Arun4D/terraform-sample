module "resource_group" {
  source = "../modules/resource_group"

  resource_group_name_prefix = var.resource_group_name_prefix
  resource_group_location    = var.resource_group_location
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

}

module "storage" {
  source = "../modules/storage"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name

}

module "ssh_keys" {
  source = "../modules/ssh_keys"

}

module "virtual_machine" {
  source = "../modules/virtual_machine"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  public_key_openssh         = module.ssh_keys.public_key_openssh
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
}