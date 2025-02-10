resource "azurerm_recovery_services_vault" "vault" {
  name                = var.azurerm_recovery_services_vault_name
  location            = var.location
  resource_group_name = var.azure_resource_group_name
  sku                 = var.sku
  soft_delete_enabled = true
}

resource "azurerm_backup_container_storage_account" "protection-container" {
  resource_group_name = var.azure_resource_group_name
  recovery_vault_name = element(reverse(split("/", azurerm_recovery_services_vault.vault.id)), 0)
  storage_account_id  = var.protected_storage_account_id
}