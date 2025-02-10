data "azurerm_client_config" "current" {}

module "azure_core_virtual_network" {
  source                      = "..//..//azure-virtual-network"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name             = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${var.azurerm_k8s_cluster_index}"
  azure_vnet_location         = var.LOCATION
  azure_resource_group_name   = var.azurerm_k8s_resource_group_name
  azure_vnet_address_space    = flatten([ var.azurerm_k8s_vnet_address_space, var.azurerm_k8s_service_vnet_address_space ])
  azure_key_vault_id          = var.azurerm_core_key_vault_id
  common_tags                 = var.common_tags
}

module "azure_k8s_network_node_subnet" {
  source                      = "..//..//azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_core_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = var.azurerm_k8s_resource_group_name
  azure_subnet_name                              = "k8s-nodes"
  azure_subnet_address_prefix                    = cidrsubnet(element(var.azurerm_k8s_vnet_address_space, 0), 1, 0)
  azure_key_vault_id                             = var.azurerm_core_key_vault_id
  enforce_private_link_endpoint_network_policies = true
  create_azure_network_security_group            = false
  azure_vnet_location                            = var.LOCATION
}

module "azure_k8s_network_pod_subnet" {
  source                      = "..//..//azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_core_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = var.azurerm_k8s_resource_group_name
  azure_subnet_name                              = "k8s-pods"
  azure_subnet_address_prefix                    = cidrsubnet(element(var.azurerm_k8s_vnet_address_space, 0), 1, 1)
  azure_key_vault_id                             = var.azurerm_core_key_vault_id
  enforce_private_link_endpoint_network_policies = false
  create_azure_network_security_group            = false
  azure_vnet_location                            = var.LOCATION
}

module "azure_private_link_network_subnet" {
  source                      = "..//..//azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_core_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = var.azurerm_k8s_resource_group_name
  azure_subnet_name                              = "private-link"
  azure_subnet_address_prefix                    = cidrsubnet(element(var.azurerm_k8s_service_vnet_address_space, 0), 4, 0)
  azure_key_vault_id                             = var.azurerm_core_key_vault_id
  enforce_private_link_endpoint_network_policies = true
  create_azure_network_security_group            = false
  azure_vnet_location                            = var.LOCATION
}

module "azure_k8s_ingress_network_subnet" {
  source                      = "..//..//azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }
  count                                          = var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-s2s" || var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-afd" ? 1 : 0

  azure_vnet_name                                = module.azure_core_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = var.azurerm_k8s_resource_group_name
  azure_subnet_name                              = "ingress-lb"
  azure_subnet_address_prefix                    = cidrsubnet(element(var.azurerm_k8s_service_vnet_address_space, 0), 4, 1)
  azure_key_vault_id                             = var.azurerm_core_key_vault_id
  enforce_private_link_endpoint_network_policies = false
  create_azure_network_security_group            = false
  azure_vnet_location                            = var.LOCATION
}

module "azurerm_user_assigned_identity_k8s" {
  source   = "..//..//azure-user-assigned-identity"
  providers = {
    azurerm = azurerm
  }

  azurerm_user_assigned_identity_name = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${var.azurerm_k8s_cluster_index}"
  azurerm_resource_group_name         = var.azurerm_k8s_resource_group_name
  location                            = var.LOCATION
  common_tags                         = var.common_tags
}

module "azurerm_user_assigned_identity_k8s_kubelet" {
  source   = "..//..//azure-user-assigned-identity"
  providers = {
    azurerm = azurerm
  }

  azurerm_user_assigned_identity_name = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${var.azurerm_k8s_cluster_index}-kubelet"
  azurerm_resource_group_name         = var.azurerm_k8s_resource_group_name
  location                            = var.LOCATION
  common_tags                         = var.common_tags
}

module "azurerm_user_assigned_identity_k8s_egress_controller" {
  source   = "..//..//azure-user-assigned-identity"
  providers = {
    azurerm = azurerm
  }
  count                               = try(sort(var.azurerm_k8s_egress_allowed_destinations), false) != false && length(var.azurerm_k8s_egress_allowed_destinations) > 0 ? 1 : 0

  azurerm_user_assigned_identity_name = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${var.azurerm_k8s_cluster_index}-ec"
  azurerm_resource_group_name         = var.azurerm_k8s_resource_group_name
  location                            = var.LOCATION
  common_tags                         = var.common_tags
}

module "azure_custom_role_files_share_pvc" {
  source = "..//..//azure-role-definition"
  providers = {
    azurerm = azurerm
  }

