locals {
  level0 = var.mgmt_grp_config["level0"]
  level1 = { for level1_value in try(local.level0["level1"], []) : level1_value["id"] => level1_value }
  level2_array = flatten([
    for  level1_value in local.level0["level1"] : [
      for level2_value in try(level1_value["level2"],[]) : {
        id           = level2_value["id"]
        display_name = level2_value["display_name"]
        subscription_ids = level2_value["subscription_ids"]
        parent_management_group_id = azurerm_management_group.level_1[level1_value["id"]].id
        level3 = try(level2_value["level3"],[])
      }
    ]
  ])
  level2 = { for level2_value in local.level2_array: level2_value["id"] => level2_value }
}
resource "azurerm_management_group" "level_0" {
  name             = local.level0["id"]
  display_name     = local.level0["display_name"]
  subscription_ids = local.level0["subscription_ids"]

}

resource "azurerm_management_group" "level_1" {
  for_each = local.level1

  name                       = each.value["id"]
  display_name               = each.value["display_name"]
  subscription_ids           = each.value["subscription_ids"]
  parent_management_group_id = azurerm_management_group.level_0.id

  depends_on = [azurerm_management_group.level_0]

}

resource "azurerm_management_group" "level_2" {
  for_each = local.level2

  name                       = each.value["id"]
  display_name               = each.value["display_name"]
  subscription_ids           = each.value["subscription_ids"]
  parent_management_group_id = each.value["parent_management_group_id"]

  depends_on = [azurerm_management_group.level_1]

}
