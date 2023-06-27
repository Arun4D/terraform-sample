resource_group_location     = "eastus"
resource_group_name_prefix  = "rg"
vnet_name                   = "myVnet"
vnet_address_space          = ["10.0.0.0/16"]
subnet_name                 = "mySubnet"
subnet_address_prefixes     = ["10.0.1.0/24"]
public_ip_name              = "myPublicIP"
public_ip_allocation_method = "Dynamic"
nic_name                    = "myNIC"

nic_ip_config_name                          = "my_nic_configuration"
nic_ip_config_private_ip_address_allocation = "Dynamic"

nsg_name = "myNetworkSecurityGroup"

default_tags = {
  environment = "prod"
  department  = "finance"
  source      = "terraform"
}
