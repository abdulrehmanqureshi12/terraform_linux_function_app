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

resource "azurerm_function_app" "function_app" {
  name                      = var.function_app_name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.RG.name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan.id
  app_settings              = var.app_settings
  storage_account_name      = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  os_type                    = "linux"
  version                    = "~4"

  app_settings {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }

  site_config {
    linux_fx_version = "python|3.9"
  }
}

# Grant the identity access to the certificate in the key vault
resource "azurerm_key_vault_access_policy" "function_app_cert_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id

  object_id = azurerm_user_assigned_identity.function_app_identity.principal_id

  certificate_permissions = [
    "get"
  ]
}

data "azurerm_key_vault" "example" {
  name                = "example-kv"
  resource_group_name = "example-resource-group"
}

data "azurerm_key_vault_certificate" "example" {
  name         = "example-cert"
  key_vault_id = data.azurerm_key_vault.example.id
}
