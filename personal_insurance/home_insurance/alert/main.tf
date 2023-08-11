module "resource_group" {
  source = "../modules/resource_group"


  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  default_tags            = var.default_tags
}


module "network" {
  source = "../modules/network"

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
  source = "../modules/storage"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  default_tags               = var.default_tags
  depends_on                 = [module.resource_group]

}

module "ssh_keys" {
  source = "../modules/ssh_keys"

}


/* module "virtual_machine" {
  source = "../modules/virtual_machine"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  public_key_openssh         = module.ssh_keys.public_key_openssh
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
  public_ip_fqdn             = module.network.public_ip_fqdn
  public_ip_address          = module.network.public_ip_address
  # availability_set_id        = module.availability_set.availability_set_id
  default_tags = var.default_tags
  depends_on   = [module.resource_group, module.network, module.ssh_keys, module.storage]
} */

module "virtual_machine_win" {
  source = "../modules/virtual_machine_win"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  public_key_openssh         = module.ssh_keys.public_key_openssh
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
  public_ip_fqdn             = module.network.public_ip_fqdn
  public_ip_address          = module.network.public_ip_address
  # availability_set_id        = module.availability_set.availability_set_id
  default_tags = var.default_tags
  depends_on   = [module.resource_group, module.network, module.ssh_keys, module.storage]
}

/* 
resource "azurerm_recovery_services_vault" "default" {
  name                = "default"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"

  depends_on = [module.resource_group]
}

module "backup_metric_alert" {
  source = "../modules/backup_metric_alert"

  resource_group_rg_name = module.resource_group.resource_group_name
  monitor_resource_ids   = [azurerm_recovery_services_vault.default.id]
  default_tags           = var.default_tags
  depends_on             = [module.virtual_machine, azurerm_recovery_services_vault.default]
}

module "server_metric_alert" {
  source = "../modules/server_metric_alert"

  resource_group_rg_name = module.resource_group.resource_group_name
  monitor_resource_ids   = [module.virtual_machine.terraform_vm_id]
  default_tags           = var.default_tags
  depends_on             = [module.virtual_machine]
}

module "storage_metric_alert" {
  source = "../modules/storage_metric_alert"

  resource_group_rg_name = module.resource_group.resource_group_name
  monitor_resource_ids   = [module.storage.storage_account]
  default_tags           = var.default_tags
  depends_on             = [module.virtual_machine]
}

data "azurerm_subscription" "current" {}

module "network_log_alert" {
  source = "../modules/network_log_alert"

  resource_group_rg_name = module.resource_group.resource_group_name
  monitor_resource_ids   = [data.azurerm_subscription.current.id]
  default_tags           = var.default_tags
  depends_on             = [module.virtual_machine]
} */

/* module "network_metric_alert" {
  source = "../modules/network_metric_alert"

  resource_group_rg_name     = module.resource_group.resource_group_name
  monitor_resource_ids     = [data.azurerm_subscription.current.id]
  default_tags               = var.default_tags
  depends_on                 = [module.virtual_machine]
} */


module "log_analytics" {
  source = "../modules/log_analytics"

  resource_group_rg_name  = module.resource_group.resource_group_name
  resource_group_rg_location = var.resource_group_location
  default_tags            = var.default_tags
  depends_on              = [module.virtual_machine_win]
}

/* module "virtual_machine_win_extensions" {
  source = "../modules/virtual_machine_win_extensions"

  resource_group_rg_name  = module.resource_group.resource_group_name
  resource_group_rg_location = var.resource_group_location
  virtual_machine_id = module.virtual_machine_win.my_windows_vm_id
  azurerm_user_assigned_identity_id = module.virtual_machine_win.azurerm_user_assigned_identity_id
  storage_account_name = module.storage.storage_account_name
  storage_account_primary_access_key = module.storage.storage_account_primary_access_key
  azurerm_log_analytics_workspace_id = module.log_analytics.azurerm_log_analytics_workspace_id
  azurerm_log_analytics_workspace_primary_shared_key = module.log_analytics.azurerm_log_analytics_workspace_primary_shared_key
  default_tags            = var.default_tags
  depends_on              = [module.virtual_machine_win, module.resource_group, module.log_analytics, module.storage, module.log_analytics]
} */

module "monitor_vm_logs" {
  source = "../modules/monitor_vm_logs"

  resource_group_rg_name  = module.resource_group.resource_group_name
  resource_group_rg_location = var.resource_group_location
  os_type                 = "windows"
  virtual_machine_id = module.virtual_machine_win.my_windows_vm_id
  azurerm_log_analytics_workspace_id = module.log_analytics.azurerm_log_analytics_workspace_id
  default_tags            = var.default_tags
  depends_on              = [module.virtual_machine_win]
} 


/* module "monitor_vm_logs" {
  source = "../modules/monitor_vm_logs"

  resource_group_rg_name  = module.resource_group.resource_group_name
  resource_group_rg_location = var.resource_group_location
  os_type                 = "windows"
  virtual_machine_id      = module.virtual_machine_win.my_windows_vm_id
  azurerm_user_assigned_identity_id = module.virtual_machine_win.azurerm_user_assigned_identity_id
  storage_account_name = module.storage.storage_account_name
   storage_account_primary_access_key = module.storage.storage_account_primary_access_key
  default_tags            = var.default_tags
  depends_on              = [module.virtual_machine_win]
} */