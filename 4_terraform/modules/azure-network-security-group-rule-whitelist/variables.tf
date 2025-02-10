variable "azure_nsg_rules_whitelist" {
  description = "Whitelist to restrict access to environment throught Azure Application gateway."
}

variable "azure_nsg_rules_whitelist_destination" {
  type        = list(string)
  description = "Destination address network address."
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name where NSG is located."
}

variable "network_security_group_name" {
  type        = string
  description = "Azure Network security group where rule will be created."
}