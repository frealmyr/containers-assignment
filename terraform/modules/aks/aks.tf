resource "azurerm_kubernetes_cluster" "aks_demo" {
  name       = "aks-demo"
  dns_prefix = "demo"

  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  sku_tier = "Free"

  default_node_pool {
    name           = "default"
    node_count     = 2
    zones          = [1, 2]         # dual-zone cluster for HA
    vm_size        = "Standard_B2s" # 2vCPU, 4GB RAM, 8GB SSD
    vnet_subnet_id = azurerm_subnet.aks_demo_nodes.id
    pod_subnet_id  = azurerm_subnet.aks_demo_pods.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin  = "azure"
    ebpf_data_plane = "cilium"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [var.azuread_group_superusers]
  }
}
