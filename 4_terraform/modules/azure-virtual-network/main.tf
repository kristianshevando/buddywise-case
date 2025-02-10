resource "azurerm_virtual_network" "vnet" {
  name                = var.azure_vnet_name
  location            = var.azure_vnet_location
  resource_group_name = var.azure_resource_group_name
  address_space       = var.azure_vnet_address_space
  dns_servers         = var.azure_vnet_dns_servers

  tags                = var.common_tags

  lifecycle {
    prevent_destroy = false
  }

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != null ? [""] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
}

resource "azurerm_key_vault_secret" "vnet_address_space" {
  count        = var.result_to_key_vault ? 1 : 0

  name         = "vnet-address-space"
  value        = join(",", azurerm_virtual_network.vnet.address_space)
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_virtual_network.vnet]
}

resource "azurerm_key_vault_secret" "vnet_id" {
  count        = var.result_to_key_vault ? 1 : 0

  name         = "virtual-network-id"
  value        = azurerm_virtual_network.vnet.id
  key_vault_id = var.azure_key_vault_id
  depends_on   = [azurerm_virtual_network.vnet]
}