variable "azurerm_storage_blob_name" {
    type = string
    description = "The name of the storage blob. Must be unique within the storage container the blob is located."
}

variable "azure_storage_account_name" {   
    type = string
    description = "The name of storage account name."
}

variable "azure_storage_account_container_name" {   
    type = string
    description = "The name of the storage container in which this blob should be created."
}

variable "azurerm_storage_blob_type" {   
    type = string
    description = "The type of the storage blob to be created. Possible values are Append, Block or Page."
}

variable "azurerm_storage_blob_source_path" {   
    type = string
    description = "An absolute path to a file on the local system."
    default = null
}

variable "azurerm_storage_blob_source_uri" {   
    type = string
    description = "An uri to a file."
    default = null
}