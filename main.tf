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

resource "azurerm_service_plan" "function_plan" {
  name                = "pansaar-func-plan-${var.env_code}"
  location            = data.azurerm_resource_group.pansaar-rg.location
  resource_group_name = data.azurerm_resource_group.pansaar-rg.name
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_storage_container" "functionapp" {
  name                  = "functionapp"
  storage_account_name  = azurerm_storage_account.functionsa.name
  container_access_type = "private"
}

data "archive_file" "function_app" {
  type        = "zip"
  source_dir  = "${path.module}/functionapp"
  output_path = "./functionapp.zip"
}

resource "azurerm_storage_blob" "function_app_zip" {
  name                   = "functionapp.zip"
  storage_account_name   = azurerm_storage_account.functionsa.name
  storage_container_name = azurerm_storage_container.functionapp.name
  type                   = "Block"
  source                 = data.archive_file.function_app.output_path
}

resource "azurerm_windows_function_app" "function_app" {
  name                       = "pansaar-func-app-${var.env_code}"
  location                   = data.azurerm_resource_group.pansaar-rg.location
  resource_group_name        = data.azurerm_resource_group.pansaar-rg.name
  service_plan_id            = azurerm_service_plan.function_plan.id
  storage_account_name       = azurerm_storage_account.functionsa.name
  storage_account_access_key = azurerm_storage_account.functionsa.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      powershell_core_version = "7.2"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "powershell"
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.functionsa.name}.blob.core.windows.net/${azurerm_storage_container.functionapp.name}/${azurerm_storage_blob.function_app_zip.name}"
  }
}

resource "azurerm_role_assignment" "function_app_blob_reader" {
  scope                = azurerm_storage_account.functionsa.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_windows_function_app.function_app.identity[0].principal_id
}

output "path" {
  value = data.archive_file.function_app.output_path
}