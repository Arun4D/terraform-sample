packer {
  required_plugins {
    azure = {
      version = "= 1.4.4"
      source  = "github.com/hashicorp/azure"
    }
    windows-update = {
      version = "0.14.1"
      source  = "github.com/rgl/windows-update"
    }
  }
}

source "azure-arm" "autogenerated_1" {
  azure_tags = {
    dept = "AD_Test"
    task = "Image deployment"
  }
 


  
  build_resource_group_name         = "ad-tf-img-rg"
  object_id = "6d79dc51-4b1c-4736-b5f0-67696a7c74c2"
  client_id                         = "cdbbfa31-3552-4dde-a4cf-3c573a4288c1"
  client_secret                     = ""
  communicator                      = "winrm"
  image_offer                       = "WindowsServer"
  image_publisher                   = "MicrosoftWindowsServer"
  image_sku                         = "2016-Datacenter"

  build_key_vault_name ="ad-tf-img-crt-vault"

  #VHD example
  #resource_group_name    = "ad-tf-img-rg"
  #storage_account = "adtfimgstg02"
  #capture_container_name = "ad-images"
  #capture_name_prefix    = "packer_server2019"
  
  managed_image_resource_group_name = "ad-tf-img-rg"
  managed_image_name = "packer_server2019"
  
  
 
  os_type                           = "Windows"
  subscription_id                   = "fe03bde0-15db-4f68-ac6f-f23934db804f"
  tenant_id                         = "123dcb03-eb91-46b6-a976-f729e0527971"
  vm_size                           = "Standard_B1ls"
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
  winrm_password                   = "SuperS3cr3t!!!"
}

build {
  sources = ["source.azure-arm.autogenerated_1"]

  provisioner "powershell" {
    
    #inline = ["Add-WindowsFeature Web-Server", "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
    inline = ["dir c:/"]
  }

}