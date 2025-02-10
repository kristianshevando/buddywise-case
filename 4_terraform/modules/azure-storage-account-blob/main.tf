resource "azurerm_storage_blob" "blob" {
  name                   = var.azurerm_storage_blob_name
  storage_account_name   = var.azure_storage_account_name
  storage_container_name = var.azure_storage_account_container_name
  type                   = var.azurerm_storage_blob_type
  source                 = var.azurerm_storage_blob_source_uri == null ? var.azurerm_storage_blob_source_path : null
  source_uri             = var.azurerm_storage_blob_source_path == null ? var.azurerm_storage_blob_source_uri : null
}