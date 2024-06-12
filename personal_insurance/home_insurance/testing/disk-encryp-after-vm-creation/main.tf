module "resource_group" {
  source = "../../modules/resource_group"


  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  default_tags            = var.default_tags
}


module "network" {
  source = "../../modules/network"

  vnet_name                                   = var.vnet_name
  vnet_address_space                          = var.vnet_address_space
  resource_group_rg_location                  = var.resource_group_location
  resource_group_rg_name                      = var.resource_group_name
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
  source = "../../modules/storage"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  default_tags               = var.default_tags
  depends_on                 = [module.resource_group]

}

module "ssh_keys" {
  source = "../../modules/ssh_keys"

}


module "disk_encryption_set" {
  source = "../../modules/disk_encryption_set"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  key_vault_sku_name         = "standard"
  default_tags               = var.default_tags
  depends_on                 = [module.resource_group]

}

module "virtual_machine_win" {
  source = "../../modules/virtual_machine_win"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  public_key_openssh         = module.ssh_keys.public_key_openssh
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
  public_ip_fqdn             = module.network.public_ip_fqdn
  public_ip_address          = module.network.public_ip_address
  # availability_set_id        = module.availability_set.availability_set_id
  default_tags           = var.default_tags
  depends_on             = [module.resource_group, module.network, module.ssh_keys, module.storage, module.disk_encryption_set]
}

module "virtual_machine_win_ext_disk_encryption" {
  source = "../../modules/vm_win_extensions/disk-encryption"
  virtual_machine_id = module.virtual_machine_win.my_windows_vm_id
  KeyVaultURL = module.disk_encryption_set.encryp_key_vault_uri
  KeyVaultResourceId  = module.disk_encryption_set.encryp_key_vault_id
  KeyEncryptionKeyURL = module.disk_encryption_set.encryp_set_key_vault_key_id
  KekVaultResourceId = module.disk_encryption_set.encryp_key_vault_key_id
  default_tags = var.default_tags
  depends_on = [ module.disk_encryption_set, module.virtual_machine_win ]
}