output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "primary_connection_string" {
  sensitive = true
  value     = azurerm_storage_account.storage_account.primary_connection_string
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "primary_file_endpoint" {
  value = azurerm_storage_account.storage_account.primary_file_endpoint
}

output "primary_access_key" {
  sensitive = true
  value     = azurerm_storage_account.storage_account.primary_access_key
}

output "storage_account_ids" {
  value = zipmap(tolist([azurerm_storage_account.storage_account.name]),tolist([azurerm_storage_account.storage_account.id]))
}