  azurerm_role_definition_name        = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.azurerm_k8s_cluster_index}-pvc"
  azurerm_role_definition_description = "This role can be used to create file share pvc."
  assignable_scopes                   = [ var.azurerm_core_storage_account_id ]
  permissions_actions                 = [
                                         "Microsoft.Storage/storageAccounts/fileServices/shares/read",
                                         "Microsoft.Storage/storageAccounts/fileServices/shares/write",
                                         "Microsoft.Storage/storageAccounts/fileServices/shares/delete",
                                         "Microsoft.Storage/storageAccounts/listKeys/action"
                                        ]
}

module "azure_role_assignment_k8s_vnet" {
  source = "..//..//azure-role-assignment"
  providers = {
    azurerm = azurerm
  }

  azurerm_role_assignment_scope = module.azure_core_virtual_network.azurerm_virtual_network_id
  role_definition_resource_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
  azurerm_principal_id          = module.azurerm_user_assigned_identity_k8s.azurerm_user_assigned_identity_principal_id
}

module "azure_role_assignment_k8s_public_ip_nsg_ingress" {
  source = "..//..//azure-role-assignment"
  providers = {
    azurerm = azurerm
  }
  count                         = var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-s2s" || var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-afd" && var.azurerm_k8s_cluster_nginx_ingress_pls_enabled == "true" ? 1 : 0

  azurerm_role_assignment_scope = module.azure_k8s_ingress_nsg.azurerm_network_security_group_id
  role_definition_resource_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
  azurerm_principal_id          = module.azurerm_user_assigned_identity_k8s.azurerm_user_assigned_identity_principal_id
}

module "azure_role_assignment_k8s_kubelet" {
  source = "..//..//azure-role-assignment"
  providers = {
    azurerm = azurerm
  }

  azurerm_role_assignment_scope = module.azurerm_user_assigned_identity_k8s_kubelet.azurerm_user_assigned_identity_id
  role_definition_resource_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/f1a07417-d97a-45cb-824c-7a7467783830"
  azurerm_principal_id          = module.azurerm_user_assigned_identity_k8s.azurerm_user_assigned_identity_principal_id
}

module "azurerm_federated_identity_credential_egress_controller" {
  source   = "..//..//azure-aad/azurerm-federated-identity-credential"
  providers = {
    azuread = azuread
  }
  count                                          = try(sort(var.azurerm_k8s_egress_allowed_destinations), false) != false && length(var.azurerm_k8s_egress_allowed_destinations) > 0 ? 1 : 0

  azuread_federated_identity_parent_id           = module.azurerm_user_assigned_identity_k8s_egress_controller[0].azurerm_user_assigned_identity_id
  azuread_federated_identity_name                = module.azurerm_user_assigned_identity_k8s_egress_controller[0].azurerm_user_assigned_identity_name
  azuread_federated_identity_resource_group_name = var.azurerm_k8s_resource_group_name
  azuread_federated_identity_audience            = ["api://AzureADTokenExchange"]
  azuread_federated_identity_issuer              = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_oidc_issuer_url
  azuread_federated_identity_subject             = "system:serviceaccount:egresscontroller:egresscontroller"
}

module "azure_core_key_vault_access_policy_egress_controller" {
  source   = "..//..//azure-key-vault-access-policy"
  providers = {
    azurerm = azurerm
  }
  count                                = try(sort(var.azurerm_k8s_egress_allowed_destinations), false) != false && length(var.azurerm_k8s_egress_allowed_destinations) > 0 ? 1 : 0

  azurerm_key_vault_id                 = var.azurerm_core_key_vault_id
  azurerm_kv_access_policy_permissions = ["Get", "List"]
  azurerm_aad_object_ids               = module.azurerm_user_assigned_identity_k8s_egress_controller[0].azurerm_user_assigned_identity_principal_id
}

module "azure_role_assignment_egress_controller_private_dns_zone" {
  source = "..//..//azure-role-assignment"
  providers = {
    azurerm = azurerm
  }
  count                         = try(sort(var.azurerm_k8s_egress_allowed_destinations), false) != false && length(var.azurerm_k8s_egress_allowed_destinations) > 0 ? 1 : 0

  azurerm_role_assignment_scope = var.azurerm_k8s_resource_group_id
  role_definition_resource_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/b12aa53e-6015-4669-85d0-8515ebb3ae7f"
  azurerm_principal_id          = module.azurerm_user_assigned_identity_k8s_egress_controller[0].azurerm_user_assigned_identity_principal_id
}

module "azure_kubernetes_cluster" {
  source                         = "..//..//azure-kubernetes-service/azure-kubernetes-cluster"
  providers = {
    azurerm = azurerm
  }

