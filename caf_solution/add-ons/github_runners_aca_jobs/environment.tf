resource "azapi_resource" "acae_runners_jobs" {
  type      = "Microsoft.App/managedEnvironments@2023-04-01-preview"
  name      = var.aca_environment_name
  parent_id = azurerm_resource_group.rg_runners_aca_jobs.id
  location  = azurerm_resource_group.rg_runners_aca_jobs.location

  schema_validation_enabled = false
  ignore_missing_property = true
  ignore_casing = true

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.la_runners_aca_jobs.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.la_runners_aca_jobs.primary_shared_key
        }
      }
      vnetConfiguration = {
        dockerBridgeCidr       = null
        infrastructureSubnetId = azurerm_subnet.subnet_runners_aca_jobs.id
        internal               = true
        platformReservedCidr   = null
        platformReservedDnsIP  = null
      }
      workloadProfiles = var.aca_workload_profiles
    }
  })
}