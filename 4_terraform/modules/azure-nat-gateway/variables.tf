variable "azure_resource_group_name" {   
    type = string
}

variable "location" {
    type = string
}

variable "azure_nat_gateway_name" {
    type = string
}

variable "azure_public_ip_id" {
    type = string
}

variable "azurerm_subnet_ids" {
    type = list(string)
}

variable "idle_timeout_in_minutes" {
    type    = string
    default = 4
}

variable "availability_zones" {
    type    = list(string)
    default = null
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}