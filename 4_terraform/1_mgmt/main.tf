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
data "azurerm_subscription" "current" {}

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

module "azure_mgmt_resource_group" {
  source   = "..//modules/azure-resource-group"
  providers = {
    azurerm = azurerm
  }

  azure_resource_group_name     = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  azure_resource_group_location = var.LOCATION
  common_tags                   = local.common_tags
}

module "azure_mgmt_key_vault" {
  source                      = "..//modules/azure-key-vault"
  providers = {
    azurerm = azurerm
  }

  azurerm_key_vault_name                        = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  location                                      = var.LOCATION
  azurerm_key_vault_resource_group_name         = module.azure_mgmt_resource_group.resource_group_name
  azurerm_key_vault_network_acls_default_action = var.azurerm_key_vault_network_acls_default_action
  common_tags                                   = local.common_tags
}

module "azure_mgmt_key_vault_mgmt_vm" {
  source                      = "..//modules/azure-key-vault"
  providers = {
    azurerm = azurerm
  }

  azurerm_key_vault_name                        = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-vm"
  location                                      = var.LOCATION
  azurerm_key_vault_resource_group_name         = module.azure_mgmt_resource_group.resource_group_name
  azurerm_key_vault_network_acls_default_action = var.azurerm_key_vault_network_acls_default_action
  common_tags                                   = local.common_tags
}

module "azure_private_link_mgmt_vm_key_vault" {
  source                         = "..//modules/azure-private-link"
  providers = {
    azurerm = azurerm
  }

  private_endpoint_name              = "${module.azure_mgmt_key_vault_mgmt_vm.azurerm_key_vault_name}-kv"
  location                           = var.LOCATION
  resource_group_name                = module.azure_mgmt_resource_group.resource_group_name
  azurerm_private_endpoint_subnet_id = module.azure_mgmt_private_link_network_subnet.azurerm_subnet_id
  azurerm_resource_id                = module.azure_mgmt_key_vault_mgmt_vm.azurerm_key_vault_id
  subresource_names                  = "Vault"
  azurerm_private_dns_zone_id        = [lookup(element(module.azure_private_dns_zone["Vault"].azure_private_dns_zones, 0), "zone_id")]
  common_tags                        = local.common_tags
  depends_on                         = [module.azure_mgmt_private_link_network_subnet, module.azure_mgmt_bastion_host]
}

module "azure_mgmt_public_ip_bastion" {
  source                      = "..//modules/azure-public-ip"
  providers = {
      azurerm = azurerm
  }
  count                = var.azure_bastion_host_enabled ? 1 : 0

  name                 = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-bastion"
  location             = var.LOCATION
  resource_group_name  = module.azure_mgmt_resource_group.resource_group_name
  allocation_method    = var.public_ip_allocation_method_bastion_host
  sku                  = var.public_ip_sku_bastion_host
  domain_name_label    = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}-bastion"
  azure_key_vault_id   = module.azure_mgmt_key_vault.azurerm_key_vault_id
  lock_azure_resources = false
  common_tags          = local.common_tags
}

module "azure_mgmt_virtual_network" {
  source                      = "..//modules/azure-virtual-network"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name           = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  azure_vnet_location       = var.LOCATION
  azure_resource_group_name = module.azure_mgmt_resource_group.resource_group_name
  azure_vnet_address_space  = var.azure_vnet_address_space
  azure_key_vault_id        = module.azure_mgmt_key_vault.azurerm_key_vault_id
  common_tags               = local.common_tags
}

module "azure_private_dns_zone" {
  source                      = "..//modules/azure-private-dns-zone"
  providers = {
    azurerm = azurerm
  }
  for_each                = {for zone in var.azure_private_dns_zones: zone.resource_name => zone}

  resource_group_name     = module.azure_mgmt_resource_group.resource_group_name
  azure_private_dns_zones = each.value
  common_tags             = local.common_tags
}

