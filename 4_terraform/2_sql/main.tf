provider "azurerm" {
  subscription_id = var.SUBSCRIPTION_ID
  client_id       = var.SPN_CLIENT_ID
  client_secret   = var.SPN_CLIENT_SECRET
  tenant_id       = var.TENANT_ID
  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
      purge_soft_delete_on_destroy    = true
    }
  }
}

locals {
  infrastructure_tags = {
    code_version                  = var.infrastructure_code_version,
    environment_type              = var.PREFIX,
    automated_destroy             = var.AUTOMATED_DESTROY,
    terraform_code_package_number = var.TERRAFORM_CODE_PACKAGE_NUMBER,
    arm_subscription_id           = data.azurerm_client_config.current.subscription_id
  }

  common_tags = local.infrastructure_tags
}

data "azurerm_client_config" "current" {}

module "azure_resource_group" {
  source   = "..//modules/azure-resource-group"
  providers = {
    azurerm = azurerm
  }

  azure_resource_group_name     = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  azure_resource_group_location = var.LOCATION
  common_tags                   = local.common_tags
}

module "azure_key_vault" {
  source                      = "..//modules/azure-key-vault"
  providers = {
    azurerm = azurerm
  }

  azurerm_key_vault_name                        = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  location                                      = var.LOCATION
  azurerm_key_vault_resource_group_name         = module.azure_resource_group.resource_group_name
  azurerm_key_vault_network_acls_default_action = var.azurerm_key_vault_network_acls_default_action
  common_tags                                   = local.common_tags
}

module "azure_virtual_network" {
  source                      = "..//modules/azure-virtual-network"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name           = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  azure_vnet_location       = var.LOCATION
  azure_resource_group_name = module.azure_resource_group.resource_group_name
  azure_vnet_address_space  = var.azure_vnet_address_space
  azure_key_vault_id        = module.azure_key_vault.azurerm_key_vault_id
  common_tags               = local.common_tags
}

module "azure_private_link_virtual_network_subnet" {
  source                      = "..//modules/azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = module.azure_resource_group.resource_group_name
  azure_subnet_name                              = "private-link-sql"
  azure_subnet_address_prefix                    = cidrsubnet(element(var.azure_vnet_address_space, 0), var.azure_subnet_additional_bitmask, 0)
  azure_key_vault_id                             = module.azure_key_vault.azurerm_key_vault_id
  enforce_private_link_endpoint_network_policies = true
  create_azure_network_security_group            = false
  azure_vnet_location                            = var.LOCATION
}

module "azure_storage_account_sql" {
  source                         = "..//modules/azure-storage-account"
  providers = {
    azurerm = azurerm
  }

  azure_storage_account_name        = lower(replace("${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}", "/([!-/:-@[-`{-~])/", ""))
  azure_resource_group_name         = module.azure_resource_group.resource_group_name
  azure_storage_account_location    = var.LOCATION
  azure_storage_account_tier        = var.azure_storage_account_tier
  azure_storage_account_access_tier = var.azure_storage_account_access_tier
  azure_storage_account_type        = var.azure_storage_account_type
  azure_storage_account_kind        = var.azure_storage_account_kind
  azure_key_vault_id                = module.azure_key_vault.azurerm_key_vault_id
  azure_sa_firewall_enabled         = var.azure_sa_firewall_enabled
  result_to_key_vault               = false
  common_tags                       = local.common_tags
}

module "azure_storage_account_container_initial_backup" {
  source                                      = "..//modules/azure-storage-account-container"
  providers = {
    azurerm = azurerm
  }
  count                                       = var.PREFIX == "nprd" ? 1 : 0

  azure_storage_account_container_required    = true
  azure_storage_account_container_name        = "initial-db-backup"
  azure_storage_account_name                  = module.azure_storage_account_sql.storage_account_name
  azure_storage_account_container_access_type = "private"
}

module "azure_mssql_db_server" {
  source                      = "..//modules/azure-mssql-db-server"
  providers = {
    azurerm = azurerm
  }

