data "azurerm_resource_group" "rg" {
  name = "test"
}

# Define storage account data source
data "azurerm_storage_account" "sa" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
}

# Create App Service plan
resource "azurerm_service_plan" "sp" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name = "Y1"
  os_type = "Linux"
}

# Create Function App
resource "azurerm_linux_function_app" "fa" {
  name                      = var.function_app_name
  location                  = var.location
  resource_group_name       = data.azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.sp.id
  storage_account_name      = data.azurerm_storage_account.sa.name
  storage_account_access_key = data.azurerm_storage_account.sa.primary_access_key
   https_only = true
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME    = "node"
    CONTAINER_REGISTRY_SERVER  = azurerm_container_registry.acr.login_server
    CONTAINER_REGISTRY_USERNAME = azurerm_container_registry.acr.admin_username
    CONTAINER_REGISTRY_PASSWORD = azurerm_container_registry.acr.admin_password
  }
  client_certificate_enabled = true
  site_config {
    always_on                 = true
    use_32_bit_worker_process = false
    websockets_enabled        = false
    https_only                = true
    client_cert_enabled       = true
  }
  
}
