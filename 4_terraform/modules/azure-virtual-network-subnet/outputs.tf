output "azurerm_subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "azurerm_subnet_address_prefixes" {
  value = join(",", azurerm_subnet.subnet.address_prefixes)
}

output "azurerm_subnet_network_security_group_association_subnet_id" {
  value = azurerm_subnet_network_security_group_association.attach_subnet.*.id
}

output "azurerm_network_security_group_name" {
  value = var.create_azure_network_security_group ? azurerm_network_security_group.network_security_group[0].name : "none"
}

output "azurerm_subnet_name_id" {
  value = [
    for name, subnet_id in zipmap(
      [azurerm_subnet.subnet.name],
      [azurerm_subnet.subnet.id]) :
      tomap({"instance_name" = name, "subnet_id" = subnet_id})
  ]
}

output "azure_subnet_output" {
  value = [
    tomap({
      "instance_name" = azurerm_subnet.subnet.name
      "address_prefixes" = join(",", azurerm_subnet.subnet.address_prefixes)
    })
  ]
}