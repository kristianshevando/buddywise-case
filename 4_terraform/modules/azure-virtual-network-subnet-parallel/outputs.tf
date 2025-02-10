output "azurerm_subnet_output" {
  value = [
    for name, subnet_id in zipmap(
      [azurerm_subnet.subnet.name],
      [azurerm_subnet.subnet.id]) :
      tomap({"instance_name" = name, "subnet_id" = subnet_id})
  ]
}

output "azurerm_subnet_output_address_prefixes" {
  value = [
    for instance_name, address_prefixes in zipmap(
      [azurerm_subnet.subnet.name],
      azurerm_subnet.subnet.address_prefixes) :
      tomap({"instance_name" = instance_name, "address_prefixes" = address_prefixes})
  ]
}

output "azurerm_subnet_network_security_group_association_subnet_id" {
  value = [azurerm_subnet_network_security_group_association.attach_subnet.id]
}

output "azurerm_network_security_group_id" {
  value = [azurerm_network_security_group.network_security_group.id]
}

output "azurerm_network_security_group_name" {
  value = [element(reverse(split("/", azurerm_network_security_group.network_security_group.id)), 0)]
}