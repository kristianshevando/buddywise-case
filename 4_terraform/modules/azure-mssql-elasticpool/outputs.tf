output "azurerm_mssql_elasticpool_id" {
  value = azurerm_mssql_elasticpool.elastic_pool.id
}

output "azurerm_mssql_elasticpool_name" {
  value = azurerm_mssql_elasticpool.elastic_pool.name
}

output "azurerm_mssql_elasticpool_ids" {
  value = zipmap(tolist([azurerm_mssql_elasticpool.elastic_pool.name]),tolist([azurerm_mssql_elasticpool.elastic_pool.id]))
}