  azurerm_mssql_server_name                            = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  azurerm_mssql_server_resource_group_name             = module.azure_resource_group.resource_group_name
  location                                             = var.LOCATION
  azurerm_mssql_server_version                         = var.azurerm_mssql_server_version
  azurerm_mssql_administrator_username                 = var.AZURERM_SQL_ADMINISTRATOR_USERNAME
  azurerm_mssql_vulnerability_assessment_enabled       = var.azurerm_mssql_vulnerability_assessment_enabled
  azurerm_mssql_audit_log_enabled                      = var.azurerm_mssql_audit_log_enabled
  azurerm_mssql_server_minimum_tls_version             = var.azurerm_mssql_server_minimum_tls_version
  azurerm_storage_account_name_sql_diag                = module.azure_storage_account_sql.storage_account_name
  azurerm_storage_account_id_sql_diag                  = module.azure_storage_account_sql.storage_account_id
  azurerm_storage_account_primary_blob_endpoint        = module.azure_storage_account_sql.primary_blob_endpoint
  azurerm_storage_account_primary_access_key           = module.azure_storage_account_sql.primary_access_key
  vulnerability_assessment_recipients                  = var.vulnerability_assessment_recipients
  azure_sql_key_vault_id                               = module.azure_key_vault.azurerm_key_vault_id
  common_tags                                          = merge(local.common_tags, { "grafana_alert_enabled" = var.azurerm_grafana_alert_enabled })
}

module "azure_mssql_db_elastic_pool" {
  source                      = "..//modules/azure-mssql-elasticpool"
  providers = {
    azurerm = azurerm
  }

  azurerm_mssql_server_name                = module.azure_mssql_db_server.azurerm_mssql_server_name
  azurerm_mssql_server_resource_group_name = module.azure_resource_group.resource_group_name
  location                                 = var.LOCATION
  azurerm_mssql_elasticpool_capacity       = var.azurerm_mssql_elasticpool_capacity
  azurerm_mssql_license_type               = var.azurerm_mssql_license_type
  azurerm_mssql_elasticpool_sku_name       = var.azurerm_mssql_elasticpool_sku_name
  azurerm_mssql_elasticpool_sku_tier       = var.azurerm_mssql_elasticpool_sku_tier
  azurerm_mssql_elasticpool_sku_family     = var.azurerm_mssql_elasticpool_sku_family
  azurerm_mssql_elasticpool_max_size_gb    = var.azurerm_mssql_elasticpool_max_size_gb
  azurerm_mssql_elasticpool_zone_redundant = var.azurerm_mssql_elasticpool_zone_redundant
  common_tags                              = merge(local.common_tags, { "grafana_alert_enabled" = var.azurerm_grafana_alert_enabled })
}

module "azure_key_vault_additional_secrets_sa" {
  source                      = "..//modules/azure-key-vault-secret"
  providers = {
    azurerm = azurerm
  }

  additional_key_vault_secrets = [
                                  {"key_name" = "storage-account-primary-connection-string", "key_value" = module.azure_storage_account_sql.primary_connection_string, "content_type" = "Sensitive"},
                                  {"key_name" = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-sql-elastic-pool-name", "key_value" = module.azure_mssql_db_elastic_pool.azurerm_mssql_elasticpool_name, "content_type" = "Common"},
                                  {"key_name" = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-sql-elastic-pool-id", "key_value" = module.azure_mssql_db_elastic_pool.azurerm_mssql_elasticpool_id, "content_type" = "Common"},
                                  {"key_name" = "resource-group-name", "key_value" = module.azure_resource_group.resource_group_name, "content_type" = "Common"},
                                  {"key_name" = "storage-account-name", "key_value" = module.azure_storage_account_sql.storage_account_name, "content_type" = "Common"},
                                  {"key_name" = "sql-key-vault-id", "key_value" = module.azure_key_vault.azurerm_key_vault_id, "content_type" = "Common"},
                                  {"key_name" = "sql-server-default-compatibility-level", "key_value" = var.azurerm_mssql_server_default_compatibility_level, "content_type" = "Common"},
                                  {"key_name" = "vnet-name", "key_value" = module.azure_virtual_network.azurerm_virtual_network_name, "content_type" = "Common"},
                                  {"key_name" = "sa-primary-access-key", "key_value" = module.azure_storage_account_sql.primary_access_key, "content_type" = "Sensitive"}
                                 ]
  azure_key_vault_id           = module.azure_key_vault.azurerm_key_vault_id
}