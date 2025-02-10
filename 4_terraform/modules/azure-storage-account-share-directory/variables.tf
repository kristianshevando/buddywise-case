variable "azurerm_storage_share_directory_name" {
    type        = string
    description = "(Required) The name (or path) of the Directory that should be created within this File Share. Changing this forces a new resource to be created."
    default     = null
}

variable "azurerm_storage_share_id" {
    type        = string
    description = "(Required) The Storage Share ID in which this file will be placed into. Changing this forces a new resource to be created."
    default     = null
}