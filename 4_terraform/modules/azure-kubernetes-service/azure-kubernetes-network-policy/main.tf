resource "kubernetes_network_policy" "network_policy" {
  metadata {
    name      = replace(lookup(var.kubernetes_network_policy, "k8s_network_policy_name"), "{innovator_namespace_name}", lookup(var.override_tfvars_value, "{innovator_namespace_name}", ""))
    namespace = contains(keys(var.kubernetes_network_policy), "k8s_network_policy_namespace") ? lookup(var.kubernetes_network_policy, "k8s_network_policy_namespace") : var.kubernetes_network_policy_namespace
  }

  spec {
    dynamic "pod_selector" {
      for_each = lookup(var.kubernetes_network_policy, "k8s_network_policy_pod_selector", {})
      iterator = pod_selector
      content {
        dynamic "match_expressions" {
          for_each = lookup(pod_selector.value, "match_expressions", {})
          iterator = match_expressions
          content {
            key      = lookup(match_expressions.value, "key")
            operator = lookup(match_expressions.value, "operator")
            values   = lookup(match_expressions.value, "values")
          }
        }
      }
    }

    dynamic "ingress" {
      for_each = lookup(var.kubernetes_network_policy.k8s_network_policy_rules, "ingress", {})
      iterator = ingress
      content {
        ports {
          port     = lookup(ingress.value, "port", null)
          protocol = lookup(ingress.value, "protocol", null)
        }

        from {
          dynamic "namespace_selector" {
            for_each = lookup(ingress.value, "namespace_selector", {})
            iterator = namespace_selector
            content {
              dynamic "match_expressions" {
                for_each = lookup(namespace_selector.value, "match_expressions", {})
                iterator = match_expressions
                content {
                  key      = lookup(match_expressions.value, "key")
                  operator = lookup(match_expressions.value, "operator")
                  values   = [ for item in lookup(match_expressions.value, "values"): lookup(var.override_tfvars_value, item, item) ]
                }
              }
            }
          }

          dynamic "pod_selector" {
            for_each = lookup(ingress.value, "pod_selector", {})
            iterator = pod_selector
            content {
              dynamic "match_expressions" {
                for_each = lookup(pod_selector.value, "match_expressions", {})
                iterator = match_expressions
                content {
                  key      = lookup(match_expressions.value, "key")
                  operator = lookup(match_expressions.value, "operator")
                  values   = lookup(match_expressions.value, "values")
                }
              }
            }
          }

          dynamic "ip_block" {
            for_each = lookup(ingress.value, "ip_block", {})
            iterator = ip_block
            content {
              cidr = lookup(var.override_tfvars_value, lookup(ip_block.value, "cidr"), lookup(ip_block.value, "cidr"))
              except = lookup(ip_block.value, "except", null)
            }
          }
        }
      }
    }

    dynamic "egress" {
      for_each = lookup(var.kubernetes_network_policy.k8s_network_policy_rules, "egress", {})
      iterator = egress
      content {
        ports {
          port     = lookup(egress.value, "port", null)
          protocol = lookup(egress.value, "protocol", null)
        }

        to {
          dynamic "namespace_selector" {
            for_each = lookup(egress.value, "namespace_selector", {})
            iterator = namespace_selector
            content {
              dynamic "match_expressions" {
                for_each = lookup(namespace_selector.value, "match_expressions", {})
                iterator = match_expressions
                content {
                  key      = lookup(match_expressions.value, "key")
                  operator = lookup(match_expressions.value, "operator")
                  values   = [ for item in lookup(match_expressions.value, "values"): lookup(var.override_tfvars_value, item, item) ]
                }
              }
            }
          }

          dynamic "pod_selector" {
            for_each = lookup(egress.value, "pod_selector", {})
            iterator = pod_selector
            content {
              dynamic "match_expressions" {
                for_each = lookup(pod_selector.value, "match_expressions", {})
                iterator = match_expressions
                content {
                  key      = lookup(match_expressions.value, "key")
                  operator = lookup(match_expressions.value, "operator")
                  values   = lookup(match_expressions.value, "values")
                }
              }
            }
          }

          dynamic "ip_block" {
            for_each = lookup(egress.value, "ip_block", {})
            iterator = ip_block
            content {
              cidr = lookup(var.override_tfvars_value, lookup(ip_block.value, "cidr"), lookup(ip_block.value, "cidr"))
              except = lookup(ip_block.value, "except", null)
            }
          }
        }
      }
    }
    policy_types = contains(keys(var.kubernetes_network_policy), "k8s_network_policy_types") ? lookup(var.kubernetes_network_policy, "k8s_network_policy_types") : flatten([lookup(var.kubernetes_network_policy.k8s_network_policy_rules, "ingress", []) != [] ? ["Ingress"] : [], lookup(var.kubernetes_network_policy.k8s_network_policy_rules, "egress", []) != [] ? ["Egress"] : []])
  }
}