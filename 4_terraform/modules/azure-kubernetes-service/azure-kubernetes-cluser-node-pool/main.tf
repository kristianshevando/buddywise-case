resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  name                  = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "name")
  enable_auto_scaling   = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "enable_auto_scaling")
  min_count             = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "enable_auto_scaling") ? lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "min_count") : null
  max_count             = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "enable_auto_scaling") ? lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "max_count") : null
  node_count            = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "enable_auto_scaling") ? null : lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "node_count")
  vm_size               = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "vm_size")
  zones		            	= length(var.azurerm_kubernetes_cluster_availability_zones) > 1 ? var.azurerm_kubernetes_cluster_availability_zones : null
  max_pods              = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "max_pods")
  os_type               = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "os_type")
  vnet_subnet_id        = var.azurerm_kubernetes_cluster_node_pool_vnet_subnet_id
  kubernetes_cluster_id = var.azurerm_kubernetes_cluster_id
  os_disk_type          = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "os_disk_type")
  os_sku                = lookup(var.azurerm_kubernetes_cluster_additional_node_pool, "os_sku")

  tags                  = var.common_tags
}