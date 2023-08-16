
module "container_app_environments" {
  source     = "./container_app_environment"
  for_each   = local.compute.container_app_environments

  location                            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name                 = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  resource_group_id                   = can(each.value.resource_group.id) || can(each.value.resource_group_id) ? try(each.value.resource_group.id, each.value.resource_group_id) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].id
  base_tags                           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  client_config                       = local.client_config
  combined_diagnostics                = local.combined_diagnostics
  diagnostic_profiles                 = try(each.value.diagnostic_profiles, {})
  global_settings                     = local.global_settings
  settings                            = each.value
  dynamic_keyvault_secrets            = try(local.security.dynamic_keyvault_secrets, {})

  combined_resources = {
    resource_groups      = local.combined_objects_resource_groups
    managed_identities   = local.combined_objects_managed_identities
    vnets                = local.combined_objects_networking
  }
}

output "container_apps" {
  value = module.container_app_environments
}


# module "container_apps" {
#   source     = "./container_app"
#   for_each   = local.compute.container_apps

#   location                 = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
#   resource_group_name      = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
#   base_tags                = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
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