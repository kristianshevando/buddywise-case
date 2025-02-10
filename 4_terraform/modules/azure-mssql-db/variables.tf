variable "prefix" {
    description = "The prefix of environment."
    type = string
}

variable "azurerm_mssql_server_id" {
    description = "The name of SQL server."
    type = string
}

variable "azurerm_mssql_database_name" {
    description = "The name of SQL database."
    type = string
}

variable "azurerm_mssql_db_max_size" {
    description = "Azure SQL database maximum size."
    type = string
}

variable "azurerm_mssql_database_zone_redundant" {
    description = "(Optional) Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
    type = bool
    default = false
}

variable "azure_core_key_vault_id" {
    description = "Azure Key Vault to store core configuration data."
    type = string
}

variable "azure_sql_key_vault_id" {
    description = "Azure Key Vault to store SQL specific configuration data."
    type = string
}

variable "azure_mssql_elastic_pool_id" {
    description = "Azure MSSQL elastic pool id."
    type = string
}

variable "azurerm_mssql_license_type" {
    description = "Azure MSSQL license type."
    type = string
}

variable "azurerm_sql_backup_ltr_configuration" {
  type        = map(string)
  description = "Set of values for Azure SQL backup."
}

variable "azurerm_mssql_server_name" {
    description = "The name of SQL server."
    type = string
}

variable "azurerm_mssql_server_resource_group_name" {
    description = "Azure SQL server resource group name."
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}