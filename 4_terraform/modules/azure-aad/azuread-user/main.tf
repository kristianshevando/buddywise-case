resource "random_password" "application" {
  length           = 32
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "@$#!"
}

resource "azuread_user" "user" {
  user_principal_name = var.azureaad_user_principal_name
  display_name        = var.azureaad_user_display_name
  job_title           = var.azureaad_user_description
  password            = random_password.application.result
}