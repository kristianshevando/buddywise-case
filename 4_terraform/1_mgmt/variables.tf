variable "INFRASTRUCTURE_NAME" {
  type        = string
  description = "The name for the resources created in the specified Azure Resource Group"
  validation {
    condition     = length(var.INFRASTRUCTURE_NAME) <= 14
    error_message = "Infrastructure name should be no more 14 character long."
  }
}

variable "PREFIX" {
  type = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "SUFFIX" {
  type        = string
  description = "The suffix for the resources created in the specified Azure Resource Group"
}

variable "LOCATION" {
  type        = string
  description = "The location for the deployment"
}

variable "AUTOMATED_DESTROY" {
  type        = string
  description = "Enable destroy of infrastructure from the pipeline."
  default     = "disabled"
}

variable "TERRAFORM_CODE_PACKAGE_NUMBER" {
  type        = string
  description = "Version of Terraform IaC package."
}

variable "azure_vnet_address_space" {
  type        = list(string)
  description = "Address space for infrastructure."
}

variable "public_ip_sku_bastion_host" {
  type        = string
  description = "SKU of public ip"
}

variable "public_ip_allocation_method_bastion_host" {
  type        = string
  description = "Allocation method of Bastion public IP."
}

variable "azure_mgmt_components" {
  description = "List of management components within management resource group."
}

variable "azure_private_dns_zones" {
  type = list(map(string))
  description = "List of private dns zones for private links."
}

variable "azure_bastion_host_enabled" {
  type = bool
  description = "Manage process of provision for Azure Bastion host."
  default = true
}

variable "azurerm_key_vault_network_acls_default_action" {
  description = "Create default deny rule in Azure Key Vault firewall."
  type = string
  default = "Deny"
}

variable "platform_fault_domain_count" {
  description = "Count of fault domain for availability set."
  type = number
  default = 2
}

variable "platform_update_domain_count" {
  description = "Count of update domain for availability set."
  type = number
  default = 5
}

variable "azure_sa_firewall_enabled" {
  type = bool
  default = true
  description = "Create default deny rule in Azure Storage Account firewall."
}

variable "infrastructure_code_version" {
  type        = string
  description = "Version of IaC code. Connected to Managed Services repo tags."
  default     = null
}

variable "azure_dns_relay_enabled" {
  type = bool
  description = "Manage process of provision DNS relay for P2S connections."
  default = true
}

variable "azure_subnet_additional_bitmask" {
  description = "Additional bitmask to calculate size of Virtual Network subnet."
  type = number
  default = 4
}

variable "AZDO_PERSONAL_ACCESS_TOKEN" {
  description = "PAT to access to Azure DevOps organization."
  type = string
  default = null
}

variable "azure_private_remote_network_access" {
  description = "List of private remote network access components."
  default = []
}

variable "azure_vault_sa_backup_enabled" {
  type = bool
  description = "Manage process of provision components for Innovator Vault backup."
  default = true
}

variable "SPN_CLIENT_ID" {
  type      = string
  default   = null
}

variable "SPN_CLIENT_SECRET" {
  type      = string
  sensitive = true
  default   = null
}

variable "TENANT_ID" {
  type      = string
  default   = null
}

variable "SUBSCRIPTION_ID" {
  type      = string
  default   = null
}

variable "ACR_RESOURCE_GROUP_NAME" {
  type      = string
  default   = null
}

variable "ACR_FQDN" {
  type      = string
  default   = null
}

variable "azurerm_k8s_clusters" {
  description = "List of k8s clusters configuration data."
  default = null
}

variable "SENDGRID_API_KEY_MANAGE_SUBUSERS" {
  description = "Api key to manage subusers."
  type        = string
  sensitive   = true
  default     = null
}

variable "innovator_users" {
  description = "List of users to add in key vault with dynamic generated password."
  type        = list(string)
  default     = ["innovator-root", "innovator-admin", "innovator-vadmin"]
}