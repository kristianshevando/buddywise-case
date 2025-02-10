output "azure_subnet_output" {
  value = [
    for name, address_prefixes in zipmap(
      data.azurerm_subnet.subnets.*.name,
      data.azurerm_subnet.subnets.*.address_prefixes) :
      tomap({"instance_name" = name, "address_prefixes" = join(",", address_prefixes)})
  ]
}