resource "azapi_resource" "container_app_job" {
  type      = "Microsoft.App/jobs@2023-04-01-preview"
  name      = var.settings.name #2-32 Lowercase letters, numbers, and hyphens. Start with letter and end with alphanumeric.
  location  = azurerm_resource_group.rg_runners_aca_jobs.location
  parent_id = azurerm_resource_group.rg_runners_aca_jobs.id
  tags      = {}

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai_runners_aca_jobs.id]
  }

  # Need to set to false because at the moment only 2022-11-01-preview is supported
  schema_validation_enabled = false
  ignore_missing_property = true
  ignore_casing = true

  body = jsonencode({
    properties = {
      environmentId       = azapi_resource.acae_runners_jobs.id
      workloadProfileName = var.settings.workload_profile_name
      configuration = {
        secrets = [
          {
            name  = var.gh_pat_secret_name
            value = var.gh_pat_value
          }
        ]
        triggerType           = "Event"
        replicaTimeout        = var.settings.replica_timeout
        replicaRetryLimit     = var.settings.replica_retry_limit
        manualTriggerConfig   = null
        scheduleTriggerConfig = null
        registries            = null
        dapr                  = null
        eventTriggerConfig = {
          replicaCompletionCount = null
          parallelism            = var.settings.parallelism
          scale = {
            minExecutions   = var.settings.scale_min_executions
            maxExecutions   = var.settings.scale_max_executions
            pollingInterval = var.settings.scale_polling_interval
            rules           = var.settings.rules
          }
        }
      }
      template = {
        containers = [
          {
            image   = var.settings.image
            name    = "ghrunnersacajobs"
            command = null
            args    = null
            env     = var.settings.env
            resources = {
              cpu    = var.settings.cpu
              memory = var.settings.memory
            }
            volumeMounts = null
          }
        ]
        initContainers = null
        volumes        = null
      }
    }
  })
}