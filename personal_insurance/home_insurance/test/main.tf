
module "resource_group" {
  source = "../modules/resource_group"

  for_each = var.resource_group_names

  resource_group_name     = each.value
  resource_group_location = var.resource_group_location
  default_tags            = var.default_tags
}

module "policy_definition" {
  source = "../modules/policy/policy-definition"

  env = "dev"
  /* allowedLocations = ["northeurope", "westeurope"] */
}

module "resource_assignment_allowed_loc" {
  source = "../modules/policy/policy-assignment/allowed-location"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.allowed_location_policy_def_id
  resource_group_id    = each.value
  resource_group_name  = each.key
  allowedLocations     = ["northeurope", "westeurope"]
  env                  = "dev"
  depends_on           = [module.policy_definition, module.resource_group]

}

module "resource_assignment_naming" {
  source = "../modules/policy/policy-assignment/naming"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.naming_policy_def_id
  resource_group_id    = each.value
  resource_group_name  = each.key

  naming_regx = "rsai-*-rg"
  env         = "dev"
  depends_on  = [module.policy_definition, module.resource_group]

}

module "resource_assignment_tagging" {
  source = "../modules/policy/policy-assignment/tagging"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.tagging_policy_id
  resource_group_id    = each.value
  resource_group_name  = each.key

  env        = "dev"
  depends_on = [module.policy_definition, module.resource_group]

}

module "resource_assignment_vm_sku" {
  source = "../modules/policy/policy-assignment/allowed-vm-sku"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.allowed_vm_sku_policy_id
  resource_group_id    = each.value
  resource_group_name  = each.key
  allowed_vm_sku       = ["Standard_A1", "Standard_A2", "Standard_A3"]
  env                  = "dev"
  depends_on           = [module.policy_definition, module.resource_group]

}

module "resource_assignment_vm_ext" {
  source = "../modules/policy/policy-assignment/not-allowed-vm-ext"

  for_each             = { for k, v in module.resource_group : v.resource_group_name => v.resource_group_id }
  policy_definition_id = module.policy_definition.allowed_vm_sku_policy_id
  resource_group_id    = each.value
  resource_group_name  = each.key
  vm_extensions        = ["Standard_A1", "Standard_A2", "Standard_A3"]
  env                  = "dev"
  depends_on           = [module.policy_definition, module.resource_group]

}


