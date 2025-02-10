resource "azurerm_mssql_elasticpool" "elastic_pool" {
  name                = var.azurerm_mssql_server_name
  resource_group_name = var.azurerm_mssql_server_resource_group_name
  location            = var.location
  server_name         = var.azurerm_mssql_server_name
  license_type        = var.azurerm_mssql_elasticpool_sku_tier == "GeneralPurpose" || var.azurerm_mssql_elasticpool_sku_tier == "BusinessCritical" ? var.azurerm_mssql_license_type : null
  max_size_gb         = var.azurerm_mssql_elasticpool_max_size_gb
  zone_redundant      = var.azurerm_mssql_elasticpool_zone_redundant

  tags = var.common_tags

  lifecycle {
      prevent_destroy = false
      ignore_changes  = [license_type,]
  }

  sku {
    name     = var.azurerm_mssql_elasticpool_sku_name
    tier     = var.azurerm_mssql_elasticpool_sku_tier
    family   = var.azurerm_mssql_elasticpool_sku_tier == "GeneralPurpose" || var.azurerm_mssql_elasticpool_sku_tier == "BusinessCritical" ? var.azurerm_mssql_elasticpool_sku_family : null
    capacity = var.azurerm_mssql_elasticpool_capacity
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = var.azurerm_mssql_elasticpool_capacity
  }
}

resource "azurerm_management_lock" "elastic_pool" {
  count      = var.lock_azure_resources ? 1 : 0

  name       = azurerm_mssql_elasticpool.elastic_pool.name
  scope      = azurerm_mssql_elasticpool.elastic_pool.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion."
}