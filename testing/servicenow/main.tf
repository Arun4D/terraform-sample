module "resource_group" {
  source = "../../modules/resource_group"

  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location

  default_tags = var.default_tags
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

  default_tags = var.default_tags

  depends_on = [module.resource_group]

}

module "storage" {
  source = "../../modules/storage"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name

  default_tags = var.default_tags

  depends_on = [module.resource_group]

}

module "virtual_machine_win" {
  source = "../../modules/virtual_machine_win"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
  public_ip_fqdn             = module.network.public_ip_fqdn
  public_ip_address          = module.network.public_ip_address
  admin_username             = "adminuser"
  admin_password             = "P@$$w0rd1234!"

  default_tags = var.default_tags

  depends_on = [module.resource_group, module.network, module.storage]
}

module "log_analytics" {
  source = "../../modules/log_analytics"

  resource_group_rg_name     = module.resource_group.resource_group_name
  resource_group_rg_location = var.resource_group_location

  default_tags = var.default_tags

  depends_on = [module.virtual_machine_win]
}


module "monitor_vm_action_group" {
  source = "../../modules/alert/servicenow_monitor_action_group"

  resource_group_rg_name     = module.resource_group.resource_group_name
  resource_group_rg_location = var.resource_group_location
  servicenow_uri             = var.servicenow_uri

  default_tags = var.default_tags

  depends_on = [module.virtual_machine_win]

}

module "monitor_vm_activity_log_alert" {
  source = "../../modules/alert/monitor_activity_log_alert"

  resource_group_rg_name     = module.resource_group.resource_group_name
  resource_group_rg_location = var.resource_group_location
  monitor_resource_ids       = [module.resource_group.resource_group_id]
  action_group_id            = module.monitor_vm_action_group.servicenow_monitor_act_group_id

  default_tags = var.default_tags

  depends_on = [module.monitor_vm_action_group, module.virtual_machine_win]

}
