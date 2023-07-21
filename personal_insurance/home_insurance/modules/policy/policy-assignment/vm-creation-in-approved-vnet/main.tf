resource "azurerm_resource_group_policy_assignment" "vm_creation_in_approved_vnet_policy_assignment" {
  name                 = "${var.env}_vm_creation_in_approved_vnet_policy_assignment_policy_assign"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id

  parameters = jsonencode({
    "vNetId" : { "value" : var.vNetId }
  })
}

