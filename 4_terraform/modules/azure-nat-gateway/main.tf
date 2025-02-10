resource "azurerm_nat_gateway" "gateway" {
  name                    = var.azure_nat_gateway_name
  location                = var.location
  resource_group_name     = var.azure_resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.availability_zones
  tags                    = var.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "gateway" {
  nat_gateway_id       = azurerm_nat_gateway.gateway.id
  public_ip_address_id = var.azure_public_ip_id
}

resource "azurerm_subnet_nat_gateway_association" "gateway" {
  count          = length(var.azurerm_subnet_ids)

  subnet_id      = var.azurerm_subnet_ids[count.index]
  nat_gateway_id = azurerm_nat_gateway.gateway.id
}