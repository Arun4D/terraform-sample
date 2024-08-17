data "template_file" "no_network_peerings_to_er_network_policy_rule" {
  template = <<POLICY_RULE
 {
	"if": {
		"allOf": [
			{
				"field": "type",
				"equals": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings"
			},
			{
				"field": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/remoteVirtualNetwork.id",
				"contains": "[concat('resourceGroups/',parameters('resourceGroupName'))]"
			}
		]
	},
	"then": {
		"effect": "deny"
	}
}
POLICY_RULE
}
data "template_file" "no_network_peerings_to_er_network_policy_rule_params" {
  template = <<PARAMETERS
 {
	"resourceGroupName": {
		"type": "String",
		"metadata": {
			"description": "Name of the resource group with ER Network",
			"displayName": "ER Network Resource Group Name",
			"strongType": "ExistingResourceGroups"
		}
	}
}
PARAMETERS
}

data "template_file" "no_network_peerings_to_er_network_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}

data "template_file" "no_network_peerings_to_er_network_policy_rule_params_value" {
  template = <<VALUE
    {
      "resourceGroupName": {"value": "parameters('resourceGroupName')"}
    }
    VALUE

}

resource "azurerm_policy_definition" "no_network_peerings_to_er_network_policy_def" {
  name         = "${var.env}_no_network_peerings_to_er_network_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Use approved vNet for VM network interfaces"

  metadata = data.template_file.no_network_peerings_to_er_network_policy_rule_meta.rendered

  policy_rule = data.template_file.no_network_peerings_to_er_network_policy_rule.rendered


  parameters = data.template_file.no_network_peerings_to_er_network_policy_rule_params.rendered

}