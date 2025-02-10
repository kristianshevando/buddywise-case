resource "azurerm_storage_share_file" "fs_file" {
  name             = var.azurerm_storage_share_file_name
  storage_share_id = var.azurerm_storage_share_id
  path             = var.azurerm_storage_share_path_to_directory
  source           = var.azurerm_storage_share_path_to_source_file

  lifecycle {
    ignore_changes  = [
      source
    ]
  }
}