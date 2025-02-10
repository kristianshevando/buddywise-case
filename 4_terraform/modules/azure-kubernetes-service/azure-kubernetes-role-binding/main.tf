resource "kubernetes_role_binding" "role_binding" {
  metadata {
    name      = var.kubernetes_role_binding_name
    namespace = var.kubernetes_role_binding_namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = var.kubernetes_role_kind
    name      = var.kubernetes_role_name
  }

  dynamic "subject" {
    for_each       = toset(var.kubernetes_subjects)
    iterator       = subject
    content {
      kind      = var.kubernetes_subject_kind
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}