resource "azurerm_windows_virtual_machine" "my_windows_vm" {
  name                  = "myVM"
  location              = var.resource_group_rg_location
  resource_group_name   = var.resource_group_rg_name
  network_interface_ids = [var.my_terraform_nic_id]
  size                  = "Standard_F2"
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd1234!"
  computer_name         = "myvm"
  # Not enabled for student subscription
  # encryption_at_host_enabled = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_encryption_set_id = var.disk_encryption_set_id
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  boot_diagnostics {
    storage_account_uri = var.primary_blob_endpoint
  }
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  tags = var.default_tags

  depends_on = [azurerm_user_assigned_identity.example]
}

resource "azurerm_user_assigned_identity" "example" {
  location            = var.resource_group_rg_location
  name                = "example-id"
  resource_group_name = var.resource_group_rg_name
}

