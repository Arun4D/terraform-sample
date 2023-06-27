# Large-size infrastructure using Terraform

## Format Terraform code

````bash
cd home_insurance
./script/terraform-fmt.sh
````

## Scan  Terraform code for Violation 

````bash
terrascan scan -t azure -i terraform
````


## Terraform run steps

1. Initialize Terraform

````bash
terraform init -upgrade
````

2. Create a Terraform execution plan

````bash
terraform plan -out main.tfplan
````
3. Apply a Terraform execution plan

````bash
terraform apply main.tfplan
````
4. Verify the results

````bash
az group show --name <resource_group_name>
````

5. Clean up resources

````bash
terraform plan -destroy -out main.destroy.tfplan
````

6. Apply a Terraform execution plan to destroy

````bash
terraform apply main.destroy.tfplan
````