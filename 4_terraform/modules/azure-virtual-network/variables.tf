variable "azure_vnet_name" {   
    type = string
}

variable "azure_vnet_location" {
    type = string
}

variable "azure_resource_group_name" {
    type = string
}

variable "azure_vnet_address_space" {
    type = list(string)
}

variable "azure_vnet_dns_servers" {
    type    = list(string)
    default = null
}

variable "azure_key_vault_id" {
    type    = string
    default = null
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "result_to_key_vault" {
    type = bool
    default = true
    description = "Push result to Azure Key Vault."
}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "The ddos protection plan resource id."
}