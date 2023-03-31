variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan"
  default     = "my-app-service-plan"
}

variable "app_service_plan_tier" {
  type        = string
  description = "Tier of the App Service Plan"
  default     = "Dynamic"
}

variable "app_service_plan_size" {
  type        = string
  description = "Size of the App Service Plan"
  default     = "Y1"
}

variable "app_name" {
  type        = string
  description = "Name of the Function App"
  default     = "my-function-app"
}

variable "location" {
  type        = string
  description = "Location for the App Service Plan and Function App"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
  default     = "my-resource-group"
}

variable "app_settings" {
  type        = map(string)
  description = "App settings for the Function App"
  default = {
    FUNCTIONS_WORKER_RUNTIME             = "custom"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE  = "false"
    DOCKER_REGISTRY_SERVER_URL           = "https://index.docker.io"
    WEBSITES_PORT                        = "80"
    DOCKER_ENABLE_CI                     = "true"
    DOCKER_CUSTOM_IMAGE_NAME             = "hello-world"
  }
}