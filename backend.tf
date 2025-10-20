terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatecpelayostorage"
    container_name       = "tfstate"
    key                  = "fexco-devops.tfstate"
    use_oidc             = true
  }
}