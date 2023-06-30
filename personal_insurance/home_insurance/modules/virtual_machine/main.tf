
# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM"
  location              = var.resource_group_rg_location
  resource_group_name   = var.resource_group_rg_name
  network_interface_ids = [var.my_terraform_nic_id]
  size                  = "Standard_B1ls"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = var.primary_blob_endpoint
  }

  tags = var.default_tags
}

resource "null_resource" "exec_script" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
    ]

    connection {
      type = "ssh"
      user = "azureuser"
      host = var.public_ip_address
      private_key = "${file("~/.ssh/id_rsa")}"
      timeout = "1m"
      agent = false
    }
  }
}