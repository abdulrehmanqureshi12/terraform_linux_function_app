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
  site_config {
    always_on = true
    linux_fx_version = "PYTHON|3.9"
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "WEBSITE_RUN_FROM_PACKAGE" = "https://github.com/Azure-Samples/functions-python-hello-world/archive/master.zip"
  }
  identity {
    type                     = "UserAssigned"
    identity_ids             = [azurerm_user_assigned_identity.function_app_identity.id]
  }

  # Configure HTTPS with the custom domain and certificate
  site_config {
linux_fx_version = "DOCKER|mcr.microsoft.com/azure-functions/python:3.0-python3.8-appservice"
  }

  # Configure the custom domain and certificate
  hostname_binding {
    hostname_type = "Verified"
    host_name     = var.custom_domain
    ssl_state     = "SniEnabled"
    thumbprint    = data.azurerm_key_vault_certificate.certificate.thumbprint
    ssl_type      = "SNI"
    to_delete     = false
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
