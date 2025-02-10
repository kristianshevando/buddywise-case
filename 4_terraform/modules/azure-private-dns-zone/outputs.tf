output "azure_private_dns_zones" {
  value = [
    for resource, zone in zipmap(
      [lookup(var.azure_private_dns_zones, "resource_name")],
      [azurerm_private_dns_zone.private_dns_zone.id]) :
      tomap({"resource_name" = resource, "zone_id" = zone})
  ]
}

output "azure_private_dns_zones_name" {
  value = azurerm_private_dns_zone.private_dns_zone.name
}

output "azure_private_dns_zones_id" {
  value = azurerm_private_dns_zone.private_dns_zone.id
}