module "azure_private_dns_zone_virtual_network_link" {
  source                      = "..//modules/azure-private-dns-zone-virtual-network-link"
  providers = {
    azurerm = azurerm
  }
  for_each                    = {for zone in var.azure_private_dns_zones: zone.resource_name => zone}

  virtual_network_link_name   = module.azure_mgmt_virtual_network.azurerm_virtual_network_name
  resource_group_name         = module.azure_mgmt_resource_group.resource_group_name
  azure_private_dns_zones_ids = lookup(element(module.azure_private_dns_zone[each.key].azure_private_dns_zones, 0), "zone_id")
  virtual_network_id          = module.azure_mgmt_virtual_network.azurerm_virtual_network_id
  common_tags                 = local.common_tags
  depends_on                  = [module.azure_private_dns_zone]
}

module "azure_mgmt_virtual_network_subnet" {
  source                      = "..//modules/azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }
  for_each                                       = {for subnet in var.azure_mgmt_components: subnet.instance_name => subnet if subnet.instance_type != "undefined" }

  azure_vnet_name                                = module.azure_mgmt_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = module.azure_mgmt_resource_group.resource_group_name
  azure_subnet_name                              = each.value.instance_name
  azure_subnet_address_prefix                    = cidrsubnet(element(var.azure_vnet_address_space, 0), var.azure_subnet_additional_bitmask, each.value.subnet_index)
  azure_key_vault_id                             = module.azure_mgmt_key_vault.azurerm_key_vault_id
  enforce_private_link_endpoint_network_policies = false
  create_azure_network_security_group            = true
  azure_vnet_location                            = var.LOCATION
  common_tags                                    = local.common_tags
}

module "azure_mgmt_bastion_virtual_network_subnet" {
  source                      = "..//modules/azure-virtual-network-subnet"
    providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_mgmt_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = module.azure_mgmt_resource_group.resource_group_name
  azure_subnet_name                              = "AzureBastionSubnet"
  azure_subnet_address_prefix                    = cidrsubnet(element(module.azure_mgmt_virtual_network.azurerm_virtual_network_address_space, 0), 2, 0)
  azure_key_vault_id                             = module.azure_mgmt_key_vault.azurerm_key_vault_id
  enforce_private_link_endpoint_network_policies = false
  azure_vnet_location                            = var.LOCATION
  azure_nsg_rules                                = [for instance in var.azure_mgmt_components: instance.azure_nsg_rules if instance.instance_name == "AzureBastionSubnet"][0]
  create_azure_network_security_group            = true
  common_tags                                    = local.common_tags
}

module "azure_mgmt_private_link_network_subnet" {
  source                      = "..//modules/azure-virtual-network-subnet"
  providers = {
    azurerm = azurerm
  }

  azure_vnet_name                                = module.azure_mgmt_virtual_network.azurerm_virtual_network_name
  azure_resource_group_name                      = module.azure_mgmt_resource_group.resource_group_name
  azure_subnet_name                              = "private-link-mgmt"
  azure_subnet_address_prefix                    = cidrsubnet(element(module.azure_mgmt_virtual_network.azurerm_virtual_network_address_space, 0), var.azure_subnet_additional_bitmask, 4)
  azure_key_vault_id                             = module.azure_mgmt_key_vault.azurerm_key_vault_id
  enforce_private_link_endpoint_network_policies = true
  azure_vnet_location                            = var.LOCATION
  create_azure_network_security_group            = false
}

module "azure_private_link_mgmt_key_vault" {
  source                         = "..//modules/azure-private-link"
  providers = {
    azurerm = azurerm
  }

