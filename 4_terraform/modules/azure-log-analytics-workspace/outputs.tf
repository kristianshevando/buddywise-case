output "workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.id
}

output "workspace_primary_shared_key" {
  value = nonsensitive(azurerm_log_analytics_workspace.workspace.primary_shared_key)
}

output "workspace_secondary_shared_key" {
  sensitive = true
  value = azurerm_log_analytics_workspace.workspace.secondary_shared_key
}

output "workspace_workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.workspace_id
}