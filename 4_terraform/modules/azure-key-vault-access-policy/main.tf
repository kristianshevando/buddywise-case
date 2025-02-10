data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id            = var.azurerm_key_vault_id
  tenant_id               = var.azurerm_tenant_id == null ? data.azurerm_client_config.current.tenant_id : var.azurerm_tenant_id
  object_id               = var.azurerm_aad_object_ids
  secret_permissions      = var.azurerm_kv_access_policy_permissions
  key_permissions         = var.azurerm_kv_access_policy_key_permissions
  certificate_permissions = var.azurerm_kv_access_policy_certificate_permissions
}