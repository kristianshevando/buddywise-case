output "role_definition_name" {
  value = azurerm_role_assignment.role_assignment.role_definition_name
}

output "role_assignment_scope" {
  value = azurerm_role_assignment.role_assignment.scope
}

output "role_assignment_principal_id" {
  value = azurerm_role_assignment.role_assignment.principal_id
}