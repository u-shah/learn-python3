# Azure Policy Definition for restricting subnet deployments
resource "azurerm_policy_definition" "restrict_subnet_deployment" {
  name                = local.policy_config.policy_settings.policy_name
  policy_category     = "Network"
  management_group_id = var.management_group_id

  policy_type = "Custom"

  display_name = local.policy_config.policy_settings.policy_display_name
  description  = local.policy_config.policy_settings.policy_description

  policy_rule = jsonencode({
    "if" = {
      "allOf" = [
        {
          "field" = "type",
          "equals" = "Microsoft.Network/virtualNetworks/subnets"
        },
        {
          "not" = {
            "field" = "name",
            "in"    = var.allowed_subnets
          }
        }
      ]
    },
    "then" = {
      "effect" = "deny"
    }
  })

  parameters = jsonencode({
    "allowedSubnets" = {
      "type" = "Array",
      "metadata" = {
        "displayName" = "Allowed Subnets",
        "description" = "List of subnets that are allowed for resource deployment"
      }
    }
  })
}

# Policy Assignment
resource "azurerm_policy_assignment" "restrict_subnet_deployment" {
  name                 = "${local.policy_config.policy_settings.policy_name}-assignment"
  scope                = var.scope
  policy_definition_id = azurerm_policy_definition.restrict_subnet_deployment.id
  display_name         = "${local.policy_config.policy_settings.policy_display_name} Assignment"

  parameters = jsonencode({
    "allowedSubnets" = var.allowed_subnets
  })
}

# Variables for policy configuration
variable "management_group_id" {
  description = "The management group ID where the policy definition will be created"
  type        = string
  default     = null
}

variable "scope" {
  description = "The scope at which the policy assignment will be applied"
  type        = string
}

variable "allowed_subnets" {
  description = "List of subnets that are allowed for resource deployment"
  type        = list(string)
  default     = []
}