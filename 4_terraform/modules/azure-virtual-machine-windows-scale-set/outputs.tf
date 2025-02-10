output "azurerm_virtual_machine_scale_set_id" {
  value = azurerm_windows_virtual_machine_scale_set.vmss.id
}

output "azure_managed_service_identity_objects_principal_id" {
  value = var.azurerm_managed_service_identity_enabled ? azurerm_windows_virtual_machine_scale_set.vmss.identity.0.principal_id : null
}

output "azurerm_virtual_machine_scale_set_identity_objects_id_name" {
  sensitive = true
  value = var.azurerm_managed_service_identity_enabled ? [
    for instance_name, object_id in zipmap(
      [azurerm_windows_virtual_machine_scale_set.vmss.name],
      [azurerm_windows_virtual_machine_scale_set.vmss.identity.0.principal_id]) :
      tomap({"instance_name" = instance_name, "object_id" = object_id})
  ] : null
}

output "azurerm_virtual_machine_scale_set_id_name" {
  value = [
    for instance_name, resource_id in zipmap(
      [azurerm_windows_virtual_machine_scale_set.vmss.name],
      [azurerm_windows_virtual_machine_scale_set.vmss.id]) :
      tomap({"instance_name" = instance_name, "resource_id" = resource_id})
  ]
}