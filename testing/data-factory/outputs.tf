output "resource_group_name" {
  value = module.resource_group.resource_group_name
}
output "data_factory_id" {
  value = module.data_factory.data_factory_id
}

output "github_data_factory_id" {
  value = module.data_factory.github_data_factory_id
}

output "vsts_data_factory_id" {
  value = module.data_factory.vsts_data_factory_id
}

