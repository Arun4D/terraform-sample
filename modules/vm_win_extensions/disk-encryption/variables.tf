variable "default_tags" {
  type        = map(any)
  description = "Tag for the azure resources"
}

variable "virtual_machine_id" {}

variable "publisher" { default  = "Microsoft.Azure.Security"}
variable "type" { default = "AzureDiskEncryption" }
variable "type_handler_version" { default = "2.2" }
variable "EncryptionOperation" { default = "EnableEncryption" }
variable "KeyEncryptionAlgorithm" { default = "RSA-OAEP"}
variable "VolumeType" {default = "All" }
variable "KeyVaultResourceId" {}
variable "KeyEncryptionKeyURL" {}
variable "KekVaultResourceId" {}

variable "KeyVaultURL" {}
