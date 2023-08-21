module "container_app_jobs" {
  source     = "./container_app_job"
  for_each   = var.container_app_jobs

  name                                = each.value.name
  container_app_environment_id        = can(each.value.container_app_environment_id) ? each.value.container_app_environment_id : module.container_app_environments[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.container_app_environment_key].id
  location                            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined.resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_id                   = can(each.value.resource_group.id) || can(each.value.resource_group_id) ? try(each.value.resource_group.id, each.value.resource_group_id) : local.combined.resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group_key, each.value.resource_group.key)].id
  base_tags                           = try(local.global_settings.inherit_tags, false) ? try(local.remote.resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}

  settings                            = each.value
}

output "container_app_jobs" {
  value = module.container_app_jobs
}