variable "SPN_CLIENT_ID" {
  type      = string
  default   = null
}

variable "SPN_CLIENT_SECRET" {
  type      = string
  sensitive = true
  default   = null
}

variable "TENANT_ID" {
  type      = string
  default   = null
}

variable "SUBSCRIPTION_ID" {
  type      = string
  default   = null
}

variable "INFRASTRUCTURE_NAME" {
  type        = string
  description = "The name for the resources created in the specified Azure Resource Group"
  validation {
    condition     = length(var.INFRASTRUCTURE_NAME) <= 14
    error_message = "Infrastructure name should be no more 14 character long."
  }
}

variable "PREFIX" {
  type        = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "SUFFIX" {
  type        = string
  description = "The suffix for the resources created in the specified Azure Resource Group"
}

variable "LOCATION" {
  type        = string
  description = "The location for the deployment"
}

variable "AUTOMATED_DESTROY" {
  type        = string
  description = "Enable destroy of infrastructure from the pipeline."
  default     = "disabled"
}

variable "TERRAFORM_CODE_PACKAGE_NUMBER" {
  type        = string
  description = "Version of Terraform IaC package."
}

variable "AZURERM_SQL_ADMINISTRATOR_USERNAME" {
  type        = string
  description = "The default password for Azure SQL."
}

variable "azurerm_mssql_elasticpool_capacity" {
  description = "Azure SQL elastic pool capacity."
  type = number
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

variable "azure_storage_account_tier" {
    type = string
    description = "Azure Storage Account tier."
}

variable "azure_storage_account_access_tier" {
    type = string
    description = "Azure Storage Account Access tier."
}

variable "azure_storage_account_type" {
    type = string
    description = "Azure Storage Account type."
}

variable "azure_storage_account_kind" {
    type = string
    description = "Azure Storage Account kind."
}

variable "azurerm_mssql_vulnerability_assessment_enabled" {
    description = "Manages the Vulnerability Assessment for a Azure MS SQL Server."
    type = bool
}

variable "azurerm_mssql_audit_log_enabled" {
    description = "Manages the extented audit log for a Azure MS SQL Server."
    type = bool
}

variable "azure_sa_firewall_enabled" {
    description = "Create default deny rule in Azure Storage Account firewall."
    type = bool
    default = true
}

variable "azurerm_key_vault_network_acls_default_action" {
    description = "Create default deny rule in Azure Key Vault firewall."
    type = string
    default = "Deny"
}

variable "vulnerability_assessment_recipients" {
    description = "List of emails to which vulnerability assessment reports should be sent."
    type = list(string)
}

variable "azurerm_sql_active_directory_administrator_enabled" {
    description = "Manages the adminstrator account (Azure Active Directory) for a Azure MS SQL Server."
    type = bool
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

variable "azure_vnet_address_space" {
  type        = list(string)
  description = "Address space for infrastructure."
}

variable "infrastructure_code_version" {
  type        = string
  description = "Version of IaC code. Connected to Managed Services repo tags."
  default     = null
}

variable "azurerm_mssql_server_minimum_tls_version" {
    description = "Minimum version of TLS for Azure MSSQL server."
    type = string
}

variable "azurerm_mssql_server_version" {
    description = "Version of Azure MSSQL server."
    type = string
}

variable "azure_subnet_additional_bitmask" {
    description = "Additional bitmask to calculate size of Virtual Network subnet."
    type = number
    default = 4
}

variable "azurerm_mssql_server_default_compatibility_level" {
    description = "Azure MSSQLserver default compatibility level."
    type = number
}

variable "SQL_SA_ID" {
  type      = string
  default   = ""
}

variable "azurerm_grafana_alert_enabled" {
  type      = string
}