variable "resource_group_name" {
  type    = string
  default = "my-resource-group"
}

variable "storage_account_name" {
  type    = string
  default = "testaccountsub"
}

variable "container_registry_name" {
  type    = string
  default = "mycontainerregistrydeepak"
}

variable "function_app_name" {
  type    = string
  default = "myfunctionappdeepak"
}

variable "service_plan_name" {
  type    = string
  default = "myserviceplan"
}

variable "location" {
  type    = string
  default = "eastus"
}
