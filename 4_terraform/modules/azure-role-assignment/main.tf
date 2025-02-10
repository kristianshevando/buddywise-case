resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.azurerm_role_assignment_scope
  role_definition_name = var.role_definition_name
  role_definition_id   = var.role_definition_resource_id
  principal_id         = var.azurerm_principal_id
}