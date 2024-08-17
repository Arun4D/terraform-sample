data "template_file" "enforce_nsg_on_subnet_policy_rule" {
  template = <<POLICY_RULE
 {
	"if": {
		"anyOf": [
			{
				"allOf": [
					{
						"field": "type",
						"equals": "Microsoft.Network/virtualNetworks"
					},
					{
						"not": {
							"field": "Microsoft.Network/virtualNetworks/subnets[*].networkSecurityGroup.id",
							"equals": "[parameters('nsgId')]"
						}
					}
				]
			},
			{
				"allOf": [
					{
						"field": "type",
						"equals": "Microsoft.Network/virtualNetworks/subnets"
					},
					{
						"not": {
							"field": "Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id",
							"equals": "[parameters('nsgId')]"
						}
					}
				]
			}
		]
	},
	"then": {
		"effect": "deny"
	}
}
POLICY_RULE
}
data "template_file" "enforce_nsg_on_subnet_policy_rule_params" {
  template = <<PARAMETERS
 {
	"nsgId": {
		"type": "String",
		"metadata": {
			"description": "Resource Id of the Network Security Group",
			"displayName": "NSG Id"
		}
	}
}
PARAMETERS
}

data "template_file" "enforce_nsg_on_subnet_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}

data "template_file" "enforce_nsg_on_subnet_policy_rule_params_value" {
  template = <<VALUE
    {
      "nsgId": {"value": "parameters('nsgId')"}
    }
    VALUE

}

resource "azurerm_policy_definition" "enforce_nsg_on_subnet_policy_def" {
  name         = "${var.env}_enforce_nsg_on_subnet_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "NSG X on every subnets"

  metadata = data.template_file.enforce_nsg_on_subnet_policy_rule_meta.rendered

  policy_rule = data.template_file.enforce_nsg_on_subnet_policy_rule.rendered


  parameters = data.template_file.enforce_nsg_on_subnet_policy_rule_params.rendered

}