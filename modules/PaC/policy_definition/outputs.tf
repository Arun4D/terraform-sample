output "output_policy_definitions" {
  value = { for pd in azurerm_policy_definition.policy_definition : pd.name => pd.id }
}