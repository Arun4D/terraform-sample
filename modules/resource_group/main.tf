/*resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}
*/
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  # name     = random_pet.rg_name.id
  name = var.resource_group_name
  tags = var.default_tags
}
/*
resource "azurerm_management_lock" "rg" {
  name       = random_pet.rg_name.id
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"
  notes      = "Locked for compliance"
}
*/
