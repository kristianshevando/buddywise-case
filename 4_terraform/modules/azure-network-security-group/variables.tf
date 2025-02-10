variable "azurerm_network_security_group_name" {
  type = string
  description = "The name of the network security group."
}

variable "location" {
  description = "The Azure region of NSG."
  type = string
}

variable "azurerm_resource_group_name" {
  description = "The name of the resource group in which to create the network security group."
  type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}