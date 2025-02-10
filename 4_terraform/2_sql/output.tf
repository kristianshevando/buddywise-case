output "azurerm_mssql_server_id" {
  value = module.azure_mssql_db_server.azurerm_mssql_server_id
}

output "azurerm_mssql_server_name" {
  value = module.azure_mssql_db_server.azurerm_mssql_server_name
}

output "azurerm_mssql_server_fqdn" {
  value = module.azure_mssql_db_server.fully_qualified_domain_name
}

output "azurerm_mssql_elastic_pool_id" {
  value =  module.azure_mssql_db_elastic_pool.azurerm_mssql_elasticpool_id
}

output "azurerm_mssql_resource_group_id" {
  value = module.azure_resource_group.resource_group_id
}

output "azurerm_mssql_resource_group_name" {
  value = module.azure_resource_group.resource_group_name
}

output "azurerm_key_vault_id" {
  value = module.azure_key_vault.azurerm_key_vault_id
}

output "azurerm_key_vault_name" {
  value = module.azure_key_vault.azurerm_key_vault_name
}

output "azurerm_key_vault_uri" {
  value = module.azure_key_vault.azurerm_key_vault_uri
}

output "azurerm_storage_account_name" {
  value = module.azure_storage_account_sql.storage_account_name
}

output "azurerm_storage_account_id" {
  value = module.azure_storage_account_sql.storage_account_id
}

output "azurerm_sa_primary_blob_endpoint" {
  value = module.azure_storage_account_sql.primary_blob_endpoint
}

output "azurerm_sa_primary_access_key" {
  sensitive = true
  value = module.azure_storage_account_sql.primary_access_key
}

output "azurerm_sa_primary_connection_string" {
  sensitive = true
  value = module.azure_storage_account_sql.primary_connection_string
}

output "azure_storage_account_container_initial_backup_container_name" {
  value = var.PREFIX == "nprd" ? module.azure_storage_account_container_initial_backup[0].storage_account_container_name : null
}

output "azure_storage_account_container_initial_backup_url" {
  value = var.PREFIX == "nprd" ? module.azure_storage_account_container_initial_backup[0].storage_account_container_url : null
}

output "azurerm_sql_virtual_network_id" {
  value = module.azure_virtual_network.azurerm_virtual_network_id
}

output "azurerm_sql_virtual_network_name" {
  value = module.azure_virtual_network.azurerm_virtual_network_name
}

output "azurerm_sql_virtual_network_subnets_address_space" {
  value = module.azure_private_link_virtual_network_subnet.azure_subnet_output
}

output "azurerm_sql_virtual_network" {
  value = [{
    resource_group_name   = module.azure_resource_group.resource_group_name
    virtual_network_name  = module.azure_virtual_network.azurerm_virtual_network_name
    virtual_network_id    = module.azure_virtual_network.azurerm_virtual_network_id
  }]
}