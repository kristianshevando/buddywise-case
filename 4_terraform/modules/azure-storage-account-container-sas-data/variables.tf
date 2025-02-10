variable "azurerm_storage_account_primary_connection_string" {
  type = string
  description = "Azure storage account primary connection string."
}

variable "azurerm_storage_account_container_name" {
  type = string
  description = "Azure storage account container name."
}

variable "azurerm_storage_account_sas_token_validity_time" {
  type = string
  description = "Azure Key Vault secret name for SAS token."
  default = "3h"
}

variable "azure_storage_account_sas_permissions" {
  type = object({
    read    = bool
    write   = bool
    delete  = bool
    list    = bool
    add     = bool
    create  = bool
  })
  description = "SAS token permission."
  default = {
    read    = true
    write   = false
    delete  = false
    list    = true
    add     = false
    create  = false
  }
}