variable "app_name" {
  type        = string
  description = "Name of the Function App"
  default     = "my-function-app"
}

variable "location" {
  type        = string
  description = "Location for the Function App"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
  default     = "my-resource-group"
}

variable "app_service_plan_id" {
  type        = string
  description = "ID of the App Service Plan"
  default     = "/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.Web/serverFarms/<app_service_plan_name>"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Storage Account"
  default     = "my-storage-account"
}

variable "runtime" {
  type        = string
  description = "The language runtime to use for the Function App"
  default     = "node"
}

variable "run_from_package" {
  type        = string
  description = "A URL or file path to a pre-built package to run the Function App from"
  default     = null
}

variable "some_other_setting" {
  type        = string
  description = "Some other configuration setting to pass to the Function App"
  default     = null
}

variable "linux_fx_version" {
  type        = string
  description = "The version of the Linux FX runtime to use"
  default     = "DOCKER|<docker_image>"
}
