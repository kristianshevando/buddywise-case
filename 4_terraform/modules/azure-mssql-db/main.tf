data "azurerm_client_config" "current" {}

resource "azurerm_mssql_database" "elastic_pool_db" {
  name            = var.azurerm_mssql_database_name
  server_id       = var.azurerm_mssql_server_id
  license_type    = var.azurerm_mssql_license_type
  max_size_gb     = var.azurerm_mssql_db_max_size
  elastic_pool_id = var.azure_mssql_elastic_pool_id
  zone_redundant  = var.azurerm_mssql_database_zone_redundant

  tags = var.common_tags

  lifecycle {
      prevent_destroy = false
      ignore_changes  = [license_type,]
  }
}

resource "null_resource" "azure_sql_backup_retention" {
  count         = lookup(var.azurerm_sql_backup_ltr_configuration, "azurerm_sql_backup_ltr_enabled") ? 1 : 0       
  provisioner "local-exec" {
    command     = "az sql db ltr-policy set --resource-group ${var.azurerm_mssql_server_resource_group_name} --server ${var.azurerm_mssql_server_name} --subscription ${data.azurerm_client_config.current.subscription_id} --name ${var.azurerm_mssql_database_name} --weekly-retention ${lookup(var.azurerm_sql_backup_ltr_configuration, "azurerm_sql_backup_weekly_retention")} --monthly-retention ${lookup(var.azurerm_sql_backup_ltr_configuration, "azurerm_sql_backup_monthly_retention")} --yearly-retention ${lookup(var.azurerm_sql_backup_ltr_configuration, "azurerm_sql_backup_yearly_retention")} --week-of-year ${lookup(var.azurerm_sql_backup_ltr_configuration, "azurerm_sql_backup_yearly_backup_week")}"
    interpreter = ["pwsh", "-Command"]
  }
  depends_on    = [azurerm_mssql_database.elastic_pool_db]
}

resource "azurerm_key_vault_secret" "elastic_pool_db_id" {
  name         = "db-id"
  value        = join("", azurerm_mssql_database.elastic_pool_db.*.id)
  key_vault_id = var.azure_core_key_vault_id
  depends_on   = [azurerm_mssql_database.elastic_pool_db]
}

resource "azurerm_key_vault_secret" "elastic_pool_db_name" {
  name         = "db-name"
  value        = element(reverse(split("/", join("", azurerm_mssql_database.elastic_pool_db.*.id))), 0)
  key_vault_id = var.azure_core_key_vault_id
  depends_on   = [azurerm_mssql_database.elastic_pool_db]
}

resource "azurerm_key_vault_secret" "sql-server-name" {
  name         = "sql-server-name"
  value        = var.azurerm_mssql_server_name
  key_vault_id = var.azure_core_key_vault_id
  depends_on   = [azurerm_mssql_database.elastic_pool_db]
}

resource "azurerm_key_vault_secret" "sql-server-fqdn" {
  name         = "sql-server-fqdn"
  value        = "${var.azurerm_mssql_server_name}.database.windows.net"
  key_vault_id = var.azure_core_key_vault_id
  depends_on   = [azurerm_mssql_database.elastic_pool_db]
}

resource "random_password" "database_manager_login_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "#"
}

// The following secrets are created to secure access to the shared SQL Server.
// Provisioned for each environment SQL DB template will be used as starting point for database of the appropriate environment.
// Before the Innovator is deployed, it checks for the presence of the necessary accounts in the template database and, if necessary, creates these accounts using sqlcmd.
// After Innovator deployment process we update compatibility level of deployed database to the latest on current SQL server.
resource "azurerm_key_vault_secret" "database_manager_login_name" {
  name         = "${var.azurerm_mssql_server_name}-db-${var.prefix}-manager-username"
  value        = "${var.prefix}-database-manager"
  key_vault_id = var.azure_sql_key_vault_id
}

resource "azurerm_key_vault_secret" "database_manager_login_password" {
  name         = "${var.azurerm_mssql_server_name}-db-${var.prefix}-manager-password"
  value        = random_password.database_manager_login_password.result
  key_vault_id = var.azure_sql_key_vault_id
  content_type = "Sensitive"
}

resource "random_password" "innovator_login_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "#"
}

resource "azurerm_key_vault_secret" "innovator_login_name" {
  name         = "${var.azurerm_mssql_server_name}-db-${var.prefix}-innovator-username"
  value        = "${var.prefix}_innovator"
  key_vault_id = var.azure_sql_key_vault_id
}

resource "azurerm_key_vault_secret" "innovator_login_password" {
  name         = "${var.azurerm_mssql_server_name}-db-${var.prefix}-innovator-password"
  value        = random_password.innovator_login_password.result
  key_vault_id = var.azure_sql_key_vault_id
  content_type = "Sensitive"
}

resource "random_password" "innovator_regular_login_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "#"
}

resource "azurerm_key_vault_secret" "innovator_regular_login_name" {
  name         = "${var.azurerm_mssql_server_name}-db-${var.prefix}-innovator-regular-username"
  value        = "${var.prefix}_innovator_regular"
  key_vault_id = var.azure_sql_key_vault_id
}

resource "azurerm_key_vault_secret" "innovator__regular_login_password" {
  name         = "${var.azurerm_mssql_server_name}-db-${var.prefix}-innovator-regular-password"
  value        = random_password.innovator_regular_login_password.result
  key_vault_id = var.azure_sql_key_vault_id
  content_type = "Sensitive"
}