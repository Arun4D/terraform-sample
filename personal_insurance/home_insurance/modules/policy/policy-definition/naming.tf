data "template_file" "naming_policy_rule" {
  template = <<POLICY_RULE
    {
    "if": {
        "allOf":[
            {
                "not":{
                    "field":"name",
                    "match":"[parameters('namePattern')]"
                }
            },
            {
                "field": "type",
                "equals": "Microsoft.Resources/subscriptions/resourceGroups"
            }
        ]
    },
    "then": { 
      "effect": "deny"
    }
  }
POLICY_RULE
}
data "template_file" "naming_policy_rule_params" {
  template = <<PARAMETERS
    {
        "namePattern":{
            "type": "String",
            "metadata":{
                "displayName": "namePattern",
                "description": "? for letter, # for numbers"
            }
        }
  }
PARAMETERS
}

data "template_file" "naming_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}


resource "azurerm_policy_definition" "naming_policy_def" {
  name         = "${var.env}-naming_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Naming policy definition"

  metadata = data.template_file.naming_policy_rule_meta.rendered

  policy_rule = data.template_file.naming_policy_rule.rendered


  parameters = data.template_file.naming_policy_rule_params.rendered

}
