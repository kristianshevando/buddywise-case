variable "azurerm_key_vault_name" {
    description = "The name of Key Vault."
    type = string
}

variable "location" {
    description = "The region of Key Vault."
    type = string
}

variable "azurerm_key_vault_resource_group_name" {
    description = "Azure Key Vault resource group name."
    type = string
}

variable "azurerm_key_vault_network_acls_default_action" {
    description = "Azure Key Vault default firewall action."
    type = string
    default = "Deny"
}

variable "common_tags" {
    type        = map(string)
    description = "Default set of tags."
    default     = null
}

variable "lock_azure_resources" {
    type = bool
    default = false
}

variable "buddywise_vpn_public_ip_list" {
    type        = list(string)
    description = "List of Buddywise VPN public IPs to access key vault."
    default     = ["208.127.184.216","208.127.184.234","165.1.205.48","165.1.205.49","134.238.6.143","34.98.162.248","134.238.5.181","34.98.172.99","137.83.215.125","137.83.215.124","34.100.116.241","34.98.221.220","134.238.19.74","34.98.217.211","134.238.19.73","34.98.217.24","134.238.11.97","34.98.219.92","134.238.11.96","34.98.219.96","134.238.9.77","34.98.223.115","134.238.9.76","34.98.223.116","165.1.240.186","165.1.240.187","134.238.82.209","34.103.253.2","134.238.82.193","34.103.253.217","134.238.87.251","34.103.167.51","134.238.87.250","34.103.167.54","134.238.116.196","34.103.169.38","134.238.116.195","34.103.169.39","134.238.133.157","34.103.190.188","134.238.133.156","34.103.190.189","134.238.94.219","34.103.138.143","134.238.94.192","34.103.138.57","15.236.93.130","165.1.219.64","165.1.219.63","35.181.41.203","208.127.50.49","208.127.123.54","134.238.171.100","34.103.84.103","134.238.168.211","34.99.124.73","208.127.247.42","208.127.242.104","208.127.245.14","208.127.245.140","165.1.212.12","165.1.212.13","165.1.214.12","165.1.214.120","165.1.248.49","165.1.248.50","134.238.109.227","34.103.177.50","134.238.109.226","34.103.177.51"]
}

variable "azurerm_key_vault_network_acls_allowed_list" {
    type        = list(string)
    description = "List of other IPs to access Azure Key Vault."
    default     = []
}