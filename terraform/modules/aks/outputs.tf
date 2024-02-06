output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks_demo.name
}

output "vault_secrets_provider_client_id" {
  value = azurerm_kubernetes_cluster.aks_demo.key_vault_secrets_provider[0].secret_identity[0].client_id
}
