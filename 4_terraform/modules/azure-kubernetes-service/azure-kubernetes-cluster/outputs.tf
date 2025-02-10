output "azurerm_kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.k8s.id
}

output "azurerm_kubernetes_cluster_outbound_public_ip" {
  value = data.azurerm_public_ip.outbound_cluster_ip.ip_address
}

output "azurerm_kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "azurerm_kubernetes_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.k8s.fqdn
}

output "azurerm_kubernetes_cluster_private_fqdn" {
  value = azurerm_kubernetes_cluster.k8s.private_fqdn
}

output "azurerm_kubernetes_cluster_node_resource_group_name" {
  value = azurerm_kubernetes_cluster.k8s.node_resource_group
}

output "azurerm_kubernetes_cluster_kube_config" {
  sensitive = true
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}

output "azurerm_kubernetes_cluster_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
}