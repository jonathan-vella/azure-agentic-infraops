# S05 Deployment Script Customization

## Overview

The `deploy.ps1` script has been customized from the SAIF reference implementation to align with S05 Service Validation scenario naming conventions and workflow.

## Key Customizations

### Resource Naming

**Resource Groups:**

- Pattern: `rg-s05-validation-{region-suffix}`
- Examples:
  - Sweden Central: `rg-s05-validation-swc01`
  - Germany West Central: `rg-s05-validation-gwc01`
  - West Europe: `rg-s05-validation-weu01`
  - North Europe: `rg-s05-validation-neu01`

**Previous (SAIF):** `rg-saifv2-{gwc01|swc01}`

### Region Configuration

**Default Region:** `swedencentral` (changed from `germanywestcentral`)

**Supported Regions:**

- `swedencentral` (default)
- `germanywestcentral`
- `westeurope`
- `northeurope`

Aligns with repository default region policy.

### Tagging

**Application Tag:** `S06-Service-Validation` (default)

- Previous: `SAIF`

**Environment Tag:** `demo`

- Previous: `hackathon`

**Purpose Tag:** `Service Validation and Testing Demo`

- Previous: `Security Training`

### Container Images

**Image Name:** `s05/api:latest`

- Previous: `saifv2/api:latest`

**Build Source:** `../app` (relative to scripts folder)

- Contains SAIF api-v2 application adapted for S05

### Deployment Names

**Deployment Name:** `s05-validation-{timestamp}`

- Previous: `main-v2-{timestamp}`

### User Guidance

**Post-Deployment Output:**
Enhanced with next steps for testing phases:

```
Next Steps:
  1. Run load tests: .\testing\load-testing\Run-LoadTest.ps1
  2. Execute chaos experiments: .\testing\chaos\Run-ChaosExperiment.ps1
  3. Perform UAT: .\testing\uat\Run-UATTests.ps1
```

### Script References

**SQL Configuration Script:** `Configure-SqlAccess.ps1`

- Previous: `Configure-SAIF-SqlAccess.ps1`

## Usage

### Basic Deployment

```powershell
# Deploy to Sweden Central (default)
.\scripts\deploy.ps1

# Deploy to Germany West Central
.\scripts\deploy.ps1 -location germanywestcentral

# Deploy to custom resource group
.\scripts\deploy.ps1 -resourceGroupName "rg-my-validation-test"
```

### Advanced Options

```powershell
# Infrastructure only (skip containers)
.\scripts\deploy.ps1 -skipContainers

# Skip SQL access configuration
.\scripts\deploy.ps1 -skipSqlAccessConfig

# Custom firewall rule and roles
.\scripts\deploy.ps1 -FirewallRuleName "dev-laptop" -GrantRoles db_datareader,db_datawriter

# User-assigned managed identity
.\scripts\deploy.ps1 -UserAssignedClientId "<guid>"
```

## Prerequisites

- ✅ Azure CLI installed (authentication pre-configured)
- ✅ PowerShell 5.1+ or PowerShell Core 7+
- ✅ Docker installed (for container builds)
- ✅ Contributor access to Azure subscription
- ✅ Sufficient quota for:
  - App Service Plan (Premium P1v3)
  - Azure SQL Database (S1 tier)
  - Azure Container Registry (Standard)

## Infrastructure Path

The script references: `../infra/main.bicep` (relative to scripts folder)

**Full Path:** `/scenarios/S06-service-validation/solution/infra/main.bicep`

## Validation

After deployment, verify:

1. **Resource Group Created:**

   ```powershell
   az group show --name rg-s06-validation-swc01 --query "{name:name,location:location,provisioningState:properties.provisioningState}"
   ```

2. **Application Accessible:**

   - API: `https://app-{name}.azurewebsites.net`
   - API Docs: `https://app-{name}.azurewebsites.net/docs`

3. **Managed Identity Configured:**

   ```powershell
   az webapp identity show --name <api-app-name> --resource-group rg-s05-validation-swc01
   ```

4. **SQL Access (for Managed Identity):**

   ```powershell
   # Test SQL whoami endpoint
   curl https://<api-url>/api/sqlwhoami
   ```

## Troubleshooting

### Container Build Fails

```powershell
# Verify Docker is running
docker version

# Verify ACR permissions
az acr login --name <acr-name>
```

### SQL Connection Issues

```powershell
# Run SQL access configuration manually
.\scripts\Configure-SqlAccess.ps1 -location swedencentral -ResourceGroupName rg-s05-validation-swc01
```

### Deployment Timeout

```powershell
# Check deployment status
az deployment group show --name s05-validation-<timestamp> --resource-group rg-s05-validation-swc01

# View deployment logs
az deployment group list --resource-group rg-s05-validation-swc01
```

## Cleanup

```powershell
# Delete all resources
az group delete --name rg-s05-validation-swc01 --yes --no-wait
```

## Related Files

- `deploy.ps1` - Main deployment script
- `Configure-SqlAccess.ps1` - SQL firewall and managed identity configuration
- `Update-Containers.ps1` - Container update script (if exists)
- `../infra/main.bicep` - Infrastructure template (`solution/infra/main.bicep`)
- `../app/` - Application source code (`solution/app/`)
- `../web/` - Web frontend source code (`solution/web/`)

## Time Savings

**Manual Deployment:** 2-3 hours (infrastructure + app + configuration)

**With Script:** 15-20 minutes (fully automated)

**Savings:** 85-90% reduction in deployment time

---

**Note:** This script is based on SAIF Deploy-SAIF-v2.ps1 and has been customized for the S05 Service Validation scenario. For SAIF-specific deployment, refer to the original SAIF repository.
