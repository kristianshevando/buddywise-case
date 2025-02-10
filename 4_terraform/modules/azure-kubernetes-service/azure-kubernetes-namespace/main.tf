resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = var.k8s_namespace_annotations
    labels 	    = var.k8s_namespace_labels
    name   	    = lower(var.k8s_namespace_name)
  }

  timeouts {
    delete = "30m"
  }
}