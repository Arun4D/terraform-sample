resource "azurerm_windows_virtual_machine" "my_windows_vm" {
  name                = "myVM"
  location              = var.resource_group_rg_location
  resource_group_name   = var.resource_group_rg_name
  network_interface_ids = [var.my_terraform_nic_id]
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  computer_name                   = "myvm"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  boot_diagnostics {
    storage_account_uri = var.primary_blob_endpoint
  }
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  tags = var.default_tags

  depends_on = [ azurerm_user_assigned_identity.example ]
}

resource "azurerm_user_assigned_identity" "example" {
  location            = var.resource_group_rg_location
  name                = "example-id"
  resource_group_name = var.resource_group_rg_name
}

