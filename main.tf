# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "aks-demo-rg"
  location = "West Europe"
}

# Create the Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-demo-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksdemo"

  # Node pool configuration
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s" # small, cost-effective SKU
  }

  # Use Managed Identity for simplicity and security
  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_logs.id
  }

  # Enable RBAC for better management
  role_based_access_control_enabled = true

  # Optional tags
  tags = {
    environment = "dev"
    owner       = "cesar"
  }
}


# Add the Helm release in kubernetes
resource "helm_release" "grafana" {
  count = length(data.helm_release.grafana_existing.name) == 0 ? 1 : 0
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "default"

  values = [
    file("${path.module}/helm/values.yaml")
  ]
}

data "helm_release" "grafana_existing" {
  name      = "grafana"
  namespace = "default"
}
