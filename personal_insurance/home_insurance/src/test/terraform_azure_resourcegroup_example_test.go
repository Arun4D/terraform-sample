//go:build azure
// +build azure

// NOTE: We use build tags to differentiate azure testing because we currently do not have azure access setup for
// CircleCI.

package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureResourceGroupExample(t *testing.T) {
	t.Parallel()

	// Installl the provider.tf with defered deletion
	terraformCodeDir := "../../modules/resource_group"

	defer os.Remove(terraformCodeDir + "test-provider.tf")
	files.CopyFile("../../prod/providers.tf", terraformCodeDir+"/test-provider.tf")

	// subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID"
	subscriptionID := "fe03bde0-15db-4f68-ac6f-f23934db804f"
	uniquePostfix := random.UniqueId()
	location := "eastus"

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: terraformCodeDir,
		Upgrade:      true,
		Vars: map[string]interface{}{
			"resource_group_name_prefix": uniquePostfix,
			"resource_group_location":    location,
		},
	}

	// website::tag::4:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")

	// website::tag::4:: Verify the resource group exists
	exists := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)
	assert.True(t, exists, "Resource group does not exist")
}
