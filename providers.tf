terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Data source to read policy configuration
data "local_file" "policy_config" {
  filename = "${path.module}/policy.json"
}

locals {
  policy_config = jsondecode(data.local_file.policy_config.content)
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Variables for dynamic configuration
variable "subscription_id" {
  description = "The subscription ID to deploy to"
  type        = string
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "service_principal_name" {
  description = "The name of the service principal/service connection to use"
  type        = string
}