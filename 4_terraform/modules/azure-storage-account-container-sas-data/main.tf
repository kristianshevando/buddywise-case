data "azurerm_storage_account_blob_container_sas" "container_sas" {
  connection_string = var.azurerm_storage_account_primary_connection_string
  container_name    = var.azurerm_storage_account_container_name
  https_only        = true

  start  = timestamp()
  expiry = timeadd(timestamp(), var.azurerm_storage_account_sas_token_validity_time)

  permissions {
    read    = var.azure_storage_account_sas_permissions.read
    write   = var.azure_storage_account_sas_permissions.write
    delete  = var.azure_storage_account_sas_permissions.delete
    list    = var.azure_storage_account_sas_permissions.list
    add     = var.azure_storage_account_sas_permissions.add
    create  = var.azure_storage_account_sas_permissions.create
  }
}