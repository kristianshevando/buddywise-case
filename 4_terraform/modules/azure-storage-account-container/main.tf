resource "azurerm_storage_container" "container" {
  count                 = var.azure_storage_account_container_required ? 1 : 0
  name                  = var.azure_storage_account_container_name
  storage_account_name  = var.azure_storage_account_name
  container_access_type = var.azure_storage_account_container_access_type

  lifecycle {
      prevent_destroy = false
  }
}