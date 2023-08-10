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


module "virtual_machine" {
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
}

resource "azurerm_recovery_services_vault" "default" {
  name                = "default"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"

  depends_on = [module.resource_group]
}

resource "azurerm_backup_policy_vm" "default" {
  name                = "default"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.default.name
  #policy_type                    = "V2"

  # This parameter may not work, depending on things. In theory
  # policy_type V2 should allow setting this more freely than V1, but it
  # seems that in certain cases V1 policy is silently enabled even if you
  # set it to V2 in Terraform.
  #instant_restore_retention_days = 7

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 4
    weekdays = ["Saturday"]
  }

  retention_monthly {
    count    = 6
    weekdays = ["Saturday"]
    weeks    = ["Last"]
  }

  depends_on = [module.resource_group, azurerm_recovery_services_vault.default]
}

resource "azurerm_backup_protected_vm" "testvm" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.default.name
  source_vm_id        = module.virtual_machine.terraform_vm_id
  backup_policy_id    = azurerm_backup_policy_vm.default.id

  depends_on = [module.resource_group, azurerm_backup_policy_vm.default, azurerm_recovery_services_vault.default]
}