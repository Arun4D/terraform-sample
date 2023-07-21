resource "azurerm_resource_group_policy_assignment" "no_network_peerings_to_er_network_policy_assignment" {
  name                 = "${var.env}_no_network_peerings_to_er_network_policy_assignment"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id

  parameters = jsonencode({
    "resourceGroupName" : { "value" : var.resourceGroupName }
  })
}

