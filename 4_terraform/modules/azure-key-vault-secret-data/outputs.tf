output "azurerm_key_vault_secret_value" {
  value = var.azure_key_vault_secret_content_type == "Common" ? nonsensitive(data.azurerm_key_vault_secret.key_vault_secret.value) : data.azurerm_key_vault_secret.key_vault_secret.value
}

output "azurerm_key_vault_secret_name" {
  value = data.azurerm_key_vault_secret.key_vault_secret.name
}

output "azurerm_key_vault_secret" {
  value = var.azure_key_vault_secret_content_type == "Common" ? [
    for secret_name, secret_value in zipmap(
      [data.azurerm_key_vault_secret.key_vault_secret.name],
      [nonsensitive(data.azurerm_key_vault_secret.key_vault_secret.value)]) :
      tomap({"secret_name" = secret_name, "secret_value" = secret_value})
  ] : [
    for secret_name, secret_value in zipmap(
      [data.azurerm_key_vault_secret.key_vault_secret.name],
      [data.azurerm_key_vault_secret.key_vault_secret.value]) :
      tomap({"secret_name" = secret_name, "secret_value" = secret_value})
  ]
}