output "azure_vnet_output" {
  value = [
    for id, address_space in zipmap(
      data.azurerm_virtual_network.vnet.*.id,
      data.azurerm_virtual_network.vnet.*.address_space) :
      tomap({"vnet_id" = id, "address_space" = join(",", address_space)})
  ]
}