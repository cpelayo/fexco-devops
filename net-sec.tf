# NetworkPolicy - Allow Only Port 80
# Limits all pods in "default" namespace to accept ingress
# only on TCP port 80. Other ports are blocked.

resource "kubernetes_network_policy" "allow_http_only" {
  metadata {
    name      = "allow-http-only"
    namespace = kubernetes_namespace.default_ns.metadata[0].name
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


