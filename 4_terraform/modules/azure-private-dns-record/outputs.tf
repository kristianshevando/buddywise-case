output "azurerm_private_dns_record" {
  value = var.private_dns_record_type == "A" ? azurerm_private_dns_a_record.dns_record[0].fqdn : null
}