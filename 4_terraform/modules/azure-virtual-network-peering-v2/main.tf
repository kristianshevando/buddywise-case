resource "azurerm_virtual_network_peering" "peering" {
  name                         = var.azurerm_virtual_network_peering_name
  resource_group_name          = var.azurerm_resource_group_name
  virtual_network_name         = var.azurerm_virtual_network_name
  remote_virtual_network_id    = var.azurerm_remote_virtual_network_id
  allow_virtual_network_access = var.azurerm_allow_virtual_network_access
  allow_gateway_transit        = var.azurerm_allow_gateway_transit
  use_remote_gateways          = var.azurerm_use_remote_gateways
  allow_forwarded_traffic      = var.azurerm_allow_forwarded_traffic
}