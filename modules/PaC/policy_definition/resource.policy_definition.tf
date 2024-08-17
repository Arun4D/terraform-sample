resource "azurerm_policy_definition" "policy_definition" {
  for_each = local.archetype_policy_definitions_map

  # Mandatory resource attributes
  name         = each.value.name
  policy_type  = "Custom"
  mode         = each.value.properties.mode
  display_name = each.value.properties.displayName

  # Optional resource attributes
  description         = try(each.value.properties.description, "${each.value.name} Policy Definition at scope ${local.scope_id}")
  management_group_id = try(local.scope_id, null)
  policy_rule         = try(length(each.value.properties.policyRule) > 0, false) ? jsonencode(each.value.properties.policyRule) : null
  metadata            = try(length(each.value.properties.metadata) > 0, false) ? jsonencode(each.value.properties.metadata) : null
  parameters          = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null

}