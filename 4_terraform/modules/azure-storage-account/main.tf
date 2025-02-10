data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "storage_account" {
  name                     = lower(replace(var.azure_storage_account_name, "/([!-/:-@[-`{-~])/", ""))
  resource_group_name      = var.azure_resource_group_name
  location                 = var.azure_storage_account_location
  account_tier             = var.azure_storage_account_tier
  access_tier              = var.azure_storage_account_access_tier
  account_replication_type = var.azure_storage_account_type
  account_kind             = var.azure_storage_account_kind

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
	tags["initial_backups"]
    ]
    prevent_destroy = false
  }

  blob_properties {
    delete_retention_policy {
      days                 = 7
    }
    
    container_delete_retention_policy {
      days                 = 7
    }
    versioning_enabled = true
  }

  dynamic "network_rules" {
    for_each = var.azure_sa_firewall_enabled && var.azure_sa_firewall_default_rules ? [{}] : []
    content {
      default_action             = "Deny"
      bypass                     = ["AzureServices", "Metrics", "Logging"]
    }
  }

  dynamic "network_rules" {
    for_each = var.azure_sa_firewall_enabled && var.azure_sa_firewall_default_rules ? [] : [{}]
    content {
      default_action             = "Allow"
    }
  }
}

resource "azurerm_management_lock" "storage_account" {
  count      = var.lock_azure_resources ? 1 : 0

  name       = azurerm_storage_account.storage_account.name
  scope      = azurerm_storage_account.storage_account.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion."
}

resource "azurerm_key_vault_secret" "storage_account_id" {
  count        = var.result_to_key_vault ? 1 : 0
  name         = "storage-account-id"
  value        = azurerm_storage_account.storage_account.id
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_storage_account.storage_account]
}

resource "azurerm_key_vault_secret" "storage_account_name" {
  count        = var.result_to_key_vault ? 1 : 0
  name         = "storage-account-name"
  value        = azurerm_storage_account.storage_account.name
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_storage_account.storage_account]
}

resource "azurerm_key_vault_secret" "storage_account_primary_access_key" {
  count        = var.result_to_key_vault ? 1 : 0
  name         = "storage-account-primary-access-key"
  value        = azurerm_storage_account.storage_account.primary_access_key
  key_vault_id = var.azure_key_vault_id
  content_type = "Sensitive"
  depends_on   = [azurerm_storage_account.storage_account]
}

resource "azurerm_key_vault_secret" "storage_account_secondary_access_key" {
  count        = var.result_to_key_vault ? 1 : 0
  name         = "storage-account-secondary-access-key"
  value        = azurerm_storage_account.storage_account.secondary_access_key
  key_vault_id = var.azure_key_vault_id
  content_type = "Sensitive"
  depends_on   = [azurerm_storage_account.storage_account]
}