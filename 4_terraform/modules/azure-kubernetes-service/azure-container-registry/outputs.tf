output "azurerm_container_registry_id" {
  value = azurerm_container_registry.acr.id
}

output "azurerm_container_registry_name" {
  value = var.azurerm_container_registry_name
}

output "azurerm_container_registry_fqdn" {
  value = azurerm_container_registry.acr.login_server
}

output "azurerm_container_registry_admin_username" {
  value = var.azurerm_container_registry_admin_enabled ? azurerm_container_registry.acr.admin_username : "disabled"
}

output "azurerm_container_registry_admin_password" {
  value = var.azurerm_container_registry_admin_enabled ? azurerm_container_registry.acr.admin_password : "disabled"
  sensitive = true
}