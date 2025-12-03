# Contoso Healthcare Patient Portal - Bicep Infrastructure

> **Version 3.0.0** | Last Updated: December 3, 2025

This directory contains Bicep templates for deploying a HIPAA-compliant patient portal infrastructure on Azure.

## 📋 Overview

The infrastructure includes:

- **Networking**: Virtual Network with segmented subnets and Network Security Groups
- **Compute**: Azure App Service Plan (Standard S1, zone-redundant)
- **Database**: Azure SQL Database (Standard S2) with TDE encryption
- **Security**: Azure Key Vault with private endpoints and managed identities
- **Monitoring**: Log Analytics Workspace and Application Insights

**Estimated Monthly Cost**: See Azure Pricing Calculator for current rates (varies by region)

## 🏗️ Architecture

```text
Internet → App Service (VNet Integrated)
            ↓ (Managed Identity)
            → Key Vault (Private Endpoint)
            → SQL Database (Private Endpoint)
            → Application Insights
```

## 📁 File Structure

```bicep
contoso-patient-portal/
├── main.bicep                      # Main orchestration template
├── main.bicepparam                 # Production parameters file
├── deploy.ps1                      # Deployment script
├── README.md                       # This file
└── modules/
    ├── networking.bicep            # VNet, subnets, NSGs
    ├── monitoring.bicep            # Log Analytics, App Insights
    ├── app-service-plan.bicep      # App Service Plan
    ├── app-service.bicep           # App Service with managed identity
    ├── sql-server.bicep            # SQL Server logical server
    ├── sql-database.bicep          # SQL Database with TDE
    ├── key-vault.bicep             # Key Vault with RBAC
    ├── private-endpoints.bicep     # Private endpoints for Key Vault & SQL
    ├── key-vault-secrets.bicep     # Secrets storage
    └── rbac-assignments.bicep      # RBAC role assignments
```

## 🚀 Quick Start

### Prerequisites

