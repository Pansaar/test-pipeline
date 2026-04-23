terraform {
  backend "azurerm" {
    resource_group_name  = "pansaar-rg-${var.env_code}"
    storage_account_name = "pansaartfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}