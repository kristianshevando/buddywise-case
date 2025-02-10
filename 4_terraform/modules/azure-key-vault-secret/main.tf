resource "azurerm_key_vault_secret" "secret" {
  for_each         = { for secret in var.additional_key_vault_secrets: secret.key_name => secret if secret.key_name != null }

  name             = each.value.key_name
  value            = each.value.key_value
  content_type     = each.value.content_type
  key_vault_id     = var.azure_key_vault_id
  expiration_date  = lookup(each.value, "expiration_date", null)
}