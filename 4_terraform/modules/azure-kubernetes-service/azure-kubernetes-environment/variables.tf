variable "INFRASTRUCTURE_NAME" {
  type        = string
  description = "The name for the resources."
}

variable "PREFIX" {
  type        = string
  description = "The prefix for the resources name."
}

variable "SUFFIX" {
  type        = string
  description = "The suffix for the resources name."
}

variable "LOCATION" {
  type        = string
  description = "The location for the deployment"
}

variable "azurerm_k8s_vnet_address_space" {
  type        = list(string)
  description = "Address space for core k8s infrastructure."
}

variable "azurerm_k8s_service_vnet_address_space" {
  type        = list(string)
  description = "Address space for core service infrastructure."
}

variable "azurerm_k8s_cluster_index" {
  type = string
  description = "Index of AKS cluster."
}

variable "azurerm_k8s_resource_group_name" {
  type = string
  description = "Name of Azure Resource group for AKS."
}

variable "azurerm_k8s_resource_group_id" {
  type = string
  description = "ID of Azure Resource group for AKS."
}

variable "azurerm_core_storage_account_id" {
  type = string
  description = "ID of Azure Storage Account for AKS."
}

variable "azurerm_core_key_vault_id" {
  type = string
  description = "ID of Azure Key Vault for AKS."
}

variable "azurerm_k8s_cluster_version" {
  type = string
  description = "The version of k8s cluster."
}

variable "azurerm_k8s_private_cluster_enabled" {
  type = bool
  description = "Is AKS private cluster enabled."
}

variable "azurerm_k8s_private_cluster_admin_username" {
  type = string
  description = "Username for AKS cluster node instance."
}

variable "azurerm_k8s_cluster_default_node_pool" {
  description = "The k8s default node pool configuration data."
}

variable "azurerm_k8s_cluster_additional_node_pool" {
  description = "The k8s additional node pools configuration data."
  default     = null
}

variable "azurerm_k8s_private_cluster_network_profile" {
  type = map(string)
  description = "The k8s network profile configuration data."
}

variable "azurerm_k8s_cluster_nginx_ingress_access_mode" {
  type = string
  description = ""
}

variable "azurerm_k8s_cluster_nginx_ingress_fqdn" {
  type = string
  description = ""
}

variable "azurerm_k8s_cluster_nginx_ingress_pls_enabled" {
  type = string
  description = ""
}

variable "azurerm_k8s_cluster_nginx_ingress_public_dns_creation_mode" {
  type = string
  description = ""
}

variable "azurerm_k8s_ingress_public_ip" {
  type = string
  description = ""
}

variable "azurerm_k8s_ingress_public_ip_resource_group_id" {
  type = string
  description = ""
}

variable "azurerm_k8s_cluster_nginx_ingress_whitelist" {
  type = any
  description = ""
}

variable "azurerm_k8s_cluster_sku_tier" {
    type = string
    description = "The SKU Tier that should be used for Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)."
}

variable "azurerm_k8s_cluster_azure_policy_enabled" {
    type = string
    description = "Should the Azure Policy Add-On be enabled?"
}

variable "azurerm_k8s_cluster_local_account_disabled" {
    type = string
    description = "Should the local accounts will be disabled."
}

variable "azurerm_k8s_cluster_role_based_access_control_enabled" {
    type = string
    description = "Whether Role Based Access Control for the Kubernetes Cluster should be enabled."
}

variable "azurerm_k8s_cluster_admin_group_object_ids" {
    type = list(string)
    description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
}

variable "azurerm_k8s_cluster_azure_rbac_enabled" {
    type = string
    description = "Is Role Based Access Control based on Azure AD enabled?"
}

variable "azurerm_k8s_service_oidc_issuer_enabled" {
    type = string
    description = "Is OIDC issuer enabled?"
}

variable "azurerm_k8s_service_workload_identity_enabled" {
    type = string
    description = "Is workload identity enabled?"
}

variable "azurerm_k8s_egress_allowed_destinations" {
    type = list(string)
}

variable "common_tags" {
  type = map(string)
  description = "Common for Azure Cloud resources."
}

variable "azurerm_k8s_cluster_availability_zones" {
  type        = list(string)
  description = "Availability zones for core service infrastructure."
  default = []
}
variable "additional_key_vault_secrets" {
  type        = list(map(string))
  description = "Additional secrets to add to Azure Key Vault."
  default     = []
}

variable "azurerm_nsg_rules" {
  type        = list(any)
  description = "List of Azure NSG rules."
  default     = []
}

variable "azurerm_k8s_cluster_auto_scaler_profile" {
  type = map(any)
}