  azurerm_kubernetes_cluster_name                              = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${var.azurerm_k8s_cluster_index}"
  location                                                     = var.LOCATION
  azurerm_kubernetes_cluster_resource_group_name               = var.azurerm_k8s_resource_group_name
  azurerm_kubernetes_cluster_node_resource_group               = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-${var.azurerm_k8s_cluster_index}-node"
  azurerm_kubernetes_cluster_version                           = var.azurerm_k8s_cluster_version
  azurerm_kubernetes_private_cluster_enabled                   = var.azurerm_k8s_private_cluster_enabled
  azurerm_kubernetes_cluster_default_node_pool                 = var.azurerm_k8s_cluster_default_node_pool
  azurerm_kubernetes_cluster_availability_zones                = var.azurerm_k8s_cluster_availability_zones
  azurerm_kubernetes_cluster_default_node_pool_vnet_subnet_id  = module.azure_k8s_network_node_subnet.azurerm_subnet_id
  azurerm_kubernetes_cluster_auto_scaler_profile               = var.azurerm_k8s_cluster_auto_scaler_profile
  azurerm_kubernetes_cluster_network_profile                   = var.azurerm_k8s_private_cluster_network_profile
  azurerm_kubernetes_cluster_windows_node_pool                 = try(contains([ for value in var.azurerm_k8s_cluster_additional_node_pool.*.os_type: lower(value) ], "windows"), false)
  azurerm_user_assigned_identity_ids                           = [ module.azurerm_user_assigned_identity_k8s.azurerm_user_assigned_identity_id ]
  azurerm_kubelet_user_assigned_identity_client_id             = module.azurerm_user_assigned_identity_k8s_kubelet.azurerm_user_assigned_identity_client_id
  azurerm_kubelet_user_assigned_identity_object_id             = module.azurerm_user_assigned_identity_k8s_kubelet.azurerm_user_assigned_identity_principal_id
  azurerm_kubelet_user_assigned_identity_id                    = module.azurerm_user_assigned_identity_k8s_kubelet.azurerm_user_assigned_identity_id
  azurerm_kubernetes_cluster_oidc_issuer_enabled               = var.azurerm_k8s_service_oidc_issuer_enabled
  azurerm_kubernetes_cluster_workload_identity_enabled         = var.azurerm_k8s_service_workload_identity_enabled
  azurerm_kubernetes_cluster_admin_username                    = var.azurerm_k8s_private_cluster_admin_username
  azurerm_kubernetes_cluster_sku_tier                          = var.azurerm_k8s_cluster_sku_tier
  azurerm_kubernetes_cluster_azure_policy_enabled              = var.azurerm_k8s_cluster_azure_policy_enabled
  azurerm_kubernetes_cluster_local_account_disabled            = var.azurerm_k8s_cluster_local_account_disabled
  azurerm_kubernetes_cluster_role_based_access_control_enabled = var.azurerm_k8s_cluster_role_based_access_control_enabled
  azurerm_kubernetes_cluster_admin_group_object_ids            = var.azurerm_k8s_cluster_admin_group_object_ids
  azurerm_kubernetes_cluster_azure_rbac_enabled                = var.azurerm_k8s_cluster_azure_rbac_enabled
  azurerm_key_vault_id                                         = var.azurerm_core_key_vault_id
  common_tags                                                  = var.common_tags
}

module "azure_kubernetes_cluster_additional_node_pool" {
  source                         = "..//..//azure-kubernetes-service/azure-kubernetes-cluser-node-pool"
  providers = {
    azurerm = azurerm
  }
  for_each                                            = { for pool in var.azurerm_k8s_cluster_additional_node_pool: pool.name => pool }

  azurerm_kubernetes_cluster_id                       = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_id
  azurerm_kubernetes_cluster_node_pool_vnet_subnet_id = module.azure_k8s_network_pod_subnet.azurerm_subnet_id
  azurerm_kubernetes_cluster_additional_node_pool     = each.value
  azurerm_kubernetes_cluster_availability_zones       = var.azurerm_k8s_cluster_availability_zones
  depends_on                                          = [module.azure_kubernetes_cluster]
}

module "azure_k8s_ingress_nsg" {
  source                      = "..//..//azure-network-security-group"
  providers = {
    azurerm = azurerm
  }

  azurerm_network_security_group_name = "ingress-${var.azurerm_k8s_cluster_index}"
  azurerm_resource_group_name         = var.azurerm_k8s_resource_group_name
  location                            = var.LOCATION
  common_tags                         = var.common_tags
}

/* resource "azurerm_network_security_rule" "ingress_default_inbound_deny" {

  name                         = "deny_inbound_all"
  priority                     = 1000
  direction                    = "Inbound"
  access                       = "Deny"
  protocol                     = "*"
  source_port_range            = "*"
  destination_port_range       = "*"
  source_address_prefix        = "*"
  destination_address_prefix   = "*"
  resource_group_name          = var.azurerm_k8s_resource_group_name
  network_security_group_name  = module.azure_k8s_ingress_nsg.azurerm_network_security_group_name
} */

