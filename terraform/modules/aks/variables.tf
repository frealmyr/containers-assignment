variable "azurerm_resource_group_name" {
  description = "The prefix for the resource group name"
}

variable "azurerm_resource_group_location" {
  description = "The prefix for the resource group name"
  default     = "rg"
}

variable "azuread_group_superusers" {
  description = "The object ID of the Azure AD group that will have superuser access to the AKS cluster"
  type        = string
}
