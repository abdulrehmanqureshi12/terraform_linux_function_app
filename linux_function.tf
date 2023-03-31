resource "azurerm_app_service_plan" "service_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.target_rg
  app_service_plan_id = azurerm_app_service_plan.service_plan.id
  storage_account_name = var.storage_account_name
  os_type             = "Linux"
  version             = "~3"

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = var.runtime
    "WEBSITE_RUN_FROM_PACKAGE" = var.run_from_package
    "SOME_OTHER_SETTING" = var.some_other_setting
  }

  site_config {
    linux_fx_version = var.linux_fx_version
  }
}
