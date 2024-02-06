resource "azurerm_resource_group" "aks_demo" {
  name     = "aks-demo"
  location = "eastus" # TODO: turn into variable
}

module "ad" {
  source = "./modules/ad"
}

module "aks" {
  source = "./modules/aks"

  azurerm_resource_group_name     = azurerm_resource_group.aks_demo.name
  azurerm_resource_group_location = azurerm_resource_group.aks_demo.location

  # Pass superusers group ID to AKS cluster
  azuread_group_superusers = module.ad.azuread_group_superusers
}

module "key_vault" {
  source = "./modules/kv"

  azurerm_resource_group_name     = azurerm_resource_group.aks_demo.name
  azurerm_resource_group_location = azurerm_resource_group.aks_demo.location

  vault_secrets_provider_identity = module.aks.vault_secrets_provider_client_id
}

module "argocd" {
  source = "./modules/argocd"
}
