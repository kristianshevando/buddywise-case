output "azurerm_core_key_vault_name" {
  value = values(module.azure_core_key_vault)[*].azurerm_key_vault_name
}

output "azurerm_core_virtual_network_address_space" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_core_virtual_network_address_space)
}

output "azurerm_core_virtual_network_subnets_address_space" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_core_virtual_network_subnets)
}

output "azurerm_kubernetes_cluster_node_resource_group_name" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_kubernetes_cluster_node_resource_group_name)
}

output "azurerm_user_assigned_identity_k8s_principal_id" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_user_assigned_identity_k8s_principal_id)
}

output "azurerm_user_assigned_identity_k8s_kubelet_principal_id" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_user_assigned_identity_k8s_kubelet_principal_id)
}

output "azurerm_kubernetes_cluster_helm_charts" {
  value = flatten(var.azurerm_k8s_clusters.*.azure_k8s_helm_charts)
  sensitive = true
}

output "azurerm_kubernetes_cluster_fqdn" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_kubernetes_cluster_fqdn)
}

output "azurerm_kubernetes_cluster_private_fqdn" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_kubernetes_cluster_private_fqdn)
}

output "azure_k8s_cluster_nginx_ingress_subnets" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_ingress_virtual_network_subnet)
}

output "azurerm_kubernetes_cluster_oidc_issuer_url" {
  value = {for k, v in module.azure_k8s_environment: k => v.azurerm_kubernetes_cluster_oidc_issuer_url}
}

output "azurerm_core_virtual_network" {
  value = values(module.azure_k8s_environment)[*].azurerm_core_virtual_network
}

output "azurerm_core_storage_account_id" {
  value = {for k, v in module.azure_core_storage_account: k => v.storage_account_id}
}

output "azurerm_core_key_vault_id" {
  value = {for k, v in module.azure_core_key_vault: k => v.azurerm_key_vault_id}
}

output "azurerm_kubernetes_cluster_indexes" {
  value = var.azurerm_k8s_clusters.*.azure_k8s_cluster_index
}

output "azure_vault_sa_backup_enabled" {
  value = { for cluster in var.azurerm_k8s_clusters: cluster.azure_k8s_cluster_index => cluster.azure_vault_sa_backup_enabled }
}

output "azurerm_core_key_vault_uri_index" {
  value = {for k, v in module.azure_core_key_vault: k => v.azurerm_key_vault_uri}
}

output "azurerm_core_resource_group_name_index" {
  value = {for k, v in module.azure_core_resource_group: k => v.resource_group_name}
}

output "azurerm_kubernetes_cluster_index_id" {
  value = {for k, v in module.azure_k8s_environment: k => v.azurerm_kubernetes_cluster_id}
}

output "azurerm_kubernetes_cluster_outbound_public_ip" {
  value = {for k, v in module.azure_k8s_environment: k => v.azurerm_kubernetes_cluster_outbound_public_ip}
}

output "azurerm_core_resource_group_name" {
  value = values(module.azure_core_resource_group)[*].resource_group_name
}

output "azurerm_core_resource_group_id" {
  value = values(module.azure_core_resource_group)[*].resource_group_id
}

output "azurerm_core_storage_account_name_index" {
  value = {for k, v in module.azure_core_storage_account: k => v.storage_account_name}
}

output "azurerm_core_key_vault_name_index" {
  value = {for k, v in module.azure_core_key_vault: k => v.azurerm_key_vault_name}
}

output "azurerm_core_storage_account_name" {
  value = values(module.azure_core_storage_account)[*].storage_account_name
}

output "azurerm_k8s_clusters" {
  value = flatten(values(module.azure_k8s_environment)[*].azurerm_kubernetes_cluster)
}

output "azurerm_user_assigned_identity_k8s_egress_controller_resource_id" {
  value = {for k, v in module.azure_k8s_environment: k => v.azurerm_user_assigned_identity_k8s_egress_controller_resource_id}
}

output "azurerm_user_assigned_identity_k8s_egress_controller_client_id" {
  value = {for k, v in module.azure_k8s_environment: k => v.azurerm_user_assigned_identity_k8s_egress_controller_client_id}
}