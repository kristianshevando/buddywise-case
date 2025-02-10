variable "azurerm_container_registry_name" {
    description = "The name of the Container Registry."
    type = string
}

variable "azurerm_container_registry_resource_group_name" {
    description = "The name of the resource group in which to create the Container Registry."
    type = string
}

variable "azurerm_container_registry_location" {
    description = "Location for the Container Registry."
    type = string
}

variable "azurerm_container_registry_sku" {
    description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium."
    type = string
}

variable "azurerm_container_registry_admin_enabled" {
    description = "Specifies whether the admin user is enabled."
    type = bool
    default = false
}

variable "azurerm_container_registry_public_network_access_enabled" {
    description = "Whether public network access is allowed for the container registry."
    type = bool
    default = false
}

variable "azurerm_container_registry_public_zone_redundancy_enabled" {
    description = "Whether zone redundancy is enabled for this Container Registry."
    type = bool
    default = false
}

variable "common_tags" {
  type        = map(string)
  description = "Default set of tags."
  default     = null
}

variable "azurerm_container_registry_georeplications" {
    description = "List of geo locations for Container Registry."    
    default = null
}

variable "azurerm_container_registry_anonymous_pull_enabled" {
    description = "List of geo locations for Container Registry."    
    type = bool
    default = false
}

variable "azurerm_user_assigned_identity" {
    description = "A list of User Managed Identity ID's which should be assigned to the Container Registry."
    type        = list(string)    
    default     = null
}

variable "azurerm_key_vault_id" {
    type        = string
    description = "Key Vault ID for storing admin username, password for ACR."
    default     = null
}

variable "lock_azure_resources" {
    type = bool
    default = false
}
