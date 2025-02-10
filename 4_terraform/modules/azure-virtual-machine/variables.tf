variable "location" {
    description = "The region of Azure virtual machine."
    type = string
}

variable "azure_resource_group_name" {
    description = "Public ip resource group name."
    type = string
}

variable "azure_virtual_network_name" {
    description = "Azure Virtual network name."
    type = string
}

variable "azure_key_vault_id" {
    description = "Azure Key Vault id to store configuration data."
    type = string
}

variable "azure_virtual_machines" {
    description = "Object with virtual machines."
    type = any
}

variable "azure_virtual_network_subnet" {
    description = "Array with virtual network subnets."
    type = string
}

variable "platform_fault_domain_count" {
    description = "Count of fault domain for availability set."
    type = number
}

variable "platform_update_domain_count" {
    description = "Count of update domain for availability set."
    type = number
}

variable "public_ip_address_id" {
    description = "Reference to a Public IP Address to associate with this NIC."
    type = string
    default = null
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}