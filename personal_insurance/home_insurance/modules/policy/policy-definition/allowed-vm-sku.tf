data "template_file" "allowed_vm_sku_policy_rule" {
  template = <<POLICY_RULE
 {
    "if": { 
      "allOf": [ 
        { 
          "field": "type", 
          "equals": "Microsoft.Compute/virtualMachines" 
        }, 
        { 
          "not": { 
            "field": "Microsoft.Compute/virtualMachines/sku.name", 
            "in": "[ parameters('allowedSku') ]"
            
          } 
        } 
      ] 
    }, 
    "then": { 
      "effect": "deny" 
    } 
 }
POLICY_RULE
}
data "template_file" "allowed_vm_sku_policy_rule_params" {
  template = <<PARAMETERS
 {
    "allowedSku": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed VM sku's.",
        "displayName": "Allowed VM SKU",
        "strongType": "Microsoft.Compute/virtualMachines/sku.name"
      }
    }
  }
PARAMETERS
}

data "template_file" "allowed_vm_sku_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}

data "template_file" "allowed_vm_sku_policy_rule_params_value" {
  template = <<VALUE
    {
      "listOfAllowedSku": {"value": "[parameters('allowedSku')]"}
    }
    VALUE

}

resource "azurerm_policy_definition" "allowed_vm_sku_policy_def" {
  name         = "${var.env}-allowed_vm_sku_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed VM SKU policy definition"

  metadata = data.template_file.allowed_vm_sku_policy_rule_meta.rendered

  policy_rule = data.template_file.allowed_vm_sku_policy_rule.rendered


  parameters = data.template_file.allowed_vm_sku_policy_rule_params.rendered

}