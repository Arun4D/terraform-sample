# Terraform - Home Insurance Sub-Business unit

## Testing

1. Setup go

````go
go mod init home_insurance
````
2. Go get dependencies 

````go
go get github.com/gruntwork-io/terratest/modules/azure github.com/gruntwork-io/terratest/modules/random github.com/gruntwork-io/terratest/modules/terraform github.com/stretchr/testify/assert github.com/gruntwork-io/terratest/modules/files
````

3. Go mod cache (Optional)

````go
go clean -modcache
````

4. Go test 

````go
go test ./src/test/terraform_azure_resourcegroup_example_test.go
````