/* output "resource_group_name_1" {
  #value = { for k, v in module.resource_group: k => v}
  value = "${lookup(tomap({ for k, v in module.resource_group: k => v}), var.resource_group_names["rg1"])}"
}
output "resource_group_name_2" {
  #value = { for k, v in module.resource_group: k => v}
  value = "${lookup(tomap({ for k, v in module.resource_group: k => v}), var.resource_group_names["rg2"])}"
} */