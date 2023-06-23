# Large-size infrastructure using Terraform



## Features

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