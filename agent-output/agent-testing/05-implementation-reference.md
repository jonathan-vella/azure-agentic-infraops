# Step 5: Implementation Reference - Agent Testing Framework

> **Status**: ✅ Complete | **Step**: 5 of 7 (bicep-code)
>
> This document links the implementation plan to the generated Bicep code.

---

## Bicep Templates Location

📁 **Code Location**: [`infra/bicep/agent-testing/`](../../infra/bicep/agent-testing/)

## File Structure

```
infra/bicep/agent-testing/
├── main.bicep                      # Orchestration template
├── main.bicepparam                 # Parameter file (swedencentral)
├── deploy.ps1                      # Deployment script with what-if
└── modules/
    ├── static-web-app.bicep        # Scenario 1: SWA
    ├── app-service-plan.bicep      # Scenario 2: Compute tier
    ├── app-service.bicep           # Scenario 2: Web app
    ├── sql-database.bicep          # Scenario 2: Database
    ├── key-vault.bicep             # Secrets management
    ├── storage-account.bicep       # Scenario 3: Blob storage
    ├── container-apps-env.bicep    # Scenario 3: Serverless containers
    ├── service-bus.bicep           # Scenario 3: Messaging
    └── automation-cleanup.bicep    # TTL-based cleanup
```

## Validation Status

| Check         | Status    |
| ------------- | --------- |
| `bicep build` | ✅ Passed |
| `bicep lint`  | ✅ Passed |

## Resources Created

| Resource                   | Bicep Type                                    | Module                     |
| -------------------------- | --------------------------------------------- | -------------------------- |
| Static Web App (Free)      | Microsoft.Web/staticSites                     | `static-web-app.bicep`     |
| App Service Plan (B1)      | Microsoft.Web/serverfarms                     | `app-service-plan.bicep`   |
| App Service                | Microsoft.Web/sites                           | `app-service.bicep`        |
| Azure SQL Server           | Microsoft.Sql/servers                         | `sql-database.bicep`       |
| Azure SQL Database (Basic) | Microsoft.Sql/servers/databases               | `sql-database.bicep`       |
| Key Vault (Standard)       | Microsoft.KeyVault/vaults                     | `key-vault.bicep`          |
| Storage Account (LRS)      | Microsoft.Storage/storageAccounts             | `storage-account.bicep`    |
| Container Apps Environment | Microsoft.App/managedEnvironments             | `container-apps-env.bicep` |
| Container App              | Microsoft.App/containerApps                   | `container-apps-env.bicep` |
| Service Bus (Basic)        | Microsoft.ServiceBus/namespaces               | `service-bus.bicep`        |
| Log Analytics Workspace    | Microsoft.OperationalInsights/workspaces      | `container-apps-env.bicep` |
| Automation Account         | Microsoft.Automation/automationAccounts       | `automation-cleanup.bicep` |

---

## Deployment Instructions

### Prerequisites

```bash
# Verify tools
az version
bicep --version

# Authenticate
az login
az account set --subscription "noalz"
```

### Deploy All Scenarios

```powershell
cd infra/bicep/agent-testing
./deploy.ps1 -Environment test -Scenario All
```

### Deploy Single Scenario

```powershell
# Scenario 1: Static Web Apps only
./deploy.ps1 -Scenario SWA

# Scenario 2: Multi-tier only
./deploy.ps1 -Scenario MultiTier

# Scenario 3: Microservices only
./deploy.ps1 -Scenario Microservices
```

### What-If Mode

```powershell
./deploy.ps1 -WhatIf
```

---

## Configuration Parameters

| Parameter                      | Default         | Description                      |
| ------------------------------ | --------------- | -------------------------------- |
| `environment`                  | `test`          | Always "test" for this framework |
| `location`                     | `swedencentral` | Primary Azure region             |
| `projectName`                  | `agent-testing` | Resource naming prefix           |
| `deployScenario1Swa`           | `true`          | Deploy SWA resources             |
| `deployScenario2MultiTier`     | `true`          | Deploy multi-tier resources      |
| `deployScenario3Microservices` | `true`          | Deploy microservices resources   |
| `deployCleanupAutomation`      | `true`          | Deploy TTL cleanup automation    |

---

## Validation Results

```
bicep build main.bicep: ✅ Passed
bicep lint main.bicep:  ✅ Passed (0 warnings)
```

---

## Next Steps

1. **Step 6: Deploy** - Run `./deploy.ps1` to deploy infrastructure
2. **Step 7: Documentation** - Generate as-built artifacts after deployment

---

## Related Documents

| Document                                                       | Purpose                     |
| -------------------------------------------------------------- | --------------------------- |
| [01-requirements.md](01-requirements.md)                       | Test framework requirements |
| [02-architecture-assessment.md](02-architecture-assessment.md) | WAF assessment              |
| [03-des-cost-estimate.md](03-des-cost-estimate.md)             | Cost breakdown              |
| [04-implementation-plan.md](04-implementation-plan.md)         | Implementation details      |
