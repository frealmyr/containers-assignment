data "azuread_client_config" "current" {}

resource "azuread_group" "aks_demo_superusers" {
  display_name     = "Gods"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    data.azuread_client_config.current.object_id,
  ]
}
