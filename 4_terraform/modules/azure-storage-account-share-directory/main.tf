resource "azurerm_storage_share_directory" "fs_directory" {
  name             = var.azurerm_storage_share_directory_name
  storage_share_id = var.azurerm_storage_share_id
}