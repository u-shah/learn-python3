<p align="center">
  <img src="logo.png" alt="logo"/>
</p>

# Azure Policy Deployment Pipeline

This repository contains a parameterized Azure DevOps pipeline that deploys Azure policies to multiple subscriptions dynamically.

## Overview

The solution allows you to:
- Deploy policies to multiple Azure subscriptions using a single pipeline
- Use different service principals for each subscription
- Configure policy settings through a JSON file
- Automatically read subscription configurations and deploy accordingly

## Files Structure

```
├── policy.json              # Configuration file with subscription details
├── providers.tf             # Terraform provider configuration
├── policy.tf                # Azure policy definition and assignment
├── variables.tf             # Terraform variables and outputs
├── azure-pipelines.yml      # Azure DevOps pipeline definition
└── README.md               # This file
```

## Prerequisites

1. **Azure DevOps Project** with appropriate permissions
2. **Service Connections** configured for each subscription
3. **Azure Storage Account** for Terraform state (optional but recommended)
4. **Variable Group** in Azure DevOps with required variables

## Setup Instructions

### Step 1: Configure Service Connections

1. Go to your Azure DevOps project
2. Navigate to **Project Settings** > **Service Connections**
3. Create service connections for each subscription:
   - Name: `prod-service-connection` (for production)
   - Name: `dev-service-connection` (for development)
   - Name: `test-service-connection` (for testing)
4. Ensure each service connection has appropriate permissions

### Step 2: Create Variable Group

1. Go to **Library** in Azure DevOps
2. Create a new variable group named `azure-credentials`
3. Add the following variables:
   - `tenantId`: Your Azure AD tenant ID
   - `serviceConnectionName`: Name of your default service connection
   - `resourceGroupName`: Resource group for Terraform state
   - `storageAccountName`: Storage account for Terraform state
   - `containerName`: Container name for Terraform state
   - `allowedSubnets`: JSON array of allowed subnets (e.g., `["subnet1", "subnet2"]`)

### Step 3: Update Policy Configuration

Edit `policy.json` with your actual subscription details:

```json
{
  "subscriptions": [
    {
      "subscription_id": "your-actual-subscription-id-1",
      "subscription_name": "Production Subscription",
      "service_principal_name": "prod-service-connection",
      "environment": "production"
    }
  ],
  "policy_settings": {
    "policy_name": "RestrictSubnetDeployment",
    "policy_display_name": "Restrict Resource Deployment to Specific Subnets",
    "policy_description": "This policy restricts deployment of resources to specific subnets only"
  }
}
```

### Step 4: Configure Terraform Backend (Optional)

If you want to use Azure Storage for Terraform state:

1. Create a storage account in Azure
2. Create a container named `terraform-state`
3. Update the pipeline variables with your storage details

### Step 5: Run the Pipeline

1. Commit and push your changes to the main branch
2. The pipeline will automatically trigger
3. Monitor the deployment in Azure DevOps

## How It Works

1. **Configuration Reading**: The pipeline reads `policy.json` to get subscription details
2. **Dynamic Deployment**: For each subscription in the JSON file, it:
   - Uses the specified service connection
   - Passes the subscription ID as a variable
   - Deploys the policy definition and assignment
3. **Parameterization**: All hardcoded values are replaced with variables

## Customization

### Adding New Subscriptions

1. Add a new entry to the `subscriptions` array in `policy.json`
2. Create a corresponding service connection in Azure DevOps
3. The pipeline will automatically pick up the new subscription

### Modifying Policy Rules

Edit the `policy_rule` section in `policy.tf` to change the policy logic.

### Adding New Variables

1. Add variables to `variables.tf`
2. Update the pipeline YAML to pass the new variables
3. Add default values in the variable group if needed

## Troubleshooting

### Common Issues

1. **Service Connection Errors**: Ensure service connections have proper permissions
2. **Variable Group Issues**: Check that all required variables are set
3. **Terraform State Conflicts**: Use different state files for different environments

### Debugging

1. Check pipeline logs for detailed error messages
2. Verify subscription IDs and service connection names
3. Ensure Terraform files are syntactically correct

## Security Considerations

1. Use least-privilege access for service principals
2. Store sensitive information in Azure DevOps variable groups
3. Regularly rotate service principal credentials
4. Use Azure Key Vault for storing secrets (recommended for production)

## Support

For issues or questions:
1. Check the pipeline logs for error details
2. Verify all prerequisites are met
3. Ensure service connections have proper permissions
