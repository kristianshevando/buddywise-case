variable "additional_key_vault_secrets" {
    type        = list(map(string))
    description = "Additional secrets to add to Azure Key Vault."
}

variable "azure_key_vault_id" {
    type        = string
    description = "Key Vault ID for storing vmss id, username, password"
}