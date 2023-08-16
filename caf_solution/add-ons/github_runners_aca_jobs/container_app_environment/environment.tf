
resource "azapi_resource" "acae_runners_jobs" {
  type      = "Microsoft.App/managedEnvironments@2023-04-01-preview"
  name      = "ace-${var.settings.name}"
  parent_id = var.resource_group_id
  location  = var.location
  tags      = local.tags

  schema_validation_enabled = false
  ignore_missing_property = true
  ignore_casing = true

  body = jsonencode({
    properties = {
      appLogsConfiguration = {  
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = var.log_analytics_workspace_id
          sharedKey  = var.log_analytics_workspace_id
        }
      }
      vnetConfiguration = {
        dockerBridgeCidr       = null
        infrastructureSubnetId = ""
        internal               = true
        platformReservedCidr   = null
        platformReservedDnsIP  = null
      }
      workloadProfiles = var.settings.workload_profiles
    }
  })
}