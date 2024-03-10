locals {
  mng_grp_config = var.config.management_group
}

locals {
  template_file_variables = {}
  policy_definition_ids = {for pd_key, pd_value  in   module.policy_definition.output_policy_definitions : pd_key => { name : substr(pd_key, 0, 23) , policy_definition_id: pd_value  } }
}