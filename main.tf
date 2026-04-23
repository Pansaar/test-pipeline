data "azurerm_resource_group" "pansaar-rg" {
  name = "pansaar-rg-${var.env_code}"
}

resource "azurerm_storage_account" "functionsa" {
  name                     = "pansaarfuncstorage${var.env_code}"
  resource_group_name      = data.azurerm_resource_group.pansaar-rg.name
  location                 = data.azurerm_resource_group.pansaar-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function_plan" {
  name                = "pansaar-func-plan-${var.env_code}"
  location            = data.azurerm_resource_group.pansaar-rg.location
  resource_group_name = data.azurerm_resource_group.pansaar-rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_windows_function_app" "function_app" {
  name                       = "pansaar-func-app-${var.env_code}"
  location                   = data.azurerm_resource_group.pansaar-rg.location
  resource_group_name        = data.azurerm_resource_group.pansaar-rg.name
  service_plan_id            = azurerm_app_service_plan.function_plan.id
  storage_account_name       = azurerm_storage_account.functionsa.name
  storage_account_access_key = azurerm_storage_account.functionsa.primary_access_key

  site_config {
    application_stack {
      powershell_core_version = "7.2"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "powershell"
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}