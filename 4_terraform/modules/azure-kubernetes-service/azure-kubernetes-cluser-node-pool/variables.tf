variable "azurerm_kubernetes_cluster_id" {
    description = "AKS cluster resource ID"
    type = string
}

variable "azurerm_kubernetes_cluster_node_pool_vnet_subnet_id" {
    description = "The Azure network subnet id for default node pool."
    type = string
}

variable "common_tags" {
  type        = map(string)
  description = "Default set of tags."
  default     = null
}

variable "azurerm_kubernetes_cluster_additional_node_pool" {
    description = "AKS additional node pool configuration data."
}

variable "azurerm_kubernetes_cluster_availability_zones" {
    description = "Availability zones for k8s infrastructure."
    type = list(string)
    default = []
}