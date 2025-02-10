data "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.azure_key_vault_secret_name
  key_vault_id = var.azure_key_vault_id
}