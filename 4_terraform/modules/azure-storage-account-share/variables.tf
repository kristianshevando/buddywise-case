variable "azure_storage_account_share_name" {
    type        = string
    description = "Name of File Share in Storage Account"
}

variable "azure_storage_account_name" {   
    type        = string
    description = "Name of Storage Account"
}

variable "azure_storage_account_share_quota" {   
    type        = string
    description = "Quota of File Share in Gib"
}