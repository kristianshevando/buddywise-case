resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = lookup(var.azure_private_dns_zones, "zone_name")
  resource_group_name = var.resource_group_name

  tags = var.common_tags
}