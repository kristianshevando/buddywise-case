resource "azurerm_log_analytics_workspace" "workspace" {
  name                  = var.workspace_name
  location              = var.workspace_location
  resource_group_name   = var.workspace_azure_resource_group_name
  sku                   = var.workspace_sku
  retention_in_days     = var.workspace_retention_in_days
  tags                  = var.common_tags
}