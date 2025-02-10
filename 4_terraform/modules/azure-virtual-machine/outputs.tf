output "azure_managed_service_identity_object" {
  sensitive = true
  value = [
    for instance_id, object_id in zipmap(
      azurerm_virtual_machine.vm.*.id,
      azurerm_key_vault_secret.azure_managed_service_identity_object.*.value) :
      tomap({"instance_id" = instance_id, "object_id" = object_id})
  ]
}

output "private_ip_addresses" {
  value = [
    for instance_name, ip_address in zipmap(
      azurerm_network_interface.vm.*.name,
      azurerm_network_interface.vm.*.private_ip_address) :
      tomap({"instance_name" = instance_name, "ip_address" = ip_address})
  ]
}

output "azurerm_virtual_machine_ids" {
  value = {for vm_name, vm_id in zipmap(azurerm_virtual_machine.vm.*.name, azurerm_virtual_machine.vm.*.id) : vm_name => vm_id}
}

output "azurerm_virtual_machine_list_name" {
  value = azurerm_virtual_machine.vm.*.name
}

output "azurerm_virtual_machine_list_ids" {
  value = azurerm_virtual_machine.vm.*.id
}