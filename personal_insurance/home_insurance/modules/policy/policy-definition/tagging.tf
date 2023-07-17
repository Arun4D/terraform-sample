## Define tagging policies for different tags (check policy rule)

data "template_file" "entity_tag_policy_rule" {
  template = <<POLICY_RULE
    {   
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field": "tags['entity']",
            "exists": "false"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
POLICY_RULE

}
data "template_file" "metadata" {
  template = <<METADATA
    {
    "version": "1.0.0",
    "category": "Custom"
    }

METADATA
}

data "template_file" "costcenter_tag_policy_rule" {
  template = <<POLICY_RULE
    {   
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field": "tags['costcenter']",
            "exists": "false"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
POLICY_RULE
}

data "template_file" "inherit_tag_params" {
  template = <<PARAMETERS
    {
        "tagName": {
            "type": "String",
            "metadata": {
                "displayName": "Tag Name",
                "description": "Name of the tag, such as 'environment'"
            }
        }
    }
PARAMETERS
}
data "template_file" "inherit_tag_policy_rule" {
  template = <<POLICY_RULE
    {
        "if": {
            "allOf": [{
                    "field": "[concat('tags[', parameters('tagName'), ']')]",
                    "notEquals": "[resourceGroup().tags[parameters('tagName')]]"
                },
                {
                    "value": "[resourceGroup().tags[parameters('tagName')]]",
                    "notEquals": ""
                }
            ]
        },
        "then": {
            "effect": "modify",
            "details": {
                "roleDefinitionIds": [
                    "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
                ],
                "operations": [{
                    "operation": "addOrReplace",
                    "field": "[concat('tags[', parameters('tagName'), ']')]",
                    "value": "[resourceGroup().tags[parameters('tagName')]]"
                }]
            }
        }
    }
POLICY_RULE

}

data "template_file" "inherit_entity_tag_params" {
  template = <<PARAMETERS
    {
    "tagName": {
        "value": "entity"
        }
    }
PARAMETERS
}

data "template_file" "inherit_costcenter_tag_params" {
  template = <<PARAMETERS
    {
    "tagName": {
        "value": "costcenter"
        }
    }
PARAMETERS
}

## Deny creation of resource groups missing certain tags
resource "azurerm_policy_definition" "require-tag-entity-on-rg" {
  name         = "require-tag-entity-on-rg"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require tag 'entity' on resource group"



  metadata = data.template_file.metadata.rendered

  policy_rule = data.template_file.entity_tag_policy_rule.rendered
}

resource "azurerm_policy_definition" "require-tag-costcenter-on-rg" {
  name         = "require-tag-costcenter-on-rg"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require tag 'costcenter' on resource group"



  metadata = data.template_file.metadata.rendered

  policy_rule = data.template_file.costcenter_tag_policy_rule.rendered

}


# Inherit resource tags from Resource Group
# Contributor role - b24988ac-6180-42a0-ab88-20f7382dd24c"

resource "azurerm_policy_definition" "inherit-tag" {
  name         = "inherit-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Inherit tag from resource group"



  metadata = data.template_file.metadata.rendered

  parameters = data.template_file.inherit_tag_params.rendered

  policy_rule = data.template_file.inherit_tag_policy_rule.rendered
}

// Combine individual policies into tagging initiative
resource "azurerm_policy_set_definition" "tagging-policy" {
  name         = "tagging-policy"
  policy_type  = "Custom"
  display_name = "Tagging policy"


  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require-tag-entity-on-rg.id
    reference_id         = "require-entity"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require-tag-costcenter-on-rg.id
    reference_id         = "require-costcenter"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.inherit-tag.id
    reference_id         = "inherit-entity"
    parameter_values     = data.template_file.inherit_entity_tag_params.rendered
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.inherit-tag.id
    reference_id         = "inherit-costcenter"
    parameter_values     = data.template_file.inherit_costcenter_tag_params.rendered
  }

}
