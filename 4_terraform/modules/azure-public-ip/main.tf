resource "azurerm_public_ip" "public_ip" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = var.allocation_method
  sku                     = var.sku
  zones                   = var.availability_zones
  domain_name_label       = var.domain_name_label == null || var.domain_name_label == "" ? null : lower(replace(var.domain_name_label, "/([!/:-@[-`{-~])/", ""))
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  tags                    = var.common_tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_key_vault_secret" "pip-ip-address" {
  name         = "pip-ip-address-${var.name}"
  value        = azurerm_public_ip.public_ip.ip_address
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_public_ip.public_ip]
}

resource "azurerm_key_vault_secret" "pip-fqdn" {
  count        = var.domain_name_label == null || var.domain_name_label == "" ? 0 : 1

  name         = "pip-fqdn-${var.name}"
  value        = azurerm_public_ip.public_ip.fqdn
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_public_ip.public_ip]
}

resource "azurerm_management_lock" "public_ip" {
  count      = var.lock_azure_resources ? 1 : 0

  name       = azurerm_public_ip.public_ip.name
  scope      = azurerm_public_ip.public_ip.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion."
}