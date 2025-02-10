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

variable "azurerm_mssql_elasticpool_capacity" {
    description = "Azure SQL elastic pool capacity."
    type = number
    default = 4
}

variable "azurerm_mssql_license_type" {
    description = "Azure MSSQL license type."
    type = string
}

variable "azurerm_mssql_elasticpool_sku_name" {
    description = "Azure MSSQL sku name."
    type = string
}

variable "azurerm_mssql_elasticpool_sku_tier" {
    description = "Azure MSSQL sku tier."
    type = string
}

variable "azurerm_mssql_elasticpool_sku_family" {
    description = "Azure MSSQL sku family."
    type = string
}

variable "azurerm_mssql_elasticpool_max_size_gb" {
    description = "Azure MSSQL elastic pool max size in GB."
    type = number
}

variable "azurerm_mssql_elasticpool_zone_redundant" {
    description = "(Optional) Whether or not this elastic pool is zone redundant. tier needs to be Premium for DTU based or BusinessCritical for vCore based sku."
    type = bool
    default = false
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "lock_azure_resources" {
    type = bool
    default = false
}