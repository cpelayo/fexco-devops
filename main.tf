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
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "default"

  values = [
    file("${path.module}/helm/values.yaml")
  ]
}
