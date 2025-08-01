# Migration Guide: From Hardcoded to Parameterized

This guide will help you migrate from your current hardcoded Azure DevOps pipeline to the new parameterized solution.

## Current State vs New State

### Before (Hardcoded)
- Subscription IDs hardcoded in `providers.tf`
- Single service principal for all subscriptions
- Manual updates required for each subscription

### After (Parameterized)
- Subscription IDs in `policy.json`
- Different service principal per subscription
- Automatic deployment to all subscriptions

## Migration Steps

### Step 1: Backup Your Current Setup
```bash
# Create a backup of your current files
cp providers.tf providers.tf.backup
cp azure-pipelines.yml azure-pipelines.yml.backup
```

### Step 2: Update policy.json
Replace the placeholder values in `policy.json` with your actual data:

```json
{
  "subscriptions": [
    {
      "subscription_id": "your-actual-prod-subscription-id",
      "subscription_name": "Production Subscription",
      "service_principal_name": "your-prod-service-connection-name",
      "environment": "production",
      "allowed_subnets": [
        "your-actual-prod-subnet-1",
        "your-actual-prod-subnet-2"
      ]
    }
  ]
}
```

### Step 3: Verify Service Connections
Ensure your service connections exist in Azure DevOps:
1. Go to **Project Settings** > **Service Connections**
2. Verify all service connections listed in `policy.json` exist
3. Test each service connection

### Step 4: Test Configuration
Run the validation script:
```powershell
.\test-config.ps1
```

### Step 5: Update Variable Group
In Azure DevOps, update your `azure-credentials` variable group:
- Remove `allowedSubnets` (now in JSON)
- Keep other variables as needed

### Step 6: Deploy
1. Commit your changes
2. Push to trigger the pipeline
3. Monitor the deployment

## Rollback Plan

If you need to rollback:
1. Restore your backup files
2. Revert the pipeline changes
3. Update variable group if needed

## Validation Checklist

- [ ] `policy.json` contains correct subscription IDs
- [ ] Service connections exist and work
- [ ] Subnet names are correct
- [ ] Variable group is updated
- [ ] Test script passes
- [ ] Pipeline runs successfully

## Common Issues

### Issue: Service Connection Not Found
**Solution**: Verify the service connection name in `policy.json` matches exactly with Azure DevOps

### Issue: Invalid Subscription ID
**Solution**: Check the GUID format and ensure the subscription exists

### Issue: Terraform State Conflicts
**Solution**: Use different state files or clear existing state if safe

## Support

If you encounter issues:
1. Check pipeline logs
2. Run the test script
3. Verify all prerequisites are met