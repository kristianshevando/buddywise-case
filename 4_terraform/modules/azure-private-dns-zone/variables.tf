variable "azure_private_dns_zones" {
    description = "The name of private DNS zone."
    type = map(string)
}

variable "resource_group_name" {
    description = "Private DNS zone resource group name."
    type = string
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}