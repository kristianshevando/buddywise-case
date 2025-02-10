resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = var.azurerm_subnet_id
  network_security_group_id = var.network_security_group_id
}