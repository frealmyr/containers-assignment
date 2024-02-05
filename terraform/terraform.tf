terraform {
  required_version = ">=1.7"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "aks_demo" {
  name                = module.aks.cluster_name
  resource_group_name = azurerm_resource_group.aks_demo.name
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks_demo.kube_admin_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_demo.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_demo.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_demo.kube_admin_config.0.cluster_ca_certificate)
  }
}
