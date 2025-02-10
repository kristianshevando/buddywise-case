resource "azurerm_container_registry" "acr" {
  name                          = var.azurerm_container_registry_name
  resource_group_name           = var.azurerm_container_registry_resource_group_name
  location                      = var.azurerm_container_registry_location
  sku                	          = var.azurerm_container_registry_sku
  admin_enabled      	          = var.azurerm_container_registry_admin_enabled
  public_network_access_enabled = var.azurerm_container_registry_public_network_access_enabled
  zone_redundancy_enabled	      = var.azurerm_container_registry_public_zone_redundancy_enabled
  tags                          = var.common_tags
  anonymous_pull_enabled        = var.azurerm_container_registry_anonymous_pull_enabled
  
  dynamic "identity" {
    for_each = var.azurerm_user_assigned_identity != null ? [{}] : []
    content {
      type	   = "UserAssigned"
      identity_ids = var.azurerm_user_assigned_identity
    }
  }
}

resource "azurerm_management_lock" "acr" {
  count      = var.lock_azure_resources ? 1 : 0

  name       = var.azurerm_container_registry_name
  scope      = azurerm_container_registry.acr.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion."
}