locals {
  allowedExtensions = ["microsoft.azure.monitoring.dependencyagent.dependencyagentlinux"
    , "microsoft.azure.monitoring.dependencyagent.dependencyagentwindows"
    , "microsoft.azure.security.azurediskencryptionforlinux"
    , "microsoft.azure.security.azurediskencryption"
    , "microsoft.compute.customscriptextension"
    , "microsoft.ostcextensions.customscriptforlinux"
    , "microsoft.powershell.dsc"
    , "microsoft.hpccompute.nvidiagpudriverlinux"
    , "microsoft.hpccompute.nvidiagpudriverwindows"
    , "microsoft.azure.security.iaasantimalware"
    , "microsoft.enterprisecloud.monitoring.omsagentforlinux"
    , "microsoft.enterprisecloud.monitoring.microsoftmonitoringagent"
    , "stackify.linuxagent.extension.stackifylinuxagentextension"
    , "vmaccessforlinux.microsoft.ostcextensions"
    , "microsoft.recoveryservices.vmsnapshot"
    , "microsoft.recoveryservices.vmsnapshot"
  ]

  notAllowedExtensions = [for ext in toset(var.vm_extensions) : ext if contains(local.allowedExtensions, ext)]
}

resource "azurerm_resource_group_policy_assignment" "allowed_not_allowed_vm_ext_policy_assign" {

  name                 = "${var.env}_allowed_not_allowed_vm_ext_policy_assign"
  resource_group_id    = var.resource_group_id
  policy_definition_id = var.policy_definition_id

  parameters = jsonencode({
    "notAllowedExtensions" : { "value" : local.notAllowedExtensions }
  })
}

