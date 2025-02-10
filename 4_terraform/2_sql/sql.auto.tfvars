SUBSCRIPTION_ID   = "<placeholder>"
SPN_CLIENT_ID     = "<placeholder>"
SPN_CLIENT_SECRET = "<placeholder>"
TENANT_ID         = "<placeholder>"

INFRASTRUCTURE_NAME           = "bdws"
SUFFIX                        = "sql"
PREFIX                        = "prd"
AUTOMATED_DESTROY             = false
TERRAFORM_CODE_PACKAGE_NUMBER = "1.0.0:somecommithash"
LOCATION                      = "westeurope"
infrastructure_code_version   = "1.0.0"
# !!! All parameters above must be set on deployment agent site as env variables 

AZURERM_SQL_ADMINISTRATOR_USERNAME                   = "sql-admin"
azure_vnet_address_space                             = ["10.0.14.0/24"]
azure_subnet_additional_bitmask                      = 4
azurerm_mssql_license_type                           = "LicenseIncluded"
azurerm_mssql_elasticpool_sku_name                   = "StandardPool"
azurerm_mssql_elasticpool_sku_tier                   = "Standard"
azurerm_mssql_elasticpool_sku_family                 = ""
azurerm_mssql_elasticpool_capacity                   = 50
azurerm_mssql_elasticpool_max_size_gb                = 50
azurerm_mssql_elasticpool_zone_redundant             = false
azurerm_mssql_server_minimum_tls_version             = 1.2
azurerm_mssql_server_version                         = "12.0"
azurerm_mssql_server_default_compatibility_level     = 150
azure_storage_account_tier                           = "Standard"
azure_storage_account_type                           = "GRS"
azure_storage_account_access_tier                    = "Hot"
azure_storage_account_kind                           = "StorageV2"
azurerm_mssql_vulnerability_assessment_enabled       = true
azurerm_mssql_audit_log_enabled                      = true
vulnerability_assessment_recipients                  = ["kristianshevando@gmail.com"]
azurerm_sql_active_directory_administrator_enabled   = true
azurerm_grafana_alert_enabled                        = true