
module "container_app_environments" {
  depends_on = [module.caf]
  source     = "./container_app_environment"
  for_each   = var.container_apps

  name                                = each.value.name
  location                            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined.resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_id                   = can(each.value.resource_group.id) || can(each.value.resource_group_id) ? try(each.value.resource_group.id, each.value.resource_group_id) : local.combined.resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group_key, each.value.resource_group.key)].id
  base_tags                           = try(local.global_settings.inherit_tags, false) ? try(local.remote.resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  log_analytics_workspace_id          = can(each.value.log_analytics_workspace.id) ? try(local.diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.remote.diagnostics[try(each.value.log_analytics_workspace.lz_key, var.landingzone.key)].log_analytics[each.value.log_analytics_workspace.key].id
  log_analytics_primary_shared_key    = can(each.value.log_analytics_workspace.primary_shared_key) ? try(local.diagnostics.log_analytics[each.value.diagnostic_log_analytics_workspace.key].id, each.value.log_analytics_workspace.id) : local.remote.diagnostics[try(each.value.log_analytics_workspace.lz_key, var.landingzone.key)].log_analytics[each.value.log_analytics_workspace.key].primary_shared_key
  subnet_id                           = can(each.value.subnet_id) || can(each.value.subnet) == false ? try(each.value.subnet_id, null) : try(local.remote.vnets[try(each.value.subnet.lz_key, var.landingzone.key)][each.value.subnet.vnet_key].subnets[each.value.subnet.key].id)
  global_settings                     = local.global_settings
  settings                            = each.value

}

output "container_apps" {
  value = module.container_app_environments
}


# module "container_apps" {
#   source     = "./container_app"
#   for_each   = local.compute.container_apps

#   location                 = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
#   resource_group_name      = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
#   base_tags                = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, var.landingzone.key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
#   client_config            = local.client_config
#   combined_diagnostics     = local.combined_diagnostics
#   diagnostic_profiles      = try(each.value.diagnostic_profiles, {})
#   global_settings          = local.global_settings
#   settings                 = each.value
#   dynamic_keyvault_secrets = try(local.security.dynamic_keyvault_secrets, {})

#   combined_resources = {
#     keyvaults          = local.combined_objects_keyvaults
#     managed_identities = local.combined_objects_managed_identities
#     network_profiles   = local.combined_objects_network_profiles
#   }
# }

# output "container_apps" {
#   value = module.container_apps
# }