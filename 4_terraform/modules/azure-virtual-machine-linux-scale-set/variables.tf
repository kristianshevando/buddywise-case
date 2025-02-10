variable "azurerm_resource_group_name" {
    type        = string
    description = "Name of the Resource Group"
}

variable "location" {
    type        = string
    description = " Location of the resource"
}

variable "azurerm_vmss_name" {
    type        = string
    description = "Azure VMSS name."
}

variable "azurerm_vmss_sku" {
    type        = string
    description = "Azure VMSS sku."
}

variable "azurerm_vmss_instances_count" {
    type        = number
    description = "Azure VMSS initial count of instances."
}

variable "azurerm_vmss_admin_username" {
    type        = string
    description = "Azure VMSS administrator user name."
}

variable "azurerm_vmss_availability_zones" {
    type = list(string)
    description = "Azure VMSS availability zones."
}

variable "azurerm_vmss_computer_name_prefix" {
    type        = string
    description = "Azure VMSS instance name prefix."
}

variable "azurerm_vmss_subnet" {
    type        = string
    description = "Azure subnet for VMSS."
}

variable "azurerm_vmss_source_image_id" {
    type        = string
    description = "Source image id for VMSS."
}

variable "azurerm_vmss_os_disk_storage_account_type" {
    type        = string
    description = "Storage account type of VMSS OS disk. Possible values are Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS and Premium_ZRS"
}

variable "azurerm_key_vault_id" {
    type        = string
    description = "Key Vault ID for storing username, password"
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "azurerm_managed_service_identity_enabled" {
    type        = bool
    description = "Azure managed service identity enabler."
    default     = true
}