  private_endpoint_name              = "${module.azure_mgmt_key_vault.azurerm_key_vault_name}-kv"
  location                           = var.LOCATION
  resource_group_name                = module.azure_mgmt_resource_group.resource_group_name
  azurerm_private_endpoint_subnet_id = module.azure_mgmt_private_link_network_subnet.azurerm_subnet_id
  azurerm_resource_id                = module.azure_mgmt_key_vault.azurerm_key_vault_id
  subresource_names                  = "Vault"
  azurerm_private_dns_zone_id        = [lookup(element(module.azure_private_dns_zone["Vault"].azure_private_dns_zones, 0), "zone_id")]
  common_tags                        = local.common_tags
  depends_on                         = [module.azure_mgmt_private_link_network_subnet, module.azure_mgmt_bastion_host]
}

module "azure_mgmt_bastion_host" {
  source                      = "..//modules/azure-bastion-host"
    providers = {
    azurerm = azurerm
  }

  count                     = var.azure_bastion_host_enabled ? 1 : 0
  bastion_host_name         = "${var.INFRASTRUCTURE_NAME}-${var.PREFIX}-${var.SUFFIX}"
  location                  = var.LOCATION
  azure_resource_group_name = module.azure_mgmt_resource_group.resource_group_name
  azure_subnet_id           = module.azure_mgmt_bastion_virtual_network_subnet.azurerm_subnet_id
  public_ip_address_id      = module.azure_mgmt_public_ip_bastion[0].public_ip_id
  common_tags               = local.common_tags
  depends_on                = [module.azure_mgmt_virtual_network_subnet, module.azure_mgmt_private_link_network_subnet, module.azure_mgmt_bastion_virtual_network_subnet]
}

module "azure_private_remote_network_access" {
  source = "..//modules/azure-private-remote-network-access"
  providers = {
    azurerm = azurerm
  }
  for_each                                                         = { for instance in var.azure_private_remote_network_access : instance.azure_virtual_network_gateway_region_index => instance }

  infrastructure_name                                              = var.INFRASTRUCTURE_NAME
  infrastructure_prefix                                            = var.PREFIX
  azure_virtual_network_gateway_enabled                            = each.value.azure_virtual_network_gateway_enabled
  azure_virtual_network_gateway_vnet_address_space                 = each.value.azure_virtual_network_gateway_vnet_address_space
  azure_virtual_network_gateway_public_ip_sku                      = each.value.azure_virtual_network_gateway_public_ip_sku
  azure_virtual_network_gateway_public_ip_allocation_method        = each.value.azure_virtual_network_gateway_public_ip_allocation_method
  azure_virtual_network_gateway_availability_zones                 = each.value.azure_virtual_network_gateway_availability_zones
  azure_virtual_network_gateway_subnet_additional_bitmask          = each.value.azure_virtual_network_gateway_subnet_additional_bitmask
  azure_virtual_network_private_endpoint_subnet_additional_bitmask = each.value.azure_virtual_network_private_endpoint_subnet_additional_bitmask
  azure_virtual_network_gateway_type                               = each.value.azure_virtual_network_gateway_type
  azure_virtual_network_gateway_vpn_type                           = each.value.azure_virtual_network_gateway_vpn_type
  azure_virtual_network_gateway_active_active                      = each.value.azure_virtual_network_gateway_active_active
  azure_virtual_network_gateway_enable_bgp                         = each.value.azure_virtual_network_gateway_enable_bgp
  azure_virtual_network_gateway_sku                                = each.value.azure_virtual_network_gateway_sku
  azure_virtual_network_gateway_generation                         = each.value.azure_virtual_network_gateway_generation
  azure_virtual_network_gateway_vnet_dns_servers                   = var.azure_dns_relay_enabled ? [for instance in flatten([values(module.azure_mgmt_virtual_machine)[*].private_ip_addresses]) : instance.ip_address if split("-", instance.instance_name)[0] == "dns"] : null
  azure_virtual_network_gateway_region                             = each.value.azure_virtual_network_gateway_region
  azure_virtual_network_gateway_region_index                       = each.value.azure_virtual_network_gateway_region_index
  azure_key_vault_id                                               = module.azure_mgmt_key_vault.azurerm_key_vault_id
  common_tags                                                      = local.common_tags
}

