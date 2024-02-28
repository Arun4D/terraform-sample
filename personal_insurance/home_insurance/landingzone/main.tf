module "management_group" {
  source = "../modules/management_group"
  mgmt_grp_config = local.mng_grp_config
}

