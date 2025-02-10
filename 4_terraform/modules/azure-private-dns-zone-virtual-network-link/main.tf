resource "azurerm_private_dns_zone_virtual_network_link" "virtual_network_link" {
  name                  = var.virtual_network_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = element(reverse(split("/", var.azure_private_dns_zones_ids)), 0)
  virtual_network_id    = var.virtual_network_id
  tags                  = var.common_tags
}