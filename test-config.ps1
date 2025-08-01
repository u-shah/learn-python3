# Test Configuration Script
# This script validates your policy.json configuration

param(
    [string]$ConfigPath = "policy.json"
)

Write-Host "Testing Azure Policy Configuration..." -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Check if policy.json exists
if (-not (Test-Path $ConfigPath)) {
    Write-Host "ERROR: $ConfigPath not found!" -ForegroundColor Red
    exit 1
}

try {
    # Read and parse the JSON file
    $config = Get-Content -Path $ConfigPath | ConvertFrom-Json
    
    Write-Host "✓ Configuration file loaded successfully" -ForegroundColor Green
    
    # Validate subscriptions
    if ($config.subscriptions) {
        Write-Host "`nSubscriptions found: $($config.subscriptions.Count)" -ForegroundColor Yellow
        foreach ($sub in $config.subscriptions) {
            Write-Host "  - $($sub.subscription_name) ($($sub.subscription_id))" -ForegroundColor Cyan
            Write-Host "    Service Connection: $($sub.service_principal_name)" -ForegroundColor Gray
            Write-Host "    Environment: $($sub.environment)" -ForegroundColor Gray
        }
    } else {
        Write-Host "WARNING: No subscriptions found in configuration" -ForegroundColor Yellow
    }
    
    # Validate policy settings
    if ($config.policy_settings) {
        Write-Host "`nPolicy Settings:" -ForegroundColor Yellow
        Write-Host "  - Name: $($config.policy_settings.policy_name)" -ForegroundColor Cyan
        Write-Host "  - Display Name: $($config.policy_settings.policy_display_name)" -ForegroundColor Cyan
        Write-Host "  - Description: $($config.policy_settings.policy_description)" -ForegroundColor Cyan
    } else {
        Write-Host "WARNING: No policy settings found in configuration" -ForegroundColor Yellow
    }
    
    # Validate subscription IDs format
    Write-Host "`nValidating subscription IDs..." -ForegroundColor Yellow
    foreach ($sub in $config.subscriptions) {
        if ($sub.subscription_id -match "^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$") {
            Write-Host "  ✓ $($sub.subscription_name): Valid GUID format" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $($sub.subscription_name): Invalid GUID format" -ForegroundColor Red
        }
    }
    
    Write-Host "`nConfiguration validation completed!" -ForegroundColor Green
    
} catch {
    Write-Host "ERROR: Failed to parse JSON configuration" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Check for required Azure DevOps variables
Write-Host "`nRequired Azure DevOps Variables:" -ForegroundColor Yellow
$requiredVars = @(
    "tenantId",
    "serviceConnectionName", 
    "resourceGroupName",
    "storageAccountName",
    "containerName",
    "allowedSubnets"
)

foreach ($var in $requiredVars) {
    Write-Host "  - $var" -ForegroundColor Cyan
}

Write-Host "`nMake sure these variables are configured in your Azure DevOps variable group 'azure-credentials'" -ForegroundColor Yellow