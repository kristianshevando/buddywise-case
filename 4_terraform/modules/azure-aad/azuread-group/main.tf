resource "azuread_group" "group" {
  display_name            = var.azuread_group_display_name
  owners                  = var.azuread_group_owners
  security_enabled        = var.azuread_group_security_enabled
  prevent_duplicate_names = var.azuread_group_prevent_duplicate_names
}