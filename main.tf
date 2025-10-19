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
    vm_size    = "Standard_B2s"  # small, cost-effective SKU
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