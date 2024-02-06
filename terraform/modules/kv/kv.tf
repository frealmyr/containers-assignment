data "azuread_client_config" "current" {}

resource "random_pet" "suffix" {
  length = 1
}

resource "azurerm_key_vault" "aks_demo" {
  name                        = "aks-demo-${random_pet.suffix.id}"
  location                    = var.azurerm_resource_group_location
  resource_group_name         = var.azurerm_resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azuread_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "aks_demo_accessor" {
  key_vault_id = azurerm_key_vault.aks_demo.id

  tenant_id = data.azuread_client_config.current.tenant_id
  object_id = var.vault_secrets_provider_identity

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]
}
