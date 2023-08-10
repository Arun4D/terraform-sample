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
module "policy_definition" {
  source = "../modules/policy/policy-definition"

  env = "dev"
}



data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
  depends_on   = [module.resource_group, module.network]
}

data "azurerm_policy_definition" "allowed_storage_sku" {
  display_name = "Storage accounts should be limited by allowed SKUs"
  depends_on   = [module.resource_group, module.network]
}

data "azurerm_policy_definition" "approved_vm_ext" {
  display_name = "Only approved VM extensions should be installed"
  depends_on   = [module.resource_group, module.network]
}


data "azurerm_policy_definition" "allowed_vm_sku" {
  display_name = "Allowed virtual machine size SKUs"
  depends_on   = [module.resource_group, module.network]
}

/* data "azurerm_policy_definition" "subnets_should_have_nsg" {
  display_name = "Subnets should have a Network Security Group"

  depends_on = [module.resource_group, module.network]
} */

data "azurerm_policy_definition" "backup_enable_for_vm" {
  display_name = "Azure Backup should be enabled for Virtual Machines"
  depends_on   = [module.resource_group, module.network]
}



module "resource_assignment_allowed_loc" {
  source = "../modules/policy/policy-assignment/allowed-location"

  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  allowedLocations     = ["northeurope", "westeurope"]
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, data.azurerm_policy_definition.allowed_locations]

}
module "resource_assignment_allowed_storage-sku" {
  source = "../modules/policy/policy-assignment/allowed-storage-sku"

  policy_definition_id = data.azurerm_policy_definition.allowed_storage_sku.id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  allowed_storage_sku  = ["Standard_LRS", "Standard_ZRS"]
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, data.azurerm_policy_definition.allowed_storage_sku]

}

module "resource_assignment_allowed-vm-ext" {
  source = "../modules/policy/policy-assignment/allowed-vm-ext"

  policy_definition_id = data.azurerm_policy_definition.approved_vm_ext.id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  approvedExtensions   = local.allowedExtensions
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, data.azurerm_policy_definition.approved_vm_ext]

}

module "resource_assignment_allowed-vm-sku" {
  source = "../modules/policy/policy-assignment/allowed-vm-sku"

  policy_definition_id = data.azurerm_policy_definition.allowed_vm_sku.id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  allowed_vm_sku       = ["CLASSIC_FSV2_2_4GB_128_S_SSD"]
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, data.azurerm_policy_definition.allowed_vm_sku]

}


module "resource_assignment_enable_backup_vm" {
  source = "../modules/policy/policy-assignment/backup-vm"

  policy_definition_id = data.azurerm_policy_definition.backup_enable_for_vm.id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, data.azurerm_policy_definition.backup_enable_for_vm]


}

module "resource_assignment_naming_rg" {
  source = "../modules/policy/policy-assignment/naming-rg"

  policy_definition_id = module.policy_definition.naming_rg_policy_def_id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name

  naming_regx = "rsai-?????-rg"
  env         = "dev"
  depends_on  = [module.resource_group, module.network, module.policy_definition]
}

module "resource_assignment_tagging" {
  source = "../modules/policy/policy-assignment/tagging"

  policy_definition_id    = module.policy_definition.tagging_policy_id
  resource_group_id       = module.resource_group.resource_group_id
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = var.resource_group_location

  env        = "dev"
  depends_on = [module.resource_group, module.network, module.policy_definition]

}

module "resource_assignment_enforce_nsg_on_subnet" {
  source = "../modules/policy/policy-assignment/enforce-nsg-on-subnet"

  policy_definition_id = module.policy_definition.enforce_nsg_on_subnet_policy_def_id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  nsgId                = module.network.terraform_nsg_id
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, module.policy_definition]

}

module "resource_assignment_no_network_peerings_to_er_network" {
  source = "../modules/policy/policy-assignment/no-network-peerings-to-er-network"

  policy_definition_id = module.policy_definition.no_network_peerings_to_er_network_policy_def_id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  resourceGroupName    = module.resource_group.resource_group_name
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, module.policy_definition]

}

module "resource_assignment_vm_creation_in_approved_vnet" {
  source = "../modules/policy/policy-assignment/vm-creation-in-approved-vnet"

  policy_definition_id = module.policy_definition.vm_creation_in_approved_vnet_policy_def_id
  resource_group_id    = module.resource_group.resource_group_id
  resource_group_name  = module.resource_group.resource_group_name
  vNetId               = module.network.vnet_id
  env                  = "dev"
  depends_on           = [module.resource_group, module.network, module.policy_definition]

}

/* 
module "resource_assignment_naming" {
  source = "../modules/policy/policy-assignment/naming"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.naming_policy_def_id
  resource_group_id    = each.value
  resource_group_name  = each.key

  naming_regx = "rsai-*-rg"
  env         = "dev"
  depends_on  = [module.policy_definition, module.resource_group]

}

module "resource_assignment_tagging" {
  source = "../modules/policy/policy-assignment/tagging"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.tagging_policy_id
  resource_group_id    = each.value
  resource_group_name  = each.key

  env        = "dev"
  depends_on = [module.policy_definition, module.resource_group]

}

module "resource_assignment_vm_sku" {
  source = "../modules/policy/policy-assignment/allowed-vm-sku"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.allowed_vm_sku_policy_id
  resource_group_id    = each.value
  resource_group_name  = each.key
  allowed_vm_sku       = ["Standard_A1", "Standard_A2", "Standard_A3"]
  env                  = "dev"
  depends_on           = [module.policy_definition, module.resource_group]

}

module "resource_assignment_vm_ext" {
  source = "../modules/policy/policy-assignment/not-allowed-vm-ext"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.allowed_vm_sku_policy_id
  resource_group_id    = each.value
  resource_group_name  = each.key
  vm_extensions        = ["Standard_A1", "Standard_A2", "Standard_A3"]
  env                  = "dev"
  depends_on           = [module.policy_definition, module.resource_group]

}


 */