module "azure_mgmt_virtual_machine" {
  source                      = "..//modules/azure-virtual-machine"
  providers = {
    azurerm = azurerm
  }
  for_each                     = { for vm in var.azure_mgmt_components: vm.instance_name => vm if vm.count_of_instances > 0 && vm.instance_type == "vm"}

  azure_resource_group_name    = module.azure_mgmt_resource_group.resource_group_name
  location                     = var.LOCATION
  azure_virtual_machines       = each.value
  azure_key_vault_id           = module.azure_mgmt_key_vault.azurerm_key_vault_id
  azure_virtual_network_name   = module.azure_mgmt_virtual_network.azurerm_virtual_network_name
  azure_virtual_network_subnet = lookup(element(module.azure_mgmt_virtual_network_subnet[each.key].azurerm_subnet_name_id, 0), "subnet_id")
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count
  common_tags                  = each.value.instance_name == "mgmt-vm" ? merge(local.common_tags, { key_vault_name = module.azure_mgmt_key_vault_mgmt_vm.azurerm_key_vault_name }) : local.common_tags
  depends_on                   = [module.azure_mgmt_virtual_network_subnet]
}

module "azurerm_virtual_machine_linux_scale_sets" {
  source = "..//modules/azure-virtual-machine-linux-scale-set"
  providers = {
    azurerm = azurerm
  }
  for_each                                  = { for vmss in var.azure_mgmt_components: vmss.instance_name => vmss if vmss.instance_type == "vmss" && try(vmss.deploy_agent_pool_instances_os_type, "parameter_not_exist") == "linux" }

  azurerm_vmss_name                         = each.value.instance_name
  azurerm_resource_group_name               = module.azure_mgmt_resource_group.resource_group_name
  location                                  = var.LOCATION
  azurerm_vmss_sku                          = each.value.vmss_size
  azurerm_vmss_instances_count              = each.value.count_of_instances
  azurerm_vmss_admin_username               = each.value.azure_vmss_username
  azurerm_vmss_availability_zones           = each.value.availability_zones
  azurerm_vmss_computer_name_prefix         = each.value.computer_name_prefix
  azurerm_vmss_subnet                       = lookup(element(module.azure_mgmt_virtual_network_subnet[each.key].azurerm_subnet_name_id, 0), "subnet_id")
  azurerm_vmss_source_image_id              = each.value.source_image_id
  azurerm_vmss_os_disk_storage_account_type = each.value.os_disk_storage_account_type
  azurerm_key_vault_id                      = module.azure_mgmt_key_vault.azurerm_key_vault_id
  azurerm_managed_service_identity_enabled  = each.value.azure_managed_service_identity_enabled
  common_tags                               = local.common_tags
  depends_on                                = [module.azure_mgmt_virtual_network_subnet]
}

module "azurerm_virtual_machine_windows_scale_sets" {
  source                                       = "..//modules/azure-virtual-machine-windows-scale-set"
  providers = {
    azurerm = azurerm
  }
  for_each                                  = { for vmss in var.azure_mgmt_components: vmss.instance_name => vmss if vmss.instance_type == "vmss" && try(vmss.deploy_agent_pool_instances_os_type, "parameter_not_exist") == "windows"}

