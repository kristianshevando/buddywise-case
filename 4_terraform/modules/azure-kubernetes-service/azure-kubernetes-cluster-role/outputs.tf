output "azurerm_kubernetes_cluster_role_name" {
  value = kubernetes_cluster_role.cluster_role.metadata[0].name
}