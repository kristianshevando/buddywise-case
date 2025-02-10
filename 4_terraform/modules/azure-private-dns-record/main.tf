resource "azurerm_private_dns_a_record" "dns_record" {
  count 	      = var.private_dns_record_type == "A" ? 1 : 0

  name                = lower(var.dns_record_name)
  zone_name           = var.azure_private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.dns_record_ttl
  records             = var.record_value
}

resource "azurerm_private_dns_cname_record" "dns_record" {
  count 	      = var.private_dns_record_type == "CNAME" ? 1 : 0

  name                = lower(var.dns_record_name)
  zone_name           = var.azure_private_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.dns_record_ttl
  record              = join(",", var.record_value)
}