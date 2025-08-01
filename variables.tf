# Default values for variables
variable "subscription_id" {
  description = "The subscription ID to deploy to"
  type        = string
  default     = ""
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
  default     = ""
}

variable "service_principal_name" {
  description = "The name of the service principal/service connection to use"
  type        = string
  default     = ""
}

variable "management_group_id" {
  description = "The management group ID where the policy definition will be created"
  type        = string
  default     = null
}

variable "scope" {
  description = "The scope at which the policy assignment will be applied"
  type        = string
  default     = ""
}

variable "allowed_subnets" {
  description = "List of subnets that are allowed for resource deployment"
  type        = list(string)
  default     = []
}

# Output values
output "policy_definition_id" {
  description = "The ID of the created policy definition"
  value       = azurerm_policy_definition.restrict_subnet_deployment.id
}

output "policy_assignment_id" {
  description = "The ID of the created policy assignment"
  value       = azurerm_policy_assignment.restrict_subnet_deployment.id
}

output "policy_definition_name" {
  description = "The name of the created policy definition"
  value       = azurerm_policy_definition.restrict_subnet_deployment.name
}