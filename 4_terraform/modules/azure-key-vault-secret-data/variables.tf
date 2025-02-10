variable "azure_key_vault_secret_name" {
    type        = string
    description = "Azure Key Vault secret name."
}

variable "azure_key_vault_id" {
    type        = string
    description = "Azure Key Vault secret name id."
}

variable "azure_key_vault_secret_content_type" {
    type        = string
    description = "Azure Key Vault secret type."
    default     = "Sensitive"
}