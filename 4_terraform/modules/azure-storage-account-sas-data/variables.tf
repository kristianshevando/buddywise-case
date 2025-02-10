variable "azurerm_storage_account_primary_connection_string" {
  type = string
  description = "Azure storage account primary connection string."
}

variable "azure_key_vault_id" {
  type = string
  description = "Azure Key Vault id to store configuration data."
  default = ""
}

variable "azure_storage_account_name" {
  type = string
  description = "Azure storage account name."
}

variable "azurerm_key_vault_secret_name" {
  type = string
  description = "Azure Key Vault secret name for SAS token."
  default = ""
}

variable "azurerm_storage_account_sas_token_validity_time" {
  type = string
  description = "Azure Key Vault secret name for SAS token."
  default = "10000h"
}

variable "create_azure_key_vault_secret" {
  type = bool
  description = "Azure Key Vault secret name for SAS token."
  default = true
}

variable "azure_storage_account_sas_permissions" {
  type = object({
    read    = bool
    write   = bool
    delete  = bool
    list    = bool
    add     = bool
    create  = bool
    update  = bool
    process = bool
    tag	    = bool
    filter  = bool
  })
  description = "SAS token permission."
  default = {
    read    = true
    write   = false
    delete  = false
    list    = true
    add     = false
    create  = false
    update  = false
    process = false
    tag	    = false
    filter  = false
  }
}