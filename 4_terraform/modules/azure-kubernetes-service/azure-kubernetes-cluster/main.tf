data "azurerm_client_config" "current" {}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "random_password" "vm_instance_password" {
  count            = var.azurerm_kubernetes_cluster_windows_node_pool ? 1 : 0
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "@$#!"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                              = var.azurerm_kubernetes_cluster_name
  location                          = var.location
  resource_group_name               = var.azurerm_kubernetes_cluster_resource_group_name
  kubernetes_version                = var.azurerm_kubernetes_cluster_version
  node_resource_group               = var.azurerm_kubernetes_cluster_node_resource_group
  private_cluster_enabled           = var.azurerm_kubernetes_private_cluster_enabled
  sku_tier                          = var.azurerm_kubernetes_cluster_sku_tier
  azure_policy_enabled              = var.azurerm_kubernetes_cluster_azure_policy_enabled
  local_account_disabled            = var.azurerm_kubernetes_cluster_local_account_disabled
  role_based_access_control_enabled = var.azurerm_kubernetes_cluster_role_based_access_control_enabled
  oidc_issuer_enabled               = var.azurerm_kubernetes_cluster_oidc_issuer_enabled
  workload_identity_enabled         = var.azurerm_kubernetes_cluster_workload_identity_enabled
  dns_prefix = "test"

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      maintenance_window_node_os["start_date"]
    ]
  }

  default_node_pool {
    name                 = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "name")
    enable_auto_scaling  = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "enable_auto_scaling")
    min_count            = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "enable_auto_scaling") ? lookup(var.azurerm_kubernetes_cluster_default_node_pool, "min_count") : null
    max_count            = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "enable_auto_scaling") ? lookup(var.azurerm_kubernetes_cluster_default_node_pool, "max_count") : null
    os_disk_type         = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "os_disk_type")
    os_sku               = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "os_sku")
    node_count           = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "enable_auto_scaling") ? null : lookup(var.azurerm_kubernetes_cluster_default_node_pool, "node_count")
    vm_size              = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "vm_size")
    type                 = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "type")
    vnet_subnet_id       = var.azurerm_kubernetes_cluster_default_node_pool_vnet_subnet_id
    zones 	             = length(var.azurerm_kubernetes_cluster_availability_zones) > 1 ? var.azurerm_kubernetes_cluster_availability_zones : null
    max_pods             = lookup(var.azurerm_kubernetes_cluster_default_node_pool, "max_pods")
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.azurerm_user_assigned_identity_ids
  }

  kubelet_identity {
    client_id                 = var.azurerm_kubelet_user_assigned_identity_client_id
    object_id                 = var.azurerm_kubelet_user_assigned_identity_object_id
    user_assigned_identity_id = var.azurerm_kubelet_user_assigned_identity_id
  }

  network_profile {
    network_plugin     = lookup(var.azurerm_kubernetes_cluster_network_profile, "network_plugin")
    network_mode       = lookup(var.azurerm_kubernetes_cluster_network_profile, "network_mode")
    network_policy     = lookup(var.azurerm_kubernetes_cluster_network_profile, "network_policy")
    dns_service_ip     = lookup(var.azurerm_kubernetes_cluster_network_profile, "dns_service_ip")
    docker_bridge_cidr = lookup(var.azurerm_kubernetes_cluster_network_profile, "docker_bridge_cidr")
    service_cidr       = lookup(var.azurerm_kubernetes_cluster_network_profile, "service_cidr")
    load_balancer_sku  = lookup(var.azurerm_kubernetes_cluster_network_profile, "load_balancer_sku")
    outbound_type      = lookup(var.azurerm_kubernetes_cluster_network_profile, "outbound_type")
  }

  linux_profile {
    admin_username = var.azurerm_kubernetes_cluster_admin_username
    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.azurerm_kubernetes_cluster_admin_group_object_ids
    azure_rbac_enabled     = var.azurerm_kubernetes_cluster_azure_rbac_enabled
    managed                = true
    tenant_id              = data.azurerm_client_config.current.tenant_id
  }

  maintenance_window_node_os {
    frequency   = "Weekly"
    interval    =  length(regexall("-prd-", var.azurerm_kubernetes_cluster_name)) > 0 ? 4 : 1
    duration    = 4
    day_of_week = "Saturday"
    start_time  = "00:00"
    utc_offset  = "+00:00"
    start_date  = timeadd(timestamp(), "25h")
  }

  dynamic "windows_profile" {
    for_each = var.azurerm_kubernetes_cluster_windows_node_pool ? [{}] : []
    content {
      admin_username = var.azurerm_kubernetes_cluster_admin_username
      admin_password = random_password.vm_instance_password[0].result
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "balance_similar_node_groups")
    expander                         = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "expander")
    max_graceful_termination_sec     = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "max_graceful_termination_sec")
    max_node_provisioning_time       = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "max_node_provisioning_time")
    max_unready_nodes                = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "max_unready_nodes")
    max_unready_percentage           = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "max_unready_percentage")
    new_pod_scale_up_delay           = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "new_pod_scale_up_delay")
    scale_down_delay_after_add       = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "scale_down_delay_after_add")
    scale_down_delay_after_delete    = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "scale_down_delay_after_delete")
    scale_down_delay_after_failure   = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "scale_down_delay_after_failure")
    scan_interval                    = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "scan_interval")
    scale_down_unneeded              = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "scale_down_unneeded")
    scale_down_unready               = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "scale_down_unready")
    scale_down_utilization_threshold = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "scale_down_utilization_threshold")
    empty_bulk_delete_max            = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "empty_bulk_delete_max")
    skip_nodes_with_local_storage    = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "skip_nodes_with_local_storage")
    skip_nodes_with_system_pods      = lookup(var.azurerm_kubernetes_cluster_auto_scaler_profile, "skip_nodes_with_system_pods")
  }
}

resource "azurerm_key_vault_secret" "windows_profile_password" {
  count        = var.azurerm_kubernetes_cluster_windows_node_pool ? 1 : 0
  name         = "${var.azurerm_kubernetes_cluster_name}-windows-profile-password"
  value        = random_password.vm_instance_password[0].result
  key_vault_id = var.azurerm_key_vault_id
  content_type = "Sensitive"
}

data "azurerm_public_ip" "outbound_cluster_ip" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.k8s.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
}