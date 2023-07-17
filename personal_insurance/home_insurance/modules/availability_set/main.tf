resource "azurerm_availability_set" "exampe_availability_set" {
  name                         = var.availability_set_name
  location                     = var.resource_group_rg_location
  resource_group_name          = var.resource_group_rg_name
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count
  tags                         = var.default_tags
}