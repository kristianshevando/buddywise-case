resource "azurerm_network_security_group" "nsg" {
  name                = var.azurerm_network_security_group_name
  location            = var.location
  resource_group_name = var.azurerm_resource_group_name
  tags                = var.common_tags
}