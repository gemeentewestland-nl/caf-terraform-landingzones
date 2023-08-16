
resource "azapi_resource" "acae_runners_jobs" {
  type      = "Microsoft.App/managedEnvironments@2023-04-01-preview"
  name      = "ace-${var.settings.name}"
  parent_id = var.resource_group_id
  location  = var.location

  schema_validation_enabled = false
  ignore_missing_property = true
  ignore_casing = true

  body = jsonencode({
    properties = {
      appLogsConfiguration = {  
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = can(each.value.workspace_id) ? each.value.workspace_id : try(local.combined_objects_log_analytics[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.workspace_key].id, local.combined_diagnostics.log_analytics[each.value.workspace_key].id)
          sharedKey  = can(each.value.workspace_id) ? each.value.workspace_id : try(local.combined_objects_log_analytics[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.workspace_key].id, local.combined_diagnostics.log_analytics[each.value.workspace_key].primary_shared_key)
        }
      }
      vnetConfiguration = {
        dockerBridgeCidr       = null
        infrastructureSubnetId = azurerm_subnet.subnet_runners_aca_jobs.id
        internal               = true
        platformReservedCidr   = null
        platformReservedDnsIP  = null
      }
      workloadProfiles = var.settings.workload_profiles
    }
  })
}