resource "azurerm_policy_remediation" "allowed_location_policy_remediation" {
  name = "${var.env}-allowed_location_policy_remediation"
  #resource_group_id    = var.resource_group_id
  scope                   = var.resource_group_id
  policy_assignment_id    = var.policy_assignment_id
  resource_discovery_mode = "ReEvaluateCompliance"
}