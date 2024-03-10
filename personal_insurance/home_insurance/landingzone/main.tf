module "management_group" {
  source          = "../modules/management_group"
  mgmt_grp_config = local.mng_grp_config
}

module "policy_definition" {
  source = "../modules/PaC/policy_definition"

  scope_id                = module.management_group.mgmt_grp_level1_ids["Landing Zones"]
  template_file_variables = local.template_file_variables

  depends_on = [module.management_group]
}

module "management_group_policy_assignment" {
  source = "../modules/PaC/management_group_policy_assignment"

  scope_id              = module.management_group.mgmt_grp_level1_ids["Landing Zones"]
  policy_definition_ids = local.policy_definition_ids

  depends_on = [module.management_group, module.policy_definition]
}

