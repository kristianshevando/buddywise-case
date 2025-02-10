variable "azurerm_storage_share_file_name" {
    type = string
    description = "(Required) The name (or path) of the File that should be created within this File Share. Changing this forces a new resource to be created."
    default     = null
}

variable "azurerm_storage_share_id" {
    type        = string
    description = "(Required) The Storage Share ID in which this file will be placed into. Changing this forces a new resource to be created."
    default     = null
}

variable "azurerm_storage_share_path_to_directory" {
    type        = string
    description = "(Optional) The storage share directory that you would like the file placed into. Changing this forces a new resource to be created."
    default     = null
}

variable "azurerm_storage_share_path_to_source_file" {
    type        = string
    description = "(Optional) An absolute path to a file on the local system. Changing this forces a new resource to be created."
    default     = null
}