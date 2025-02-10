data "azurerm_storage_account_sas" "sas_token" {
  connection_string = var.azurerm_storage_account_primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = formatdate("YYYY-MM-DD", timestamp())
  expiry = formatdate("YYYY-MM-DD", timeadd(timestamp(), var.azurerm_storage_account_sas_token_validity_time))

  permissions {
    read    = var.azure_storage_account_sas_permissions.read
    write   = var.azure_storage_account_sas_permissions.write
    delete  = var.azure_storage_account_sas_permissions.delete
    list    = var.azure_storage_account_sas_permissions.list
    add     = var.azure_storage_account_sas_permissions.add
    create  = var.azure_storage_account_sas_permissions.create
    update  = var.azure_storage_account_sas_permissions.update
    process = var.azure_storage_account_sas_permissions.process
    tag	    = var.azure_storage_account_sas_permissions.tag
    filter  = var.azure_storage_account_sas_permissions.filter
  }
}

resource "azurerm_key_vault_secret" "storage_account_sas_key" {
  count        = var.create_azure_key_vault_secret ? 1 : 0
  name         = var.azurerm_key_vault_secret_name
  value        = data.azurerm_storage_account_sas.sas_token.sas
  key_vault_id = var.azure_key_vault_id
  content_type = "Sensitive"
  depends_on   = [data.azurerm_storage_account_sas.sas_token]
}