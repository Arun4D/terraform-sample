resource_group_location     = "eastus"
resource_group_name_prefix  = "rg"
vnet_name                   = "myVnet"
vnet_address_space          = ["10.0.0.0/16"]
subnet_name                 = "mySubnet"
subnet_address_prefixes     = ["10.0.1.0/24"]
public_ip_name              = "myPublicIP"
public_ip_allocation_method = "Static"
nic_name                    = "myNIC"

nic_ip_config_name                          = "my_nic_configuration"
nic_ip_config_private_ip_address_allocation = "Dynamic"

nsg_name = "myNetworkSecurityGroup"

default_tags = {
  environment = "prod"
  department  = "finance"
  source      = "terraform"
}

disable_bgp_route_propagation = false
route_name                    = "myRoute"
route_address_prefix          = "10.1.0.0/16"
route_next_hop_type           = "VnetLocal"

#Backup File Share
recovery_services_vault_name                   = "tfex-recovery-vault"
recovery_services_vault_sku                    = "Standard"
storage_account_name                           = "ad0in0fileshare0sa"
storage_account_account_tier                   = "Standard"
storage_account_account_replication_type       = "LRS"
storage_share                                  = "example-share"
backup_policy_file_share_name                  = "tfex-recovery-vault-policy"
backup_policy_file_share_backup_frequency      = "Daily"
backup_policy_file_share_backup_time           = "23:00"
backup_policy_file_share_retention_daily_count = 10

#Availability set
availability_set_name= "example-avail-set"
platform_fault_domain_count= 3
platform_update_domain_count = 5

