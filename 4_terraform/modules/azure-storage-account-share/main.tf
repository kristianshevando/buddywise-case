resource "azurerm_storage_share" "files_share" { 
  name                 = var.azure_storage_account_share_name
  storage_account_name = var.azure_storage_account_name
  quota                = var.azure_storage_account_share_quota
  
  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}