output "azurerm_core_virtual_network" {
  value = {
    resource_group_name      = var.azurerm_k8s_resource_group_name
    virtual_network_name     = module.azure_core_virtual_network.azurerm_virtual_network_name
    virtual_network_id       = module.azure_core_virtual_network.azurerm_virtual_network_id
    virtual_network_location = var.LOCATION
    kubernetes_cluster_index = var.azurerm_k8s_cluster_index
  }
}

output "azurerm_kubernetes_cluster" {
  value = {
    resource_group_name         = var.azurerm_k8s_resource_group_name
    kubernetes_cluster_name     = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_name
    kubernetes_cluster_location = var.LOCATION
    kubernetes_cluster_index    = var.azurerm_k8s_cluster_index
  }
}

output "azurerm_core_virtual_network_address_space" {
  value = module.azure_core_virtual_network.azurerm_virtual_network_address_space
}

output "azurerm_core_virtual_network_subnets" {
  value = flatten([ module.azure_k8s_network_node_subnet.azure_subnet_output, module.azure_k8s_network_pod_subnet.azure_subnet_output, module.azure_private_link_network_subnet.azure_subnet_output ])
}

output "azurerm_ingress_virtual_network_subnet" {
  value = var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-s2s" || var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-afd" ? module.azure_k8s_ingress_network_subnet[*].azurerm_subnet_address_prefixes : []
}

output "azurerm_kubernetes_cluster_node_resource_group_name" {
  value = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_node_resource_group_name
}

output "azurerm_kubernetes_cluster_id" {
  value = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_id
}

output "azurerm_kubernetes_cluster_outbound_public_ip" {
  value = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_outbound_public_ip
}

output "azurerm_kubernetes_cluster_fqdn" {
  value = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_fqdn
}

output "azurerm_kubernetes_cluster_private_fqdn" {
  value = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_private_fqdn
}

output "azurerm_user_assigned_identity_k8s_principal_id" {
  value = module.azurerm_user_assigned_identity_k8s.azurerm_user_assigned_identity_principal_id
}

output "azurerm_user_assigned_identity_k8s_kubelet_principal_id" {
  value = module.azurerm_user_assigned_identity_k8s_kubelet.azurerm_user_assigned_identity_principal_id
}

output "azurerm_kubernetes_cluster_oidc_issuer_url" {
  value = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_oidc_issuer_url
}

output "azurerm_kubernetes_cluster_kube_config" {
  sensitive = true
  value = [
    for kubernetes_cluster_name, kube_config in zipmap(
      [ module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_name ],
      [ module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_kube_config ]) :
      tomap({ "kubernetes_cluster_name" = kubernetes_cluster_name, "kube_config" = kube_config})
  ]
}

output "azurerm_user_assigned_identity_k8s_egress_controller_resource_id" {
  value = try(sort(flatten([var.azurerm_k8s_egress_allowed_destinations])), false) != false && length(flatten([var.azurerm_k8s_egress_allowed_destinations])) > 0 ? module.azurerm_user_assigned_identity_k8s_egress_controller[0].azurerm_user_assigned_identity_id : null
}

output "azurerm_user_assigned_identity_k8s_egress_controller_client_id" {
  value = try(sort(flatten([var.azurerm_k8s_egress_allowed_destinations])), false) != false && length(flatten([var.azurerm_k8s_egress_allowed_destinations])) > 0 ? module.azurerm_user_assigned_identity_k8s_egress_controller[0].azurerm_user_assigned_identity_client_id : null
}