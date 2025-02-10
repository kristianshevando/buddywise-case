output "storage_account_container_name" {
  value = join("", azurerm_storage_container.container.*.name)
}

output "storage_account_container_url" {
  value = "https://${join("", azurerm_storage_container.container.*.storage_account_name)}.blob.core.windows.net/${join("", azurerm_storage_container.container.*.name)}"
}

output "storage_account_container_id" {
  value = join("", azurerm_storage_container.container.*.resource_manager_id)
}