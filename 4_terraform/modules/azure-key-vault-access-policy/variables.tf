variable "azurerm_tenant_id" {
    description = "The Azure tenant id."
    type = string
    default = null
}

variable "azurerm_key_vault_id" {
    description = "The id of Key Vault."
    type = string
}

variable "azurerm_aad_object_ids" {
    description = "Azure AD objects id for which access policy is creating."
    type = string
}

variable "azurerm_kv_access_policy_permissions" {
    description = "List of Azure Key Vault access policy permissions (secret)."
    type = list(string)
    default = null
}

variable "azurerm_kv_access_policy_key_permissions" {
    description = "List of Azure Key Vault access policy permissions (key)."
    type = list(string)
    default = null
}

variable "azurerm_kv_access_policy_certificate_permissions" {
    description = "List of Azure Key Vault access policy permissions (certificate)."
    type = list(string)
    default = null
}