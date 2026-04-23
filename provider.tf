terraform {
  backend "azurerm" {
    resource_group_name  = "pansaar-rg"
    storage_account_name = "pansaartfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}