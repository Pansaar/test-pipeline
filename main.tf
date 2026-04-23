data "azurerm_resource_group" "pansaar-rg" {
  name     = "pansaar-rg"
}

resource "azurerm_storage_account" "functionsa" {
  name                     = "pansaarfuncstorage"
  resource_group_name      = data.azurerm_resource_group.pansaar-rg.name
  location                 = data.azurerm_resource_group.pansaar-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function_plan" {
  name                = "pansaar-func-plan"
  location            = data.azurerm_resource_group.pansaar-rg.location
  resource_group_name = data.azurerm_resource_group.pansaar-rg.name
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = "pansaar-func-app"
  location                   = data.azurerm_resource_group.pansaar-rg.location
  resource_group_name        = data.azurerm_resource_group.pansaar-rg.name
  app_service_plan_id        = azurerm_app_service_plan.function_plan.id
  storage_account_name       = azurerm_storage_account.functionsa.name
  storage_account_access_key = azurerm_storage_account.functionsa.primary_access_key
  version                    = "~4"
  os_type                    = "windows"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME        = "powershell"
    WEBSITE_RUN_FROM_PACKAGE        = "1"
    FUNCTIONS_WORKER_RUNTIME_VERSION = "7.2"
  }
}