resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  metadata {
    name = var.kubernetes_cluster_role_binding_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = var.kubernetes_role_kind
    name      = var.kubernetes_cluster_role_name
  }

  dynamic "subject" {
    for_each       = toset(var.kubernetes_cluster_subjects)
    iterator       = subject
    content {
      kind      = var.kubernetes_cluster_subject_kind
      name      = subject.value
      api_group = var.kubernetes_cluster_subject_kind == "ServiceAccount" ? null : "rbac.authorization.k8s.io"
      namespace = var.kubernetes_cluster_subject_kind == "ServiceAccount" ? var.kubernetes_cluster_subject_namespace : null
    }
  }
}