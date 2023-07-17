data "template_file" "allowed_storage_sku_policy_rule" {
  template = <<POLICY_RULE
 {
    "if": {
      "allOf": [ 
        { 
          "field": "type", 
          "equals": "Microsoft.Storage/storageAccounts" 
        }, 
        { 
          "not": { 
            "field": "Microsoft.Storage/storageAccounts/sku.name", 
            "in": "[ parameters('allowedStorageSku') ]"
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
data "template_file" "allowed_storage_sku_policy_rule_params" {
  template = <<PARAMETERS
 {
    "allowedStorageSku": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed Storage sku's.",
        "displayName": "Allowed VM SKU",
        "strongType": "Microsoft.Storage/storageAccounts/sku.name"
      }
    }
  }
PARAMETERS
}

data "template_file" "allowed_storage_sku_policy_rule_meta" {
  template = <<METADATA
    {
    "category": "General"
    }

METADATA

}

data "template_file" "allowed_storage_sku_policy_rule_params_value" {
  template = <<VALUE
    {
      "listOfallowedStorageSku": {"value": "[parameters('allowedStorageSku')]"}
    }
    VALUE

}

resource "azurerm_policy_definition" "allowed_storage_sku_policy_def" {
  name         = "${var.env}-allowed_storage_sku_policy_def"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Storage SKU policy definition"

  metadata = data.template_file.allowed_storage_sku_policy_rule_meta.rendered

  policy_rule = data.template_file.allowed_storage_sku_policy_rule.rendered


  parameters = data.template_file.allowed_storage_sku_policy_rule_params.rendered

}