  azurerm_vmss_name                         = each.value.instance_name
  azurerm_resource_group_name               = module.azure_mgmt_resource_group.resource_group_name
  location                                  = var.LOCATION
  azurerm_vmss_sku                          = each.value.vmss_size
  azurerm_vmss_instances_count              = each.value.count_of_instances
  azurerm_vmss_admin_username               = each.value.azure_vmss_username
  azurerm_vmss_availability_zones           = each.value.availability_zones
  azurerm_vmss_computer_name_prefix         = each.value.computer_name_prefix
  azurerm_vmss_subnet                       = lookup(element(module.azure_mgmt_virtual_network_subnet[each.key].azurerm_subnet_name_id, 0), "subnet_id")
  azurerm_vmss_source_image_id              = each.value.source_image_id
  azurerm_vmss_os_disk_storage_account_type = each.value.os_disk_storage_account_type
  azurerm_key_vault_id                      = module.azure_mgmt_key_vault.azurerm_key_vault_id
  azurerm_managed_service_identity_enabled  = each.value.azure_managed_service_identity_enabled
  common_tags                               = local.common_tags
  depends_on                                = [module.azure_mgmt_virtual_network_subnet]
}

module "azure_container_registry" {
  source                         = "..//modules/azure-kubernetes-service/azure-container-registry"
  providers = {
    azurerm = azurerm
  }
  count                                                     = var.PREFIX == "prd" ? 1 : 0

  azurerm_container_registry_name                           = join("", regexall("[[:alnum:]]", "${var.INFRASTRUCTURE_NAME}${var.PREFIX}${var.SUFFIX}"))
  azurerm_container_registry_resource_group_name            = module.azure_mgmt_resource_group.resource_group_name
  azurerm_container_registry_location                       = var.LOCATION
  azurerm_container_registry_sku                            = "Premium"
  azurerm_container_registry_admin_enabled                  = true
  azurerm_container_registry_public_network_access_enabled  = true
  azurerm_container_registry_public_zone_redundancy_enabled = false
  azurerm_user_assigned_identity                            = null
  azurerm_key_vault_id                                      = module.azure_mgmt_key_vault.azurerm_key_vault_id
  azurerm_container_registry_anonymous_pull_enabled         = true
  common_tags                                               = local.common_tags
}

module "azure_private_link_container_registry" {
  source                         = "..//modules/azure-private-link"
  providers = {
    azurerm = azurerm
  }

  private_endpoint_name                                = module.azure_container_registry[0].azurerm_container_registry_name
  location                                             = var.LOCATION
  resource_group_name                                  = module.azure_mgmt_resource_group.resource_group_name
  azurerm_private_endpoint_subnet_id                   = module.azure_mgmt_private_link_network_subnet.azurerm_subnet_id
  azurerm_resource_id                                  = module.azure_container_registry[0].azurerm_container_registry_id
  subresource_names                                    = "registry"
  azurerm_private_dns_zone_id                          = [lookup(element(module.azure_private_dns_zone["registry"].azure_private_dns_zones, 0), "zone_id")]
  common_tags                                          = local.common_tags
  private_service_connection_auto_approvement_disabled = var.PREFIX == "nprd" ? false : true
  depends_on                                           = [module.azure_mgmt_private_link_network_subnet, module.azure_mgmt_bastion_host]
}

module "azure_custom_role_acr_import" {
  source = "..//modules/azure-role-definition"
  providers = {
    azurerm = azurerm
  }
  count                               = var.PREFIX == "nprd" ? 1 : 0

  azurerm_role_definition_name        = "${var.INFRASTRUCTURE_NAME}-acr-import"
  azurerm_role_definition_description = "This role can be used to import images to ACR."
  assignable_scopes                   = [ module.azure_mgmt_resource_group.resource_group_id ]
  permissions_actions                 = [
                                         "Microsoft.ContainerRegistry/registries/push/write",
                                         "Microsoft.ContainerRegistry/registries/pull/read",
                                         "Microsoft.ContainerRegistry/registries/read",
                                         "Microsoft.ContainerRegistry/registries/importImage/action"
                                        ]
}

module "azure_custom_role_acr_import_presence_check" {
  source                      = "..//modules/azure-role-presence-check"
  count                       = var.PREFIX == "nprd" ? 1 : 0

  azurerm_custom_role_name    = try(module.azure_custom_role_acr_import[0].azurerm_role_definition_name, null)
  azurerm_resource_group_name = module.azure_mgmt_resource_group.resource_group_name
  azurerm_subscription_id     = data.azurerm_client_config.current.subscription_id
}

