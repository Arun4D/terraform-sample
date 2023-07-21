data "template_file" "allowed_location_policy_rule" {
  template = <<POLICY_RULE
 {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "audit"
    }
  }
POLICY_RULE
}
data "template_file" "allowed_location_policy_rule_params" {
  template = <<PARAMETERS
 {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS
}

data "template_file" "allowed_location_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}

data "template_file" "allowed_location_policy_rule_params_value" {
  template = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE

}

/* resource "azurerm_policy_definition" "allowed_location_policy_def" {
  name         = "${var.env}-allowed_location_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "acceptance test policy definition"

  metadata = data.template_file.allowed_location_policy_rule_meta.rendered

  policy_rule = data.template_file.allowed_location_policy_rule.rendered


  parameters = data.template_file.allowed_location_policy_rule_params.rendered

} */
