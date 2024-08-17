locals {
  scope_id                = var.scope_id
  template_file_variables = var.template_file_variables
}
locals {
  core_template_file_variables = {
    current_scope_id          = basename(local.scope_id)
    current_scope_resource_id = local.scope_id
  }
  template_file_vars = merge(
    local.template_file_variables,
    local.core_template_file_variables,
  )
}

locals {
  builtin_library_path                 = "${path.module}/lib"
  builtin_policy_definitions_from_json = tolist(fileset(local.builtin_library_path, "**/policy_definition_*.{json,json.tftpl}"))

  builtin_policy_definitions_from_yaml = tolist(fileset(local.builtin_library_path, "**/policy_definition_*.{yml,yml.tftpl,yaml,yaml.tftpl}"))

  builtin_policy_definitions_dataset_from_json = try(length(local.builtin_policy_definitions_from_json) > 0, false) ? {
    for filepath in local.builtin_policy_definitions_from_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null

  builtin_policy_definitions_dataset_from_yaml = try(length(local.builtin_policy_definitions_from_yaml) > 0, false) ? {
    for filepath in local.builtin_policy_definitions_from_yaml :
    filepath => yamldecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null

  builtin_policy_definitions_map_from_json = try(length(local.builtin_policy_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.builtin_policy_definitions_dataset_from_json :
    value.name => value
    if value.type == local.resource_types.policy_definition
  } : null

  builtin_policy_definitions_map_from_yaml = try(length(local.builtin_policy_definitions_dataset_from_yaml) > 0, false) ? {
    for key, value in local.builtin_policy_definitions_dataset_from_yaml :
    value.name => value
    if value.type == local.resource_types.policy_definition
  } : null
}


locals {
  archetype_policy_definitions_map = merge(
    local.builtin_policy_definitions_map_from_json,
    local.builtin_policy_definitions_map_from_yaml,
  )
}

locals {
  resource_types = {
    policy_assignment     = "Microsoft.Authorization/policyAssignments"
    policy_definition     = "Microsoft.Authorization/policyDefinitions"
    policy_set_definition = "Microsoft.Authorization/policySetDefinitions"
    role_assignment       = "Microsoft.Authorization/roleAssignments"
    role_definition       = "Microsoft.Authorization/roleDefinitions"
  }
  provider_path = {
    policy_assignment     = "${local.scope_id}/providers/Microsoft.Authorization/policyAssignments/"
    policy_definition     = "${local.scope_id}/providers/Microsoft.Authorization/policyDefinitions/"
    policy_set_definition = "${local.scope_id}/providers/Microsoft.Authorization/policySetDefinitions/"
    role_assignment       = "${local.scope_id}/providers/Microsoft.Authorization/roleAssignments/"
    role_definition       = "/providers/Microsoft.Authorization/roleDefinitions/"
  }
}