module "azure_custom_role_acr_build" {
  source = "..//modules/azure-role-definition"
  providers = {
    azurerm = azurerm
  }
  count                               = var.PREFIX == "nprd" ? 1 : 0

  azurerm_role_definition_name        = "${var.INFRASTRUCTURE_NAME}-acr-build"
  azurerm_role_definition_description = "This role can be used to build images using ACR."
  assignable_scopes                   = [ module.azure_mgmt_resource_group.resource_group_id ]
  permissions_actions                 = [
                                         "Microsoft.ContainerRegistry/registries/runs/listLogSasUrl/action",
                                         "Microsoft.ContainerRegistry/registries/scheduleRun/action",
                                         "Microsoft.ContainerRegistry/registries/listBuildSourceUploadUrl/action",
                                         "Microsoft.ContainerRegistry/registries/listCredentials/action",
                                         "Microsoft.ContainerRegistry/registries/read",
                                         "Microsoft.ContainerRegistry/registries/builds/read",
                                         "Microsoft.ContainerRegistry/registries/builds/write",
                                         "Microsoft.ContainerRegistry/registries/builds/getLogLink/action",
                                         "Microsoft.ContainerRegistry/registries/builds/cancel/action",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/read",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/write",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/delete",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/listSourceRepositoryProperties/action",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/steps/read",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/steps/write",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/steps/delete",
                                         "Microsoft.ContainerRegistry/registries/buildTasks/steps/listBuildArguments/action",
                                         "Microsoft.ContainerRegistry/registries/tasks/read",
                                         "Microsoft.ContainerRegistry/registries/tasks/write",
                                         "Microsoft.ContainerRegistry/registries/tasks/delete",
                                         "Microsoft.ContainerRegistry/registries/tasks/listDetails/action"
                                        ]
}

module "azure_key_vault_additional_secrets" {
  source                      = "..//modules/azure-key-vault-secret"
  providers = {
    azurerm = azurerm
  }

  additional_key_vault_secrets = [
                                  {"key_name" = "mgmt-key-vault-id", "key_value" = module.azure_mgmt_key_vault.azurerm_key_vault_id, "content_type" = "Common"},
                                  {"key_name" = "vnet-name", "key_value" = module.azure_mgmt_virtual_network.azurerm_virtual_network_name, "content_type" = "Common"},
                                  {"key_name" = "acr-private-endpoint-name", "key_value" = module.azure_private_link_container_registry.azurerm_private_endpoint_name, "content_type" = "Common"}
                                 ]
  azure_key_vault_id           = module.azure_mgmt_key_vault.azurerm_key_vault_id
}

module "azurerm_dev_test_global_vm_shutdown_schedule" {
  source = "..//modules/azure-dev-test-global-vm-shutdown-schedule"
  providers = {
    azurerm = azurerm
  }
  for_each                          = { for vm in flatten([ for instance in [ for component in var.azure_mgmt_components: component if component.count_of_instances > 0 && component.instance_type == "vm" && try(component.azure_vm_auto_shutdown_utc_time, "") != "" ] : [ for index in range(0, instance.count_of_instances) : "${instance.instance_name}-${index};${instance.azure_vm_auto_shutdown_utc_time}" ] ]): element(split(";", vm), 0) => element(split(";", vm), 1) }

  location                          = var.LOCATION
  azurerm_virtual_machine_id        = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.azure_mgmt_resource_group.resource_group_name}/providers/Microsoft.Compute/virtualMachines/${each.key}"
  azurerm_vm_auto_shutdown_utc_time = each.value == "auto" ? formatdate("hhmm" ,timeadd(timestamp(), "1m")) : each.value
  common_tags                       = local.common_tags
  depends_on                        = [module.azure_mgmt_virtual_machine]
}