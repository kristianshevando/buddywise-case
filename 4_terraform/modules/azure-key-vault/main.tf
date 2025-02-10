data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                            = lower(replace(var.azurerm_key_vault_name, "/([!/:-@[-`{}-~])/", ""))
  location                        = var.location
  resource_group_name             = var.azurerm_key_vault_resource_group_name
  enabled_for_disk_encryption     = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled        = false
  sku_name                        = "standard"
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  
  tags = var.common_tags  

  lifecycle {
    ignore_changes = [
      access_policy,
    ]
  }

  network_acls {
    default_action = var.azurerm_key_vault_network_acls_default_action
    bypass         = "AzureServices"
    ip_rules       = concat(var.buddywise_vpn_public_ip_list, var.azurerm_key_vault_network_acls_allowed_list)
  }
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "List",
      "Create",
      "Get"
    ]

    secret_permissions = [
      "List",
      "Set",
      "Get",
      "Delete",
      "Recover",
      "Restore",
      "Purge"
    ]
  }
}

resource "azurerm_management_lock" "azure_key_vault" {
  count      = var.lock_azure_resources ? 1 : 0
  
  name       = azurerm_key_vault.key_vault.name
  scope      = azurerm_key_vault.key_vault.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion."
}