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
  depends_on                                  = [module.resource_group, time_sleep.delay_30sec]

}

resource "time_sleep" "delay_30sec" {
  create_duration  = "30s"
  destroy_duration = "30s"
}
module "storage" {
  source = "../../modules/storage"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  default_tags               = var.default_tags
  depends_on                 = [module.resource_group, module.network, time_sleep.delay_30sec]

}


module "virtual_machine_win" {
  source = "../../modules/virtual_machine_win"

  resource_group_rg_location = var.resource_group_location
  resource_group_rg_name     = module.resource_group.resource_group_name
  primary_blob_endpoint      = module.storage.primary_blob_endpoint
  my_terraform_nic_id        = module.network.terraform_nic_id
  size                       = "Standard_B2ms"
  public_ip_fqdn             = null
  public_ip_address          = null
  zone                       = 2
  # availability_set_id        = module.availability_set.availability_set_id
  #disk_encryption_set_id     = module.disk_encryption_set.azurerm_disk_encryption_set_id
  image_publisher = var.vm_image["publisher"]
  image_offer     = var.vm_image["offer"]
  image_sku       = var.vm_image["sku"]
  image_version   = var.vm_image["version"]
  default_tags    = var.default_tags
  depends_on = [
    module.resource_group, module.network, module.ssh_keys, module.storage
  ]
}

module "asr_resource_group" {
  source = "../../modules/resource_group"


  resource_group_name     = var.asr_resource_group_name
  resource_group_location = var.resource_group_location
  default_tags            = var.default_tags
  depends_on              = [module.virtual_machine_win]
}

resource "azurerm_recovery_services_vault" "vault" {
  name                         = "example-recovery-vault"
  resource_group_name          = var.asr_resource_group_name
  location                     = var.resource_group_location
  sku                          = "Standard"
  storage_mode_type            = "LocallyRedundant"
  cross_region_restore_enabled = false
  depends_on                   = [module.virtual_machine_win, module.asr_resource_group]
}

resource "azurerm_site_recovery_fabric" "primary" {
  name                = "primary-fabric"
  resource_group_name = var.asr_resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  location            = var.resource_group_location
  depends_on          = [azurerm_recovery_services_vault.vault]
}


resource "azurerm_site_recovery_protection_container" "primary" {
  name                 = "primary-protection-container"
  resource_group_name  = var.asr_resource_group_name
  recovery_vault_name  = azurerm_recovery_services_vault.vault.name
  recovery_fabric_name = azurerm_site_recovery_fabric.primary.name

  depends_on = [azurerm_recovery_services_vault.vault, azurerm_site_recovery_fabric.primary]
}

resource "azurerm_storage_account" "primary" {
  name                     = "adprireccacheasr"
  resource_group_name      = var.asr_resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [module.asr_resource_group]
}


resource "azurerm_site_recovery_replication_policy" "policy" {
  name                                                 = "policy"
  resource_group_name                                  = var.asr_resource_group_name
  recovery_vault_name                                  = azurerm_recovery_services_vault.vault.name
  recovery_point_retention_in_minutes                  = 24 * 60
  application_consistent_snapshot_frequency_in_minutes = 4 * 60
  depends_on                                           = [module.asr_resource_group]
}

data "azurerm_managed_disk" "my_windows_vm" {
  name                = "myVM_OsDisk_1_12a951d470a44e3f81d99f5da079f591"
  resource_group_name = "ad-terr-rg1"
  depends_on          = [module.virtual_machine_win]
}
data "azurerm_site_recovery_protection_container" "default" {

  name                 = "asr-a2a-default-northeurope-container"
  recovery_vault_name  = azurerm_recovery_services_vault.vault.name
  resource_group_name  = var.asr_resource_group_name
  recovery_fabric_name = azurerm_site_recovery_fabric.primary.name
}

resource "azapi_resource" "replication_vm" {
  type      = "microsoft.recoveryservices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectedItems@2023-06-01"
  name      = "KegpxKCffRfxmGE17wrk9Bt6xZPxMEcd5Hbtb2WPCfQ"
  parent_id = "/subscriptions/fe03bde0-15db-4f68-ac6f-f23934db804f/resourceGroups/ad-asr-rg/providers/microsoft.recoveryservices/vaults/example-recovery-vault/replicationFabrics/primary-fabric/replicationProtectionContainers/asr-a2a-default-northeurope-container"
  #data.azurerm_site_recovery_protection_container.default.id
  body = jsonencode({
    properties = {
      policyId          = "/Subscriptions/fe03bde0-15db-4f68-ac6f-f23934db804f/resourceGroups/ad-asr-rg/providers/microsoft.recoveryservices/vaults/example-recovery-vault/replicationPolicies/policy"
      protectableItemId = null
      providerSpecificDetails = {
        instanceType                       = "A2A"
        fabricObjectId                     = lower(module.virtual_machine_win.my_windows_vm_id)
        multiVmGroupId                     = "6ab3d8ac-5234-456d-9c99-72cc5694b688"
        multiVmGroupName                   = ""
        recoveryBootDiagStorageAccountId   = null
        recoveryCapacityReservationGroupId = null
        //recoveryContainerId = azurerm_site_recovery_protection_container.primary.id
        recoveryExtendedLocation          = null
        recoveryProximityPlacementGroupId = null
        recoveryVirtualMachineScaleSetId  = null

        recoveryAvailabilityZone = "3"
        vmDisks = [
          {
            diskUri                             = data.azurerm_managed_disk.my_windows_vm.id
            primaryStagingAzureStorageAccountId = azurerm_storage_account.primary.id
            recoveryAzureStorageAccountId       = azurerm_storage_account.primary.id
            #recoveryResourceGroupId             = module.asr_resource_group.resource_group_id
          },
        ]
      }
    }
  })
  depends_on = [data.azurerm_site_recovery_protection_container.default]
}



/*resource "azurerm_site_recovery_replicated_vm" "vm-replication" {
  name                                      = "vm-replication"
  resource_group_name                       = var.asr_resource_group_name
  recovery_vault_name                       = azurerm_recovery_services_vault.vault.name
  source_recovery_fabric_name               = azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = module.virtual_machine_win.my_windows_vm_id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.policy.id
  #source_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary.name
  source_recovery_protection_container_name = data.azurerm_site_recovery_protection_container.default.name

  target_resource_group_id                = module.asr_resource_group.resource_group_id
  target_recovery_fabric_id               = azurerm_site_recovery_fabric.primary.id
  #target_recovery_protection_container_id = azurerm_site_recovery_protection_container.primary.id
  target_recovery_protection_container_id = data.azurerm_site_recovery_protection_container.default.id

  managed_disk {
    disk_id                    = data.azurerm_managed_disk.my_windows_vm.id
    staging_storage_account_id = azurerm_storage_account.primary.id
    target_resource_group_id   = module.asr_resource_group.resource_group_id
    target_disk_type           = "Premium_LRS"
    target_replica_disk_type   = "Premium_LRS"
  }


  depends_on = [
    module.virtual_machine_win,
    module.asr_resource_group,
    azurerm_site_recovery_fabric.primary,
    azurerm_recovery_services_vault.vault,
    data.azurerm_managed_disk.my_windows_vm,
    azurerm_site_recovery_fabric.primary,
    azurerm_site_recovery_protection_container.primary,
    azurerm_site_recovery_replication_policy.policy
  ]
}*/
