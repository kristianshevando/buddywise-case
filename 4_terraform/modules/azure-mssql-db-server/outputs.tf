output "fully_qualified_domain_name" {
  value = azurerm_mssql_server.db_server.fully_qualified_domain_name
}

output "azurerm_mssql_server_id" {
  value = azurerm_mssql_server.db_server.id
}

output "azurerm_mssql_server_name" {
  value = azurerm_mssql_server.db_server.name
}