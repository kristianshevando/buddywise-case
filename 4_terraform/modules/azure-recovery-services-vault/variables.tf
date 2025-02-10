variable "location" {
    description = "The region of Azure Recovery Services Vault."
    type = string
}

variable "azurerm_recovery_services_vault_name" {
    description = "Azure Recovery Services Vault name."
    type = string
}

variable "azure_resource_group_name" {
    description = "Azure Recovery Services Vault resource group name."
    type = string
}

variable "sku" {
    description = "Azure Recovery Services Vault sku."
    type = string
}

variable "protected_storage_account_id" {
    description = "Azure storage account id protected by ARSV."
    type = string
}