- **Azure CLI**: Version 2.50.0+ ([Install](https://aka.ms/azure-cli))
- **Bicep CLI**: Version 0.20.0+ (run `az bicep install`)
- **PowerShell**: Version 7.0+ ([Install](https://aka.ms/powershell))
- **Azure Subscription**: With Contributor access

### Deployment

**Option 1: Using PowerShell Script (Recommended)**

```powershell
# Navigate to template directory
cd infra/bicep/contoso-patient-portal

# Run deployment script (will prompt for SQL password)
.\deploy.ps1 -Environment prod -Location eastus2

# Or provide password inline
.\deploy.ps1 -Environment prod -Location eastus2 -SqlAdminPassword (ConvertTo-SecureString 'YourSecurePassword123!' -AsPlainText -Force)

# What-if analysis (dry run)
.\deploy.ps1 -WhatIf
```

> **Note**: If `-SqlAdminPassword` is not provided, the script will interactively prompt for a password. Password requirements: 8+ characters, uppercase, lowercase, and number.

**Option 2: Using Azure CLI**

```powershell
# Validate template
az bicep build --file main.bicep --stdout

# What-if analysis
az deployment sub what-if `
  --name contoso-patient-portal-prod `
  --location eastus2 `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --parameters sqlAdminPassword='YourSecurePassword123!'

# Deploy
az deployment sub create `
  --name contoso-patient-portal-prod `
  --location eastus2 `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --parameters sqlAdminPassword='YourSecurePassword123!'
```

## 🔒 Security Features

### HIPAA Compliance

- ✅ **Encryption at Rest**: TDE for SQL Database, Key Vault for secrets
- ✅ **Encryption in Transit**: TLS 1.2 minimum, HTTPS-only enforced
- ✅ **Network Isolation**: Private endpoints for data-tier services
- ✅ **Audit Logging**: All operations logged to Log Analytics
- ✅ **Access Control**: RBAC with managed identities (no passwords)
- ✅ **Backup & Recovery**: 35-day retention, geo-redundant backups

### Security Defaults

- **App Service**: HTTPS only, TLS 1.2, FTP disabled, Always On enabled
- **SQL Server**: Public access disabled, TLS 1.2 minimum, Entra ID auth supported
- **Key Vault**: Soft delete (90 days), purge protection, RBAC enabled, public access disabled
- **NSGs**: Deny-all default rules with explicit allow for required ports only

## 📊 Deployment Phases

The deployment follows a 4-phase approach:

### Phase 1: Foundation & Networking (5-10 minutes)

- Resource Group
- Virtual Network with 3 subnets
- Network Security Groups

### Phase 2: Platform Services (10-15 minutes)

- App Service Plan
- SQL Server (logical server)
- Key Vault
- Log Analytics Workspace
- Application Insights

### Phase 3: Security & Application (10-15 minutes)

- SQL Database
- Private Endpoints (Key Vault, SQL Server)
- App Service deployment
- VNet integration

### Phase 4: Configuration (5 minutes)

- Key Vault secrets
- RBAC role assignments
- App Service settings

**Total Deployment Time**: 30-45 minutes

## 🧪 Validation

### Pre-Deployment Validation

```powershell
# Bicep build
bicep build main.bicep --stdout --no-restore

# Bicep lint
bicep lint main.bicep

# What-if analysis
az deployment sub what-if --location eastus2 --template-file main.bicep --parameters main.bicepparam
```

### Post-Deployment Validation

```powershell
# Check resource group
az group show --name rg-contoso-patient-portal-prod

# Test App Service
$appUrl = az webapp show --name app-contoso-patient-portal-prod --resource-group rg-contoso-patient-portal-prod --query defaultHostName -o tsv
curl "https://$appUrl"

# Test Key Vault connectivity
az keyvault secret list --vault-name <keyvault-name>

# Test SQL Database connectivity (requires firewall rule or private endpoint access)
# Use Azure Data Studio or SQL Server Management Studio with Entra ID authentication
```

## 💰 Cost Management

### Resource Configuration

| Resource          | SKU           | Quantity    | Notes                     |
| ----------------- | ------------- | ----------- | ------------------------- |
| App Service Plan  | Standard S1   | 2 instances | Zone-redundant deployment |
| SQL Database      | Standard S2   | 1           | TDE encryption enabled    |
| Key Vault         | Standard      | 1           | RBAC-enabled              |
| Private Endpoints | Standard      | 2           | Key Vault & SQL           |
| Log Analytics     | Pay-as-you-go | 5-10 GB     | Application monitoring    |

**Cost Estimation**: Use [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) for current regional pricing.

### Cost Optimization Recommendations

- **Reserved Instances**: Save 30-50% with 1-3 year App Service reservations
- **SQL Serverless**: Consider serverless tier for dev/staging environments (save ~40%)
- **Log Analytics**: Use commitment tier if ingestion exceeds 100 GB/month
- **Dev/Test Pricing**: Use B-series SKUs for non-production environments

## 🛠️ Customization

### Environment-Specific Parameters

Create additional parameter files for different environments:

**Development** (`main.dev.bicepparam`):

```bicep
using './main.bicep'

param environment = 'dev'
param location = 'eastus2'
param projectName = 'contoso-patient-portal'
// Use lower SKUs for cost savings
```

**Staging** (`main.staging.bicepparam`):

```bicep
using './main.bicep'

param environment = 'staging'
param location = 'eastus2'
param projectName = 'contoso-patient-portal'
```

### Modify Resources

Edit module files in `modules/` directory:

- **Change App Service Plan SKU**: Edit `modules/app-service-plan.bicep`
- **Adjust SQL Database tier**: Edit `modules/sql-database.bicep`
- **Add custom NSG rules**: Edit `modules/networking.bicep`
- **Configure additional secrets**: Edit `modules/key-vault-secrets.bicep`

## 🔧 Troubleshooting

### Common Issues

**Issue**: Bicep build fails with module not found error

```yaml
Solution: Run `bicep restore main.bicep` to download AVM modules
```

**Issue**: SQL Server name already exists

```yaml
Solution:
  SQL Server names are globally unique. The template includes uniqueString()
  to generate unique names. If deployment fails, delete failed resources and retry.
```

**Issue**: Private endpoint deployment fails

```yaml
Solution: Ensure Key Vault and SQL Server are deployed first. Check that subnet
  has privateEndpointNetworkPolicies set to 'Disabled'.
```

**Issue**: App Service can't access Key Vault

```yaml
Solution:
  Verify RBAC role assignment completed. App Service needs 'Key Vault Secrets User'
  role. Check managed identity is enabled and role assignment exists.
```

### Rollback

**Delete entire deployment**:

```powershell
az group delete --name rg-contoso-patient-portal-prod --yes --no-wait
```

**Delete specific resource**:

```powershell
az resource delete --ids <resource-id>
```

## 📚 Additional Resources

- [Implementation Plan](.bicep-planning-files/INFRA.contoso-patient-portal.md)
- [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/)
- [HIPAA Compliance on Azure](https://learn.microsoft.com/azure/compliance/offerings/offering-hipaa-us)
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)

## 📝 Notes

- **SQL Password Security**: Never commit passwords to source control. Use environment variables, Azure Key Vault, or Azure DevOps secure variables.
- **Private Endpoints**: Requires VPN or Bastion for management access when public access is disabled.
- **Zone Redundancy**: Available in limited regions. Check [Azure regions documentation](https://azure.microsoft.com/global-infrastructure/geographies/).
- **HIPAA BAA**: Automatically included for all in-scope Azure services when using Azure for healthcare.

## 🤝 Contributing

This infrastructure is part of the [azure-agentic-infraops](../../) repository demonstrating GitHub Copilot capabilities for IT professionals.

For issues or improvements, please create an issue in the main repository.

---

**Generated by**: GitHub Copilot with bicep-implement agent  
**Date**: November 18, 2025  
**Version**: 1.0.0
