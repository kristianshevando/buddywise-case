provider "azurerm" {
  subscription_id = var.SUBSCRIPTION_ID
  client_id       = var.SPN_CLIENT_ID
  client_secret   = var.SPN_CLIENT_SECRET
  tenant_id       = var.TENANT_ID
  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
      purge_soft_delete_on_destroy    = true
    }
  }
}

data "azurerm_client_config" "current" {}


locals {
  infrastructure_tags = {
    code_version                  = var.infrastructure_code_version,
    environment_type              = var.PREFIX,
    automated_destroy             = var.AUTOMATED_DESTROY,
    terraform_code_package_number = var.TERRAFORM_CODE_PACKAGE_NUMBER,
    arm_subscription_id           = data.azurerm_client_config.current.subscription_id
  }

  common_tags = local.infrastructure_tags
}

module "azure_core_resource_group" {
  source   = "..//modules/azure-resource-group"
  providers = {
    azurerm = azurerm
  }
  for_each                      = { for cluster in var.azurerm_k8s_clusters: cluster.azure_k8s_cluster_index => cluster }

  azure_resource_group_name     = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${each.value.azure_k8s_cluster_index}"
  azure_resource_group_location = each.value.azure_k8s_cluster_location == "default" ? var.LOCATION : each.value.azure_k8s_cluster_location
  common_tags                   = local.common_tags
}

module "azure_core_key_vault" {
  source                      = "..//modules/azure-key-vault"
  providers = {
    azurerm = azurerm
  }
  for_each                                      = { for cluster in var.azurerm_k8s_clusters: cluster.azure_k8s_cluster_index => cluster }

  azurerm_key_vault_name                        = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${each.value.azure_k8s_cluster_index}"
  location                                      = each.value.azure_k8s_cluster_location == "default" ? var.LOCATION : each.value.azure_k8s_cluster_location
  azurerm_key_vault_resource_group_name         = module.azure_core_resource_group[each.key].resource_group_name
  azurerm_key_vault_network_acls_default_action = var.azurerm_key_vault_network_acls_default_action
  common_tags                                   = local.common_tags
}

module "azure_core_storage_account" {
  source                         = "..//modules/azure-storage-account"
  providers = {
    azurerm = azurerm
  }
  for_each                           = { for cluster in var.azurerm_k8s_clusters: cluster.azure_k8s_cluster_index => cluster }

  azure_storage_account_name         = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${each.value.azure_k8s_cluster_index}-4sf"
  azure_resource_group_name          = module.azure_core_resource_group[each.key].resource_group_name
  azure_storage_account_location     = each.value.azure_k8s_cluster_location == "default" ? var.LOCATION : each.value.azure_k8s_cluster_location
  azure_storage_account_tier         = each.value.azure_core_storage_account_tier
  azure_storage_account_type         = each.value.azure_core_storage_account_type
  azure_storage_account_access_tier  = each.value.azure_core_storage_account_access_tier
  azure_storage_account_kind         = each.value.azure_core_storage_account_kind
  azure_sa_firewall_enabled          = var.azure_sa_firewall_enabled
  result_to_key_vault                = false
}


module "azure_k8s_environment" {
  source                         = "..//modules/azure-kubernetes-service/azure-kubernetes-environment"
  providers = {
    azurerm = azurerm
    azuread = azuread
  }
  for_each                                                   = { for cluster in var.azurerm_k8s_clusters: cluster.azure_k8s_cluster_index => cluster }

