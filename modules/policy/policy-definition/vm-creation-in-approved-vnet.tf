data "template_file" "vm_creation_in_approved_vnet_policy_rule" {
  template = <<POLICY_RULE
 {
	"if": {
		"allOf": [
			{
				"field": "type",
				"equals": "Microsoft.Network/networkInterfaces"
			},
			{
				"not": {
					"field": "Microsoft.Network/networkInterfaces/ipconfigurations[*].subnet.id",
					"like": "[concat(parameters('vNetId'),'*')]"
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
data "template_file" "vm_creation_in_approved_vnet_policy_rule_params" {
  template = <<PARAMETERS
 {
	"vNetId": {
		"type": "string",
		"metadata": {
			"description": "Resource Id for the vNet",
			"displayName": "vNet Id"
		}
	}
}
PARAMETERS
}

data "template_file" "vm_creation_in_approved_vnet_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}

data "template_file" "vm_creation_in_approved_vnet_policy_rule_params_value" {
  template = <<VALUE
    {
      "vNetId": {"value": "parameters('vNetId')"}
    }
    VALUE

}

resource "azurerm_policy_definition" "vm_creation_in_approved_vnet_policy_def" {
  name         = "${var.env}_vm_creation_in_approved_vnet_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Use approved vNet for VM network interfaces"

  metadata = data.template_file.vm_creation_in_approved_vnet_policy_rule_meta.rendered

  policy_rule = data.template_file.vm_creation_in_approved_vnet_policy_rule.rendered


  parameters = data.template_file.vm_creation_in_approved_vnet_policy_rule_params.rendered

}