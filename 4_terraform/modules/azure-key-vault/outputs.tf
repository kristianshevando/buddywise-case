output "azurerm_key_vault_name" {
  value = element(reverse(split("/", azurerm_key_vault.key_vault.id)), 0)
}

output "azurerm_key_vault_id" {
  value = azurerm_key_vault.key_vault.id
}

output "azurerm_key_vault_uri" {
  value = azurerm_key_vault.key_vault.vault_uri
}

output "azurerm_key_vault_resource_group_name" {
  value = var.azurerm_key_vault_resource_group_name
}