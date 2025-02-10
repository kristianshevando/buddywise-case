output "azuread_user_principal_name" {
  value = azuread_user.user.user_principal_name
}

output "azuread_user_display_name" {
  value = azuread_user.user.display_name
}

output "azuread_user_password" {
  value     = random_password.application.result
  sensitive = true
}