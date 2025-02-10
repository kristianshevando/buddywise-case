variable "dns_record_name" {
    description = "The name of DNS record."
    type = string
}

variable "azure_private_dns_zone_name" {
    description = "The name of private DNS zone."
    type = string
}

variable "resource_group_name" {
    description = "Private DNS zone resource group name."
    type = string
}

variable "dns_record_ttl" {
    description = "Default value for TTL of DNS records."
    type = string
    default = "300"
}

variable "record_value" {
    description = "Value of DNS record."
    type = list(string)
}

variable "private_dns_record_type" {
    description = "Type of Private DNS record."
    type = string
    default = "A"
}