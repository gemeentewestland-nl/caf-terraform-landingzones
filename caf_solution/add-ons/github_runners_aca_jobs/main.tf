terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.40.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = ">= 1.5.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.7.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 5.7.2"
    }
  }
  required_version = ">= 1.3.7"
}

data "azurerm_client_config" "current" {}

locals {

  # Update the tfstates map
  tfstates = merge(
    tomap(
      {
        (var.landingzone.key) = local.backend[var.landingzone.backend_type]
      }
    )
    ,
    data.terraform_remote_state.remote[var.landingzone.global_settings_key].outputs.tfstates
  )


  backend = {
    azurerm = {
      storage_account_name = var.tfstate_storage_account_name
      container_name       = var.tfstate_container_name
      resource_group_name  = var.tfstate_resource_group_name
      key                  = var.tfstate_key
      level                = var.landingzone.level
      tenant_id            = var.tenant_id
      subscription_id      = data.azurerm_client_config.current.subscription_id
    }
  }

}