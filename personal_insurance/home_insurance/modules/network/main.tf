# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  tags                = var.default_tags
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_rg_name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = var.subnet_address_prefixes

  depends_on = [
    azurerm_virtual_network.my_terraform_network
  ]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = var.public_ip_name
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name
  allocation_method   = var.public_ip_allocation_method
  tags                = var.default_tags
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = var.nsg_name
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name

  security_rule {
    name                       = "AllowAnyRDPInbound"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = var.default_tags
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = var.nic_name
  location            = var.resource_group_rg_location
  resource_group_name = var.resource_group_rg_name

  ip_configuration {
    name                          = var.nic_ip_config_name
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = var.nic_ip_config_private_ip_address_allocation
    #public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
  tags = var.default_tags

  depends_on = [
    azurerm_subnet.my_terraform_subnet,
    #azurerm_public_ip.my_terraform_public_ip
  ]
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id

  depends_on = [
    azurerm_network_interface.my_terraform_nic,
    azurerm_network_security_group.my_terraform_nsg
  ]

}
