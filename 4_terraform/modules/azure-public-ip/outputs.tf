output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "public_ip_id" {
  value = azurerm_public_ip.public_ip.id
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.public_ip.fqdn
}

output "public_ip_name" {
  value = azurerm_public_ip.public_ip.name
}