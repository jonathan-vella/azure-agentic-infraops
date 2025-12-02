# E-Commerce Platform Infrastructure

PCI-DSS compliant multi-tier e-commerce platform deployed to Azure using Bicep.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Azure Front Door + WAF                          │
│                              (Global Load Balancing)                         │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                    ┌───────────────────┴───────────────────┐
                    ▼                                       ▼
        ┌───────────────────┐                   ┌───────────────────┐
        │   Static Web App  │                   │    App Service    │
        │    (React SPA)    │                   │   (.NET 8 API)    │
        └───────────────────┘                   └───────────────────┘
                                                         │
                    ┌────────────────────────────────────┼────────────────────┐
                    ▼                    ▼               ▼                    ▼
            ┌─────────────┐    ┌─────────────┐   ┌─────────────┐    ┌─────────────┐
            │  Key Vault  │    │  Azure SQL  │   │    Redis    │    │   Search    │
            │  (Secrets)  │    │  (S3 100DTU)│   │    (C2)     │    │    (S1)     │
            └─────────────┘    └─────────────┘   └─────────────┘    └─────────────┘
                                                         │
                                                         ▼
                                              ┌───────────────────┐
                                              │   Service Bus     │
                                              │    (Premium)      │
                                              └───────────────────┘
                                                         │
                                                         ▼
                                              ┌───────────────────┐
                                              │  Azure Functions  │
                                              │  (Order Processor)│
                                              └───────────────────┘
```

## Prerequisites

- Azure CLI 2.50+
- Bicep CLI 0.20+
- PowerShell 7+
- Azure subscription with Contributor access
- Azure AD group for SQL Server administration

## Quick Start

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "<subscription-id>"

# Deploy
./deploy.ps1 \
  -ResourceGroupName "rg-ecommerce-prod-swc" \
  -SqlAdminGroupObjectId "<your-azure-ad-group-object-id>"
```

## Deployment Options

### What-If Analysis (Preview Changes)

```bash
./deploy.ps1 \
  -ResourceGroupName "rg-ecommerce-prod-swc" \
  -SqlAdminGroupObjectId "<group-id>" \
  -WhatIf
```

### Development Environment

```bash
./deploy.ps1 \
  -ResourceGroupName "rg-ecommerce-dev-swc" \
  -Environment "dev" \
  -SqlAdminGroupObjectId "<group-id>"
```

### Alternative Region (Germany)

```bash
./deploy.ps1 \
  -ResourceGroupName "rg-ecommerce-prod-gwc" \
  -Location "germanywestcentral" \
  -SqlAdminGroupObjectId "<group-id>"
```

## File Structure

```
infra/bicep/ecommerce/
├── main.bicep              # Main orchestration template
├── main.bicepparam         # Production parameters
├── deploy.ps1              # Deployment script
├── README.md               # This file
└── modules/
    ├── network.bicep       # VNet + Subnets
    ├── nsg.bicep           # Network Security Groups
    ├── private-dns.bicep   # Private DNS Zones
    ├── key-vault.bicep     # Key Vault + Private Endpoint
    ├── sql.bicep           # SQL Server + Database + PE
    ├── redis.bicep         # Redis Cache + PE
    ├── app-service-plan.bicep
    ├── app-service.bicep   # .NET 8 API
    ├── cognitive-search.bicep
    ├── service-bus.bicep   # Premium + Orders Queue
    ├── functions-plan.bicep
    ├── functions.bicep     # Order Processor
    ├── rbac.bicep          # Role Assignments
    ├── log-analytics.bicep
    ├── app-insights.bicep
    ├── waf-policy.bicep
    ├── front-door.bicep
    ├── static-web-app.bicep
    └── diagnostics.bicep
```

## Resource Summary

| Phase | Resources                                    | Purpose                                  |
| ----- | -------------------------------------------- | ---------------------------------------- |
| 1     | VNet, NSGs, Subnets                          | Network foundation with segmentation     |
| 2     | Key Vault, SQL, Redis, ASP                   | Platform services with private endpoints |
| 3     | App Service, Search, Service Bus, Functions  | Application tier                         |
| 4     | Front Door, WAF, Log Analytics, App Insights | Edge & monitoring                        |

## Cost Estimate

| Resource         | SKU                | Monthly Cost      |
| ---------------- | ------------------ | ----------------- |
| App Service Plan | P1v3 (2 instances) | $276              |
| SQL Database     | S3 (100 DTU)       | $150              |
| Redis Cache      | Standard C2        | $170              |
| Cognitive Search | Standard S1        | $250              |
| Service Bus      | Premium (1 MU)     | $668              |
| Functions Plan   | EP1                | $173              |
| Front Door       | Standard           | $35               |
| Static Web App   | Standard           | $9                |
| Log Analytics    | ~5GB/day           | $50               |
| **Total**        |                    | **~$1,781/month** |

## Security Features

- ✅ All data services use private endpoints
- ✅ Azure AD-only authentication for SQL Server
- ✅ TLS 1.2 minimum on all services
- ✅ WAF with OWASP 2.1 rule set
- ✅ Managed identities for service-to-service auth
- ✅ NSGs with deny-by-default rules
- ✅ 90-day log retention for PCI-DSS compliance

## Validation Commands

```bash
# Build and validate
bicep build main.bicep
bicep lint main.bicep

# Check deployment status
az deployment group show \
  --name <deployment-name> \
  --resource-group rg-ecommerce-prod-swc

# List resources
az resource list \
  --resource-group rg-ecommerce-prod-swc \
  --output table

# Test Front Door endpoint
curl -I https://<endpoint>.azurefd.net/api/health
```

## Troubleshooting

### Key Vault Name Collision

Key Vault names are globally unique. If deployment fails due to name conflict:

```bash
# Check for soft-deleted vaults
az keyvault list-deleted --query "[].name"

# Purge if needed (irreversible!)
az keyvault purge --name <vault-name>
```

### SQL AAD Authentication Issues

Ensure the Azure AD group exists and has the correct object ID:

```bash
az ad group show --group "sql-admins" --query id
```

### Private Endpoint DNS Resolution

Verify DNS zones are linked to VNet:

```bash
az network private-dns link vnet list \
  --zone-name privatelink.database.windows.net \
  --resource-group rg-ecommerce-prod-swc
```

## Clean Up

```bash
# Delete all resources (use with caution!)
az group delete --name rg-ecommerce-prod-swc --yes --no-wait
```

## Next Steps After Deployment

1. **Configure SQL AAD access**: Add application managed identities to SQL database
2. **Deploy application code**: Push .NET 8 API to App Service
3. **Deploy frontend**: Connect Static Web App to GitHub repo
4. **Configure custom domains**: Add custom domains to Front Door
5. **Set up alerts**: Create Azure Monitor alert rules
6. **Enable backup**: Configure Azure Backup for SQL database
