resource "azurerm_storage_management_policy" "blob_lifecycle" {
  storage_account_id = var.azure_storage_account_id

  dynamic "rule" {
    for_each = var.azurerm_storage_management_policy_rules
    iterator = rule
    content {
      name    = rule.value.blob_rule_name
      enabled = true
      filters {
        prefix_match = try(rule.value.blob_prefix_match, null)
        blob_types   = rule.value.blob_types
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than     = try(rule.value.tier_to_cool_after_days_since_modification_greater_than, null)
          tier_to_archive_after_days_since_modification_greater_than  = try(rule.value.tier_to_archive_after_days_since_modification_greater_than, null)
          tier_to_cold_after_days_since_modification_greater_than	    = try(rule.value.tier_to_cold_after_days_since_modification_greater_than, null)
          tier_to_cold_after_days_since_creation_greater_than	        = try(rule.value.tier_to_cold_after_days_since_creation_greater_than, null)
          tier_to_cool_after_days_since_last_access_time_greater_than = try(rule.value.tier_to_cool_after_days_since_last_access_time_greater_than, null)
          delete_after_days_since_modification_greater_than           = try(rule.value.delete_after_days_since_modification_greater_than, null)
          delete_after_days_since_creation_greater_than               = try(rule.value.delete_after_days_since_creation_greater_than, null)
        }
      }
    }
  }
}