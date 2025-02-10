variable "azure_resource_group_name" {
    type = string
}

variable "azure_storage_account_name" {
    type = string
}

variable "azure_storage_account_location" {
    type = string
}

variable "azure_storage_account_tier" {
    type = string
    default = ""
}

variable "azure_storage_account_type" {
    type = string
    default = ""
}

variable "azure_storage_account_kind" {
    type = string
    default = ""
}

variable "azure_storage_account_access_tier" {
    type = string
    default = null
}

variable "azure_key_vault_id" {
    type = string
    default = ""
}

variable "azure_sa_firewall_enabled" {
    type = bool
    default = true
    description = "Configure Azure Storage Account firewall with azure-storage-account module."
}

variable "azure_sa_firewall_default_rules" {
    type = bool
    default = true
    description = "Create default rules in Azure Storage Account firewall."
}

variable "result_to_key_vault" {
    type = bool
    default = true
    description = "Push result to Azure Key Vault."
}

variable "azure_sa_blob_versioning_enabled" {
    type = bool
    default = false
    description = "Enable blob versioning for Azure SA."
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "lock_azure_resources" {
    type = bool
    default = false
}