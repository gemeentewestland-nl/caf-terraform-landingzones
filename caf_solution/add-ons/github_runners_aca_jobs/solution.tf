module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = ">=5.7.2"

  providers = {
    azurerm.vhub = azurerm.vhub
  }

  current_landingzone_key               = var.landingzone.key
  tenant_id                             = var.tenant_id
  tfstates                              = local.tfstates
  tags                                  = local.tags
  global_settings                       = local.global_settings
  diagnostics                           = local.diagnostics
  logged_user_objectId                  = var.logged_user_objectId
  resource_groups                       = var.resource_groups

  remote_objects = {
    keyvaults          = local.remote.keyvaults
    vnets              = local.remote.vnets
    managed_identities = local.remote.managed_identities
    azuread_groups     = local.remote.azuread_groups
  }
}
