output "azurerm_storage_account_blob_container_sas" {
  value = data.azurerm_storage_account_blob_container_sas.container_sas.sas
}

output "azurerm_storage_account_sas_token_validity_time" {
  value = data.azurerm_storage_account_blob_container_sas.container_sas.expiry
}