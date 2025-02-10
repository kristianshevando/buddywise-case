resource "random_password" "vm_instance_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "@#!"
}

resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                 = var.azurerm_vmss_name
  resource_group_name  = var.azurerm_resource_group_name
  location             = var.location
  sku                  = var.azurerm_vmss_sku
  instances            = var.azurerm_vmss_instances_count
  admin_username       = var.azurerm_vmss_admin_username
  admin_password       = random_password.vm_instance_password.result
  zones                = var.azurerm_vmss_availability_zones
  computer_name_prefix = var.azurerm_vmss_computer_name_prefix
  overprovision        = false
  source_image_id      = var.azurerm_vmss_source_image_id

  tags                 = var.common_tags

  lifecycle {
    ignore_changes = [
     tags["__AzureDevOpsElasticPoolTimeStamp"],
     tags["__AzureDevOpsElasticPool"],
     instances,
    ]
  }

  dynamic "identity" {
    for_each = var.azurerm_managed_service_identity_enabled ? [{}] : []
    content {
      type = "SystemAssigned"
    }
  }

  os_disk {
    storage_account_type = var.azurerm_vmss_os_disk_storage_account_type
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "internal_interface"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.azurerm_vmss_subnet
    }
  }
}

resource "azurerm_key_vault_secret" "admin_username" {
  name         = "${var.azurerm_vmss_name}-admin-username"
  value        = var.azurerm_vmss_admin_username
  key_vault_id = var.azurerm_key_vault_id
  depends_on   = [azurerm_windows_virtual_machine_scale_set.vmss]
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "${var.azurerm_vmss_name}-admin-password"
  value        = random_password.vm_instance_password.result
  key_vault_id = var.azurerm_key_vault_id
  content_type = "Sensitive"
  depends_on   = [azurerm_windows_virtual_machine_scale_set.vmss]
}