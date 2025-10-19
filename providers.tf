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
  features {}
  subscription_id = "0d0d36f2-1f7f-49e5-9188-1e3cf650ebd1"
}