  INFRASTRUCTURE_NAME                                        = var.INFRASTRUCTURE_NAME
  PREFIX                                                     = var.PREFIX
  SUFFIX                                                     = var.SUFFIX
  LOCATION                                                   = each.value.azure_k8s_cluster_location == "default" ? var.LOCATION : each.value.azure_k8s_cluster_location
  azurerm_k8s_cluster_index                                  = each.value.azure_k8s_cluster_index
  azurerm_k8s_resource_group_name                            = module.azure_core_resource_group[each.key].resource_group_name
  azurerm_k8s_resource_group_id                              = module.azure_core_resource_group[each.key].resource_group_id
  azurerm_k8s_vnet_address_space                             = each.value.azure_k8s_vnet_address_space
  azurerm_k8s_cluster_version                                = each.value.azure_k8s_cluster_version
  azurerm_k8s_private_cluster_enabled                        = each.value.azure_k8s_private_cluster_enabled
  azurerm_k8s_cluster_default_node_pool                      = each.value.azure_k8s_default_node_pool
  azurerm_k8s_cluster_auto_scaler_profile                    = each.value.azure_k8s_auto_scaler_profile
  azurerm_k8s_cluster_additional_node_pool                   = each.value.azure_k8s_additional_node_pool
  azurerm_k8s_private_cluster_network_profile                = each.value.azure_k8s_network_profile
  azurerm_k8s_private_cluster_admin_username                 = each.value.azure_k8s_cluster_admin_username
  azurerm_k8s_cluster_availability_zones                     = each.value.azure_k8s_cluster_availability_zones
  azurerm_k8s_cluster_nginx_ingress_access_mode              = each.value.azure_k8s_cluster_nginx_ingress_access_mode
  azurerm_k8s_cluster_nginx_ingress_fqdn 	                   = replace(each.value.azure_k8s_cluster_nginx_ingress_fqdn, "*", "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${each.value.azure_k8s_cluster_index}")
  azurerm_k8s_cluster_nginx_ingress_pls_enabled              = each.value.azure_k8s_cluster_nginx_ingress_pls_enabled
  azurerm_k8s_cluster_nginx_ingress_public_dns_creation_mode = each.value.azure_k8s_cluster_nginx_ingress_public_dns_creation_mode
  azurerm_k8s_ingress_public_ip                              = each.value.azure_k8s_ingress_public_ip
  azurerm_k8s_ingress_public_ip_resource_group_id            = each.value.azure_k8s_ingress_public_ip_resource_group_id
  azurerm_k8s_cluster_nginx_ingress_whitelist                = each.value.azure_k8s_cluster_nginx_ingress_whitelist
  azurerm_k8s_cluster_sku_tier                               = each.value.azure_k8s_cluster_sku_tier
  azurerm_k8s_cluster_azure_policy_enabled                   = each.value.azure_k8s_cluster_azure_policy_enabled
  azurerm_k8s_cluster_local_account_disabled                 = each.value.azure_k8s_cluster_local_account_disabled
  azurerm_k8s_cluster_role_based_access_control_enabled      = each.value.azure_k8s_cluster_role_based_access_control_enabled
  azurerm_k8s_cluster_admin_group_object_ids                 = each.value.azure_k8s_cluster_admin_group_object_ids
  azurerm_k8s_cluster_azure_rbac_enabled                     = each.value.azure_k8s_cluster_azure_rbac_enabled
  azurerm_k8s_service_vnet_address_space                     = each.value.azure_k8s_service_vnet_address_space
  azurerm_k8s_service_oidc_issuer_enabled                    = each.value.azure_k8s_cluster_oidc_issuer_enabled
  azurerm_k8s_service_workload_identity_enabled              = each.value.azure_k8s_cluster_workload_identity_enabled
  azurerm_k8s_egress_allowed_destinations                    = each.value.azure_k8s_egress_allowed_destinations
  azurerm_core_storage_account_id                            = module.azure_core_storage_account[each.key].storage_account_id
  azurerm_core_key_vault_id                                  = module.azure_core_key_vault[each.key].azurerm_key_vault_id
  azurerm_nsg_rules                                          = each.value.azure_nsg_rules
  additional_key_vault_secrets                               = try(each.value.additional_key_vault_secrets, [])
  common_tags                                                = local.common_tags
}

module "azure_key_vault_additional_secrets" {
  source                      = "..//modules/azure-key-vault-secret"
  providers = {
    azurerm = azurerm
  }
  for_each                     = { for cluster in var.azurerm_k8s_clusters: cluster.azure_k8s_cluster_index => cluster }

  additional_key_vault_secrets = [
                                  {"key_name" = "azure-vault-sa-backup-enabled", "key_value" = each.value.azure_vault_sa_backup_enabled, "content_type" = "Common"},
                                  {"key_name" = "storage-account-blob-endpoint", "key_value" = module.azure_core_storage_account[each.key].primary_blob_endpoint, "content_type" = "Common"},
                                  {"key_name" = "storage-account-name", "key_value" = module.azure_core_storage_account[each.key].storage_account_name, "content_type" = "Common"},
                                  {"key_name" = "storage-account-primary-access-key", "key_value" = module.azure_core_storage_account[each.key].primary_access_key, "content_type" = "Sensitive"},
                                  {"key_name" = "resource-group-name", "key_value" = module.azure_core_resource_group[each.key].resource_group_name, "content_type" = "Common"},
                                  {"key_name" = "database-maximum-size-bytes", "key_value" = each.value.azure_sql_database_maximum_size_bytes, "content_type" = "Common"}
                                 ]
  azure_key_vault_id           = module.azure_core_key_vault[each.key].azurerm_key_vault_id
}