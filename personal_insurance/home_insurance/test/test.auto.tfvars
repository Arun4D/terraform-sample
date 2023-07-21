resource_group_location = "northeurope"
resource_group_name     = "rsai-deven-rg"

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