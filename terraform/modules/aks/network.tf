resource "azurerm_virtual_network" "aks_demo" {
  name                = "aks-demo-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name
}

resource "azurerm_subnet" "aks_demo_nodes" {
  name                 = "aks-demo-subnet-node"
  resource_group_name  = var.azurerm_resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_demo.name
  address_prefixes     = ["10.122.0.0/16"]
}

resource "azurerm_subnet" "aks_demo_pods" {
  name                 = "aks-demo-subnet-pods"
  resource_group_name  = var.azurerm_resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_demo.name
  address_prefixes     = ["10.244.0.0/16"]

  # Generated post-apply, added for keeping state in-sync
  delegation {
    name = "aks-delegation"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}
