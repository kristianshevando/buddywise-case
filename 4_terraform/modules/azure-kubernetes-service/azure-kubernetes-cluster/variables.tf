variable "azurerm_kubernetes_cluster_name" {
    description = "The name of AKS cluster."
    type = string
}

variable "location" {
    description = "The region of Key Vault."
    type = string
}

variable "azurerm_kubernetes_cluster_resource_group_name" {
    description = "Azure Resource Group where the Managed Kubernetes Cluster should exist."
    type = string
}

variable "azurerm_kubernetes_cluster_version" {
    description = "Version of AKS."
    type = string
}

variable "azurerm_kubernetes_cluster_node_resource_group" {
    description = "he name of the Resource Group where the Kubernetes Nodes should exist."
    type = string
}

variable "azurerm_kubernetes_private_cluster_enabled" {
    description = "Should this AKS have its API server only exposed on internal IP addresses?"
    type = bool
}

variable "azurerm_kubernetes_cluster_default_node_pool" {
    description = "AKS default node pool configuration data."
}

variable "azurerm_kubernetes_cluster_network_profile" {
    description = "AKS network_profile configuration data."
}

variable "azurerm_user_assigned_identity_ids" {
    description = "The ID of a user assigned identity."
    type = list(string)
}

variable "azurerm_kubelet_user_assigned_identity_client_id" {
    description = "The Client ID of the user-defined Managed Identity to be assigned to the Kubelets."
    type = string
}

variable "azurerm_kubelet_user_assigned_identity_object_id" {
    description = "The Object ID of the user-defined Managed Identity assigned to the Kubelets."
    type = string
}

variable "azurerm_kubelet_user_assigned_identity_id" {
    description = "The ID of the User Assigned Identity assigned to the Kubelets."
    type = string
}

variable "azurerm_kubernetes_cluster_default_node_pool_vnet_subnet_id" {
    description = "The Azure network subnet id for default node pool."
    type = string
}

variable "azurerm_kubernetes_cluster_admin_username" {
    description = "The Admin Username for the Cluster."
    type = string
}

variable "common_tags" {
  type        = map(string)
  description = "Default set of tags."
  default     = null
}

variable "azurerm_kubernetes_cluster_auto_scaler_profile" {
  type        = map(any)
}

variable "azurerm_key_vault_id" {
    type = string
    description = "Azure Key Vault ID to store sensitive and configuration data."
}

variable "azurerm_kubernetes_cluster_sku_tier" {
    type = string
    description = "The SKU Tier that should be used for Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)."
}

variable "azurerm_kubernetes_cluster_azure_policy_enabled" {
    type = string
    description = "Should the Azure Policy Add-On be enabled?"
}

variable "azurerm_kubernetes_cluster_local_account_disabled" {
    type = string
    description = "Should the local accounts will be disabled."
}

variable "azurerm_kubernetes_cluster_role_based_access_control_enabled" {
    type = string
    description = "Whether Role Based Access Control for the Kubernetes Cluster should be enabled."
}

variable "azurerm_kubernetes_cluster_admin_group_object_ids" {
    type = list(string)
    description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
}

variable "azurerm_kubernetes_cluster_azure_rbac_enabled" {
    type = string
    description = "Is Role Based Access Control based on Azure AD enabled?"
}

variable "azurerm_kubernetes_cluster_oidc_issuer_enabled" {
    type = string
    description = "Is OIDC issuer enabled?"
}

variable "azurerm_kubernetes_cluster_workload_identity_enabled" {
    type = string
    description = "Is workload identity enabled?"
}

variable "azurerm_kubernetes_cluster_windows_node_pool" {
    description = "Are there Windows node pool in AKS?"
    type = bool
}

variable "azurerm_kubernetes_cluster_availability_zones" {
    description = "Availability zones for k8s infrastructure."
    type = list(string)
    default = []
}