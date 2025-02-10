resource "random_password" "db_instance_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "#"
}

resource "azurerm_mssql_server" "db_server" {
  name                          = lower(replace(var.azurerm_mssql_server_name, "/([!/:-@[-`{-~])/", ""))
  resource_group_name           = var.azurerm_mssql_server_resource_group_name
  location                      = var.location
  version                       = var.azurerm_mssql_server_version
  administrator_login           = var.azurerm_mssql_administrator_username
  administrator_login_password  = random_password.db_instance_password.result
  public_network_access_enabled = false
  minimum_tls_version           = var.azurerm_mssql_server_minimum_tls_version
  
  tags = var.common_tags

  lifecycle {
    prevent_destroy = false
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "audit" {
  count                = var.azurerm_mssql_audit_log_enabled ? 1 : 0

  scope                = var.azurerm_storage_account_id_sql_diag
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.db_server.identity.0.principal_id
}

resource "time_sleep" "wait_for_role_assignment" {
  count           = var.azurerm_mssql_audit_log_enabled ? 1 : 0
  
  create_duration = "30s"
  depends_on      = [azurerm_role_assignment.audit]
}

resource "azurerm_management_lock" "db_server" {
  count      = var.lock_azure_resources ? 1 : 0

  name       = azurerm_mssql_server.db_server.name
  scope      = azurerm_mssql_server.db_server.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion."
}

resource "azurerm_mssql_server_extended_auditing_policy" "audit" {
  count                                   = var.azurerm_mssql_audit_log_enabled ? 1 : 0

  server_id                               = azurerm_mssql_server.db_server.id
  storage_endpoint                        = var.azurerm_storage_account_primary_blob_endpoint
  retention_in_days                       = 21
  depends_on                              = [azurerm_role_assignment.audit, time_sleep.wait_for_role_assignment]
}

resource "azurerm_key_vault_secret" "db_server_id_sql_kv" {
  name         = "${element(split(".", azurerm_mssql_server.db_server.fully_qualified_domain_name), 0)}-db-server-id"
  value        = azurerm_mssql_server.db_server.id
  key_vault_id = var.azure_sql_key_vault_id
  depends_on   = [azurerm_mssql_server.db_server]
}

resource "azurerm_key_vault_secret" "db_server_fqdn_sql_kv" {
  name         = "${element(split(".", azurerm_mssql_server.db_server.fully_qualified_domain_name), 0)}-db-server-fqdn"
  value        = azurerm_mssql_server.db_server.fully_qualified_domain_name
  key_vault_id = var.azure_sql_key_vault_id
  depends_on   = [azurerm_mssql_server.db_server]
}

resource "azurerm_key_vault_secret" "db_server_name_sql_kv" {
  name         = "${azurerm_mssql_server.db_server.name}-db-server-name"
  value        = azurerm_mssql_server.db_server.name
  key_vault_id = var.azure_sql_key_vault_id
  depends_on   = [azurerm_mssql_server.db_server]
}

resource "azurerm_key_vault_secret" "db_server_rg_name_sql_kv" {
  name         = "${azurerm_mssql_server.db_server.name}-db-server-resource-group-name"
  value        = azurerm_mssql_server.db_server.name
  key_vault_id = var.azure_sql_key_vault_id
  depends_on   = [azurerm_mssql_server.db_server]
}

resource "azurerm_key_vault_secret" "db_server_administrator_username" {
  name         = "${element(split(".", azurerm_mssql_server.db_server.fully_qualified_domain_name), 0)}-db-server-administrator-username"
  value        = var.azurerm_mssql_administrator_username
  key_vault_id = var.azure_sql_key_vault_id
}

resource "azurerm_key_vault_secret" "db_server_administrator_password" {
  name         = "${element(split(".", azurerm_mssql_server.db_server.fully_qualified_domain_name), 0)}-db-server-administrator-password"
  value        = random_password.db_instance_password.result
  key_vault_id = var.azure_sql_key_vault_id
  content_type = "Sensitive"
}