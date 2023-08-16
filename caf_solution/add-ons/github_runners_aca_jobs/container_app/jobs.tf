resource "azapi_resource" "acaj_runners_jobs" {
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
      workloadProfileName = var.job_workload_profile_name
      configuration = {
        secrets = [
          {
            name  = var.gh_pat_secret_name
            value = var.gh_pat_value
          }
        ]
        triggerType           = "Event"
        replicaTimeout        = var.job_replica_timeout
        replicaRetryLimit     = var.job_replica_retry_limit
        manualTriggerConfig   = null
        scheduleTriggerConfig = null
        registries            = null
        dapr                  = null
        eventTriggerConfig = {
          replicaCompletionCount = null
          parallelism            = var.job_parallelism
          scale = {
            minExecutions   = var.job_scale_min_executions
            maxExecutions   = var.job_scale_max_executions
            pollingInterval = var.job_scale_polling_interval
            rules = [
              {
                name = "github-runner"
                type = "github-runner"
                metadata = {
                  owner       = var.gh_owner
                  repos       = var.gh_repository
                  runnerScope = var.gh_scope
                }
                auth = [
                  {
                    secretRef        = var.gh_pat_secret_name
                    triggerParameter = "personalAccessToken"
                  }
                ]
              }
            ]
          }
        }
      }
      template = {
        containers = [
          {
            image   = var.job_image
            name    = "ghrunnersacajobs"
            command = null
            args    = null
            env     = var.env_variables
            resources = {
              cpu    = var.job_cpu
              memory = var.job_memory
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