data "azurerm_client_config" "current" {
}

data "azurerm_subnet" "subnet" {
  name                 = lookup(var.azure_virtual_machines, "instance_name")
  virtual_network_name = var.azure_virtual_network_name
  resource_group_name  = var.azure_resource_group_name
}

resource "random_password" "vm_instance_password" {
  count            = lookup(var.azure_virtual_machines, "count_of_instances")
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "@#!"
}

resource "azurerm_network_interface" "vm" {
  count               = lookup(var.azure_virtual_machines, "count_of_instances")
  name                = "${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
  location            = var.location
  resource_group_name = var.azure_resource_group_name

  tags                = var.common_tags

  dynamic "ip_configuration" {
    for_each = lookup(var.azure_virtual_machines, "private_ip_address_allocation") == "Dynamic" ? [{}] : []
    content {
      name                          = "${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
      subnet_id                     = var.azure_virtual_network_subnet
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = var.public_ip_address_id
    }
  }

  dynamic "ip_configuration" {
    for_each = lookup(var.azure_virtual_machines, "private_ip_address_allocation") == "Static" ? [{}] : []
    content {
      name                          = "${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
      subnet_id                     = var.azure_virtual_network_subnet
      private_ip_address_allocation = "Static"
      private_ip_address            = cidrhost(join(",", data.azurerm_subnet.subnet.address_prefixes), 4+count.index)
      public_ip_address_id          = var.public_ip_address_id
    }
  }
}

resource "azurerm_availability_set" "availability_set" {
  count                        = lookup(var.azure_virtual_machines, "count_of_instances") > 0 ? 1 : 0
  name                         = "${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
  location                     = var.location
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count
  resource_group_name          = var.azure_resource_group_name
  tags                         = var.common_tags
}

resource "azurerm_virtual_machine" "vm" {
  count                            = lookup(var.azure_virtual_machines, "count_of_instances")
  name                             = "${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
  resource_group_name              = var.azure_resource_group_name
  location                         = var.location
  vm_size                          = lookup(var.azure_virtual_machines, "vm_size")
  network_interface_ids            = [element(azurerm_network_interface.vm.*.id, count.index)]
  availability_set_id              = join("", [for instance in azurerm_availability_set.availability_set.*.id: instance if element(reverse(split("/", instance)), 0) == lookup(var.azure_virtual_machines, "instance_name")])
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  depends_on                       = [azurerm_availability_set.availability_set, azurerm_network_interface.vm]

  tags                             = var.common_tags

    dynamic "identity" {
      for_each = lookup(var.azure_virtual_machines, "azure_managed_service_identity_enabled") ? [{}] : []
      content {
        type = "SystemAssigned"
      }
    }

    dynamic "os_profile_windows_config" {
      for_each = lookup(var.azure_virtual_machines, "os_type") == "windows" ? [{}] : []
      content {
        provision_vm_agent = true
      }
    }

    dynamic "os_profile_linux_config" {
      for_each = lookup(var.azure_virtual_machines, "os_type") == "linux" ? [{}] : []
      content {
        disable_password_authentication = false
      }
    }

    storage_os_disk {
      name              = "${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    storage_image_reference  {
      id = lookup(var.azure_virtual_machines, "source_image_id")
    }

    os_profile {
      computer_name  = "${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
      admin_username = lookup(var.azure_virtual_machines, "azure_vm_username")
      admin_password = element(random_password.vm_instance_password.*.result, count.index)
    }
}

resource "azurerm_key_vault_secret" "vm_username" {
  count        = lookup(var.azure_virtual_machines, "count_of_instances")
  name         = "azure-vm-username-${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
  value        = lookup(var.azure_virtual_machines, "azure_vm_username")
  key_vault_id = var.azure_key_vault_id
}

resource "azurerm_key_vault_secret" "vm_password" {
  count        = lookup(var.azure_virtual_machines, "count_of_instances")
  name         = "azure-vm-password-${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
  value        = element(random_password.vm_instance_password.*.result, count.index)
  content_type = "Sensitive"
  key_vault_id = var.azure_key_vault_id
}

resource "azurerm_key_vault_secret" "azure_managed_service_identity_object" {
  count        = lookup(var.azure_virtual_machines, "count_of_instances")
  name         = "azure-vm-identity-id-${lookup(var.azure_virtual_machines, "instance_name")}-${count.index}"
  value        = lookup(var.azure_virtual_machines, "azure_managed_service_identity_enabled") ? azurerm_virtual_machine.vm[count.index].identity.0.principal_id : "none"
  key_vault_id = var.azure_key_vault_id
}