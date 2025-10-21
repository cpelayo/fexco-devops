# NetworkPolicy - Allow Only Port 80
# Limits all pods in "default" namespace to accept ingress
# only on TCP port 80. Other ports are blocked.

resource "kubernetes_network_policy" "allow_http_only" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  provider   = kubernetes.aks
  metadata {
    name      = "allow-http-only"
    namespace = "default"
  }

  spec {
    pod_selector {} # applies to all pods in this namespace

    policy_types = ["Ingress"]

    ingress {
      ports {
        port     = 80
        protocol = "TCP"
      }
    }
  }
}