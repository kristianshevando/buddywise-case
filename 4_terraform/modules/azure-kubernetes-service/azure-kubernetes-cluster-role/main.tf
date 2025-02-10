resource "kubernetes_cluster_role" "cluster_role" {
  metadata {
    name = var.kubernetes_cluster_role_name
  }

  dynamic "rule" {
   for_each = var.kubernetes_cluster_role_rules
   content {
     api_groups     = lookup(rule.value, "api_groups", null)
     resources      = lookup(rule.value, "resources", null)
     resource_names = lookup(rule.value, "resource_names", null)
     verbs          = lookup(rule.value, "verbs", null)
   }
  }
}