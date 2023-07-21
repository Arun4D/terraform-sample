terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {

  #alias = "sitea"

  subscription_id = ""
  tenant_id = ""

  auxiliary_tenant_ids = [""]  

  features { }
}

provider "azurerm" {
  
  alias = "siteb"
  
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""  
  
  auxiliary_tenant_ids = [""]  

  features { }  
}