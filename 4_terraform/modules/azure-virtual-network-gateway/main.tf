resource "azurerm_virtual_network_gateway" "network_gateway" {
  name                = var.azurerm_virtual_network_gateway_name
  location            = var.location
  resource_group_name = var.azure_resource_group_name

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      vpn_client_configuration,
    ]
  }

  tags                = var.common_tags

  type     = var.gateway_type
  vpn_type = var.vpn_type

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku
  generation    = var.generation

  ip_configuration {
    name                          = "defaultGatewayConfig"
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.azure_subnet_id
  }
}