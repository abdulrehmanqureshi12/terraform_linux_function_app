# Create an Azure App Service Plan
resource "azurerm_app_service_plan" "service_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }
}

# Create an Azure Linux Function App associated with the App Service Plan
resource "azurerm_linux_function_app" "example" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.service_plan.id
  app_settings        = var.app_settings
}