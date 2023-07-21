data "template_file" "not_allowed_vm_ext_policy_rule" {
  template = <<POLICY_RULE
 {
    "if": { 
      "allOf": [ 
        {
          "field": "type",
          "equals": "Microsoft.Compute/virtualMachines/extensions"
        },
        {
          "field": "Microsoft.Compute/virtualMachines/extensions/publisher",
          "equals": "Microsoft.Compute"
        },
        {
          "field": "Microsoft.Compute/virtualMachines/extensions/type",
          "in": "[parameters('notAllowedExtensions')]"
        }
      ] 
    }, 
    "then": { 
      "effect": "deny" 
    } 
 }
POLICY_RULE
}
data "template_file" "not_allowed_vm_ext_policy_rule_params" {
  template = <<PARAMETERS
 {
    "notAllowedExtensions": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed VM sku's.",
        "displayName": "Allowed VM SKU",
        "strongType": "Microsoft.Compute/virtualMachines/extensions/type"
      }
    }
  }
PARAMETERS
}

data "template_file" "not_allowed_vm_ext_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}

data "template_file" "not_allowed_vm_ext_policy_rule_params_value" {
  template = <<VALUE
    {
      "listOfNotAllowedExtensions": {"value": "[parameters('notAllowedExtensions')]"}
    }
    VALUE

}

/* resource "azurerm_policy_definition" "not_allowed_vm_ext_policy_def" {
  name         = "${var.env}_not_allowed_vm_ext_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Not allowed VM ext policy definition"

  metadata = data.template_file.not_allowed_vm_ext_policy_rule_meta.rendered

  policy_rule = data.template_file.not_allowed_vm_ext_policy_rule.rendered


  parameters = data.template_file.not_allowed_vm_ext_policy_rule_params.rendered

} */