resource "azurerm_role_definition" "custom_role" {
  name        = var.azurerm_role_definition_name
  scope       = element(var.assignable_scopes, 0)
  description = var.azurerm_role_definition_description

  permissions {
    actions          = var.permissions_actions
    not_actions      = var.permissions_not_actions
    data_actions     = var.permissions_data_actions
    not_data_actions = var.permissions_not_data_actions
  }

  assignable_scopes = var.assignable_scopes
}