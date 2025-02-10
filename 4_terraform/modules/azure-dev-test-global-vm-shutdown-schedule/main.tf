resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id = var.azurerm_virtual_machine_id
  location           = var.location
  enabled            = true

  daily_recurrence_time = var.azurerm_vm_auto_shutdown_utc_time
  timezone              = "UTC"

  notification_settings {
    enabled = false
  }

  tags = var.common_tags
}