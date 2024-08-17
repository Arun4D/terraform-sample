resource "azurerm_virtual_machine_extension" "disk-encryption" {
  name                 = "DiskEncryption"
  virtual_machine_id   = var.virtual_machine_id
  publisher            = var.publisher
  type                 = var.type
  type_handler_version = var.type_handler_version

  settings = <<SETTINGS
{
  "EncryptionOperation": "${var.EncryptionOperation}",
  "KeyVaultURL": "${var.KeyVaultURL}",
  "KeyVaultResourceId": "${var.KeyVaultResourceId}",
  
  "KeyEncryptionAlgorithm": "${var.KeyEncryptionAlgorithm}",
  "VolumeType": "${var.VolumeType}"
}
SETTINGS
}

/*   "KeyEncryptionKeyURL": "${var.KeyEncryptionKeyURL}",
  "KekVaultResourceId": "${var.KekVaultResourceId}", */