module "azure_k8s_node_subnet_nsg_association" {
  source                      = "..//..//azure-network-security-group-association"
  providers = {
    azurerm = azurerm
  }

  azurerm_subnet_id         = module.azure_k8s_network_node_subnet.azurerm_subnet_id
  network_security_group_id = module.azure_k8s_ingress_nsg.azurerm_network_security_group_id
}

module "azure_k8s_pod_subnet_nsg_association" {
  source                      = "..//..//azure-network-security-group-association"
  providers = {
    azurerm = azurerm
  }

  azurerm_subnet_id         = module.azure_k8s_network_pod_subnet.azurerm_subnet_id
  network_security_group_id = module.azure_k8s_ingress_nsg.azurerm_network_security_group_id
}

module "azure_k8s_ingress_subnet_nsg_association" {
  source                      = "..//..//azure-network-security-group-association"
  providers = {
    azurerm = azurerm
  }
  count                     = var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-s2s" || var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-afd" ? 1 : 0

  azurerm_subnet_id         = module.azure_k8s_ingress_network_subnet[0].azurerm_subnet_id
  network_security_group_id = module.azure_k8s_ingress_nsg.azurerm_network_security_group_id
}

module "azure_key_vault_additional_secrets_core" {
  source                      = "..//..//azure-key-vault-secret"
  providers = {
    azurerm = azurerm
  }

  additional_key_vault_secrets = [
                                  {"key_name" = "kubernetes-cluster-node-resource-group-name", "key_value" = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_node_resource_group_name, "content_type" = "Common"},
                                  {"key_name" = "kubernetes-cluster-resource-group-name", "key_value" = var.azurerm_k8s_resource_group_name, "content_type" = "Common"},
				                          {"key_name" = "kubernetes-cluster-name", "key_value" = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_name, "content_type" = "Common"},
                                  {"key_name" = "kubernetes-cluster-nginx-ingress-access-mode", "key_value" = var.azurerm_k8s_cluster_nginx_ingress_access_mode, "content_type" = "Common"},
                                  {"key_name" = "kubernetes-cluster-nginx-ingress-private-ip-address", "key_value" = "${ var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-s2s" || var.azurerm_k8s_cluster_nginx_ingress_access_mode == "private-afd" ? cidrhost(module.azure_k8s_ingress_network_subnet[0].azurerm_subnet_address_prefixes, 5) : ""}", "content_type" = "Common"},
                                  {"key_name" = "kubernetes-cluster-nginx-ingress-fqdn", "key_value" = var.azurerm_k8s_cluster_nginx_ingress_fqdn, "content_type" = "Common"},
                                  {"key_name" = "kubernetes-cluster-nginx-ingress-pls-enabled", "key_value" = var.azurerm_k8s_cluster_nginx_ingress_pls_enabled, "content_type" = "Common"},
                                  {"key_name" = "kubernetes-cluster-outbound-public-ip-address", "key_value" = module.azure_kubernetes_cluster.azurerm_kubernetes_cluster_outbound_public_ip, "content_type" = "Common"},
                                  {"key_name" = "core-key-vault-id", "key_value" = var.azurerm_core_key_vault_id, "content_type" = "Common"},
                                  {"key_name" = "vnet-name", "key_value" = module.azure_core_virtual_network.azurerm_virtual_network_name, "content_type" = "Common"},
                                  try(sort(flatten([var.azurerm_k8s_egress_allowed_destinations])), false) != false && length(flatten([var.azurerm_k8s_egress_allowed_destinations])) > 0 ? {"key_name" = "k8s-egress-allowed-destinations", "key_value" = join(",", var.azurerm_k8s_egress_allowed_destinations), "content_type" = "Common"} : {"key_name" = null, "key_value" = null, "content_type" = "Common"},
                                  try(sort(flatten([var.azurerm_k8s_egress_allowed_destinations])), false) != false && length(flatten([var.azurerm_k8s_egress_allowed_destinations])) > 0 ? {"key_name" = "egress-controller-identity-client-id", "key_value" = module.azurerm_user_assigned_identity_k8s_egress_controller[0].azurerm_user_assigned_identity_client_id, "content_type" = "Common"} : {"key_name" = null, "key_value" = null, "content_type" = "Common"}
                                 ]
  azure_key_vault_id           = var.azurerm_core_key_vault_id
}

module "azure_key_vault_additional_secrets_from_tfvar" {
  source = "..//..//azure-key-vault-secret"
  providers = {
    azurerm = azurerm
  }

  additional_key_vault_secrets = var.additional_key_vault_secrets
  azure_key_vault_id           = var.azurerm_core_key_vault_id
}