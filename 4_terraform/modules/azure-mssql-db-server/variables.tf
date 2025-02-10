variable "azurerm_mssql_server_name" {
    description = "The name of SQL server."
    type = string
}

variable "location" {
    description = "The region of SQL server."
    type = string
}

variable "azurerm_mssql_server_resource_group_name" {
    description = "Azure SQL server resource group name."
    type = string
}

variable "azurerm_mssql_server_version" {
    description = "Version of Azure SQL server."
    type = string
}

variable "azurerm_mssql_administrator_username" {
    description = "Username for Azure SQL administration account."
    type = string
}

variable "azure_sql_key_vault_id" {
    description = "Azure Key Vault resource id for SQL environment."
    type = string
}

variable "azurerm_mssql_vulnerability_assessment_enabled" {
    description = "Manages the Vulnerability Assessment for a Azure MS SQL Server."
    type = bool
}

variable "azurerm_mssql_audit_log_enabled" {
    description = "Manages the extented audit log for a Azure MS SQL Server."
    type = bool
}

variable "azurerm_storage_account_name_sql_diag" {
    description = "Azure storage account name for Azure MSSQL diagnostic."
    type = string
}

variable "vulnerability_assessment_recipients" {
    description = "List of emails to which vulnerability assessment reports should be sent."
    type = list(string)
}

variable "azurerm_storage_account_primary_blob_endpoint" {
    description = "The endpoint URL for blob storage in the primary location."
    type = string
}

variable "azurerm_storage_account_primary_access_key" {
    description = "The primary access key for the storage account."
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "azurerm_mssql_server_minimum_tls_version" {
    description = "Minimum version of TLS for Azure MSSQL server."
    type = string
}

variable "azurerm_storage_account_id_sql_diag" {
    description = "Azure storage account resource id"
    type = string
}

variable "lock_azure_resources" {
    type = bool
    default = false
}