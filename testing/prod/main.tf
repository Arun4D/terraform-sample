module "resource_group" {
  source = "../../modules/resource_group"

  for_each = toset(var.resource_group_names)

  resource_group_name     = each.key
  resource_group_location = var.resource_group_location
  default_tags            = var.default_tags
}


module "network" {
  source = "../../modules/network"

  vnet_name                                   = var.vnet_name
  vnet_address_space                          = var.vnet_address_space
  resource_group_rg_location                  = var.resource_group_location
  resource_group_rg_name                      = module.resource_group["ad-terr-rg1"].name
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

module "route_table" {
  source = "../../modules/route_table"

  resource_group_rg_location    = var.resource_group_location
  resource_group_rg_name        = module.resource_group.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  route_name                    = var.route_name
  route_address_prefix          = var.route_address_prefix
  route_next_hop_type           = var.route_next_hop_type
  default_tags                  = var.default_tags
  depends_on                    = [module.resource_group]
}

module "availability_set" {
  source = "../../modules/availability_set"

  resource_group_rg_location   = var.resource_group_location
  resource_group_rg_name       = module.resource_group.resource_group_name
  availability_set_name        = var.availability_set_name
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count


  default_tags = var.default_tags
  depends_on   = [module.resource_group]

}

module "virtual_machine" {
  source = "../../modules/virtual_machine"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  public_key_openssh         = module.ssh_keys.public_key_openssh
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
  public_ip_fqdn             = module.network.public_ip_fqdn
  public_ip_address          = module.network.public_ip_address
  availability_set_id        = module.availability_set.availability_set_id
  default_tags               = var.default_tags
  depends_on                 = [module.resource_group, module.availability_set, module.network, module.ssh_keys, module.storage]
}

module "monitor" {
  source = "../../modules/monitor"

  resource_group_rg_name = module.resource_group.resource_group_name
  monitor_resource_ids   = [module.virtual_machine.terraform_vm_id]
  default_tags           = var.default_tags
  depends_on             = [module.virtual_machine]
}

module "file_share" {
  source = "../../modules/backup/file_share"

  resource_group_rg_location                     = var.resource_group_location
  resource_group_rg_name                         = module.resource_group.resource_group_name
  recovery_services_vault_name                   = var.recovery_services_vault_name
  recovery_services_vault_sku                    = var.recovery_services_vault_sku
  storage_account_name                           = var.storage_account_name
  storage_account_account_tier                   = var.storage_account_account_tier
  storage_account_account_replication_type       = var.storage_account_account_replication_type
  storage_share                                  = var.storage_share
  backup_policy_file_share_name                  = var.backup_policy_file_share_name
  backup_policy_file_share_backup_frequency      = var.backup_policy_file_share_backup_frequency
  backup_policy_file_share_backup_time           = var.backup_policy_file_share_backup_time
  backup_policy_file_share_retention_daily_count = var.backup_policy_file_share_retention_daily_count
  default_tags                                   = var.default_tags
}
