variable "name" {
    description = "The name of public ip."
    type = string
}

variable "location" {
    description = "The region of public ip."
    type = string
}

variable "resource_group_name" {
    description = "Public ip resource group name."
    type = string
}

variable "sku" {
    description = "Default sku public ip."
    type = string
}

variable "allocation_method" {
    description = "Default allocation method for public ip."
    type = string
}

variable "domain_name_label" {
    description = "Default allocation method for public ip."
    type = string
    default = null
}

variable "azure_key_vault_id" {
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "availability_zones" {
    type = list(string)
    description = "The availability zone to allocate the Public IP in."
    default = null
}

variable "lock_azure_resources" {
    type = bool
    default = false
}

variable "idle_timeout_in_minutes" {
    type = number
    default = 4
}