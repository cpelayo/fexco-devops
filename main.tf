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

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  # Enable RBAC for better management
  role_based_access_control_enabled = true

  # Optional tags
  tags = {
    environment = "dev"
    owner       = "cesar"
  }
}

resource "helm_release" "grafana" {
  provider         = helm.aks
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "default"
  create_namespace = true

  cleanup_on_fail = true
  force_update    = true # If release exists, upgrade instead of failing
  replace         = true # Replace if stuck in failed state
  atomic          = true

  values = [
    file("${path.module}/helm/values.yaml")
  ]
}
