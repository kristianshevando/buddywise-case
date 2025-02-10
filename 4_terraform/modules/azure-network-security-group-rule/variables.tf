variable "infrastructure_name" {
  type = string
  description = "The name for the resources."
  default     = null
}

variable "azure_nsg_rules" {
  description = "List of Azure NSG rules."
}

variable "azure_subnets" {
  description = "List of Azure subnets."
}

variable "azure_resource_group_name" {
  description = "Azure resource group name."
  default     = null
}