terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "0d0d36f2-1f7f-49e5-9188-1e3cf650ebd1"
}

/*
data "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-demo-cluster" # your actual cluster name
  resource_group_name = "aks-demo-rg"      # your actual resource group
}

provider "kubernetes" {
  alias = "aks"
  host  = data.azurerm_kubernetes_cluster.aks.kube_config[0].host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  alias = "aks"
  kubernetes = {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}


provider "kubernetes" {
  alias                  = "aks"
  host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  alias = "aks"
  kubernetes = {
    host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}

*/

provider "kubernetes" {
  alias = "aks"

  host = try(
    azurerm_kubernetes_cluster.aks.kube_config[0].host,
    "https://placeholder.local"
  )

  client_certificate = try(
    base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate),
    ""
  )

  client_key = try(
    base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key),
    ""
  )

  cluster_ca_certificate = try(
    base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate),
    ""
  )
}

##########################################################
# Helm Provider (same pattern, using the same AKS cluster)
##########################################################

provider "helm" {
  alias = "aks"

  kubernetes {
    host = try(
      azurerm_kubernetes_cluster.aks.kube_config[0].host,
      "https://placeholder.local"
    )

    client_certificate = try(
      base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate),
      ""
    )

    client_key = try(
      base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key),
      ""
    )

    cluster_ca_certificate = try(
      base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate),
      ""
    )
  }
}
