# Demo Script: E-Commerce Platform - Full Agent Workflow

> **Duration**: 60-90 minutes (full) or 30-45 minutes (abbreviated)
>
> **Pre-requisites**: VS Code with Copilot, Azure CLI logged in, MCP server running

---

## 🎬 Pre-Demo Setup

### Verify Environment

```powershell
# Check Azure CLI
az account show --query name -o tsv

# Check Bicep
bicep --version

# Check MCP server (if using pricing)
# MCP: List Servers in VS Code Command Palette
```

### Open Files

1. Open VS Code in workspace root
2. Have `scenarios/S04-ecommerce-platform/prompts/workflow-prompts.md` ready
3. Open split view with terminal visible

---

## Part 0: Planning with @plan (5-10 minutes)

### 📝 Setup

1. Open GitHub Copilot Chat (`Ctrl+Alt+I`)
2. Select **Plan** from the agents dropdown
3. This is the **built-in VS Code Plan Agent**

### 💬 Prompt

```text
Create a deployment plan for a multi-tier e-commerce platform on Azure with:

Business Requirements:
- 99.9% SLA for European retail customers
- Handle 10,000 concurrent users during peak sales
- PCI-DSS compliance for payment processing
- Sub-100ms product catalog queries

Technical Requirements:
- React SPA frontend
- .NET 8 REST API backend
- Product catalog with full-text search
- User session caching (10K sessions)
- Async order processing
- CDN and WAF for edge security

Constraints:
- Region: swedencentral (GDPR)
- Budget: Mid-tier (cost-conscious but reliable)
- Team has Azure PaaS experience
```

### ✅ Expected Output

- Implementation phases (4 phases, 4 weeks)
- Service recommendations (App Service, SQL, Redis, etc.)
- Network architecture (3-tier)
- Cost estimate (~$1,250/month initial)
- Open questions for clarification

### 🎙️ Talking Points

> "Notice how the Plan Agent researches comprehensively before suggesting any changes.
> It creates a structured plan we can refine."
>
> "The plan estimates ~$1,250/month - we'll validate this with real-time pricing later."

### ➡️ Transition

Click **"Save Plan"** to create `*.prompt.md` file, then click **"Hand off to
implementation agent"** → Azure Principal Architect

---

## Part 1: Architecture with azure-principal-architect (10-15 minutes)

### 📝 Setup

1. Agent auto-selects from handoff, OR
2. Press `Ctrl+Shift+A` → Select `azure-principal-architect`

### 💬 Prompt (if manual)

```text
Assess this e-commerce platform architecture for Azure Well-Architected Framework alignment:

Requirements:
- 99.9% SLA, 10K concurrent users
- PCI-DSS compliance for payments
- Sub-100ms catalog queries
- swedencentral region (GDPR)

Services being considered:
- App Service P1v4 (zone redundant)
- Azure SQL S3 (100 DTU)
- Azure Cognitive Search S1
- Azure Cache for Redis C2
- Service Bus Premium (private endpoints)
- Azure Front Door Premium (WAF)
- Azure Functions EP1 (order processing)

Provide WAF scores and any compliance gaps.
```

### ✅ Expected Output

**WAF Scores:**

| Pillar                 | Score      | Notes                          |
| ---------------------- | ---------- | ------------------------------ |
| Security               | 9/10       | PCI-DSS aligned, PE everywhere |
| Reliability            | 8/10       | Zone redundant compute         |
| Performance            | 8/10       | Search + Redis for speed       |
| Cost Optimization      | 7/10       | Premium tiers needed           |
| Operational Excellence | 8/10       | Full monitoring stack          |
| **Overall**            | **8.0/10** |                                |

### 🎙️ Talking Points

> "The architect gives us an 8.0/10 WAF score - solid for production.
> Security scores high because of private endpoints and Azure AD-only auth."
>
> "Notice Cost Optimization at 7/10 - that's the trade-off for PCI-DSS.
> Premium Service Bus is required for private endpoints."

### ➡️ Transition

**Say**: "Before we implement, let's validate the costs with real Azure pricing..."

---

## Part 2a: Real-Time Pricing with MCP (5 minutes)

### 📝 Setup

1. Ensure Azure Pricing MCP server is running
2. Open Copilot Chat (MCP tools auto-available)

### 💬 Prompt

```text
Use the Azure Pricing MCP tools to get real-time pricing for our e-commerce platform:
- App Service P1v4 (Linux, zone-redundant) in swedencentral
- Azure Functions EP1
- Azure SQL S3 (100 DTU)
- Azure Cache for Redis C2
- Azure Cognitive Search S1
- Service Bus Premium
- Azure Front Door Premium (PCI-DSS WAF)
```

### ✅ Expected Output

| Service                | SKU          | Monthly Cost |
| ---------------------- | ------------ | ------------ |
| App Service Plan (×2)  | P1v4 Linux   | $411.72      |
| Azure Functions        | EP1          | $123.37      |
| Azure Cognitive Search | S1           | $245.28      |
| Azure SQL Database     | S3 (100 DTU) | $145.16      |
| Azure Cache for Redis  | C2 Basic     | $65.70       |
| Service Bus            | Premium 1 MU | $677.08      |
| Azure Front Door       | Premium_AFD  | $330.00      |
| Private Endpoints (×5) | -            | $36.50       |
| Key Vault + Logging    | Standard     | $18.00       |
| **TOTAL**              | -            | **~$1,595**  |

### 🎙️ Talking Points

> "Real-time pricing from Azure API - more accurate than initial estimates.
> We're at ~$1,595/month, about $345 higher than the initial plan estimate."
>
> "The difference is mainly Front Door Premium ($330 vs $100) - required for PCI-DSS WAF with managed rules."
>
> "We can save $2,030/year with 3-year reserved instances - 32% on compute costs."

---

## Part 2b: Architecture Diagram (5 minutes)

### 📝 Setup

1. Press `Ctrl+Shift+A` → Select `diagram-generator`

### 💬 Prompt

```text
Generate a Python architecture diagram for our e-commerce platform:

Components:
- Azure Front Door Premium with WAF (edge)
- Static Web App for React SPA
- App Service P1v4 for .NET API (web tier)
- Azure SQL, Redis, Cognitive Search, Key Vault (data tier)
- Azure Functions EP1 + Service Bus Premium (integration tier)
- VNet with 3 subnets (web, data, integration)
- Log Analytics + App Insights (monitoring)

Use the diagrams library. Show the 3-tier network architecture with private endpoints.
Save to scenarios/scenario-output/ecommerce/architecture.py
```

### ✅ Expected Output

- Python file: `architecture.py`
- PNG image: `ecommerce_architecture.png`
- Visual showing 3-tier architecture with all components

### 🎙️ Talking Points

> "This diagram is generated from our architecture context - perfect for documentation and stakeholder presentations."
>
> "Notice the clear separation: Edge (Front Door) → Web (App Service) → Data (SQL, Redis) → Integration (Functions,
> Service Bus)."

---

## Part 3: Bicep Planning with bicep-plan (10 minutes)

### 📝 Setup

1. Press `Ctrl+Shift+A` → Select `bicep-plan`

### 💬 Prompt

```text
Create an implementation plan for the e-commerce platform Bicep templates.

Resources to deploy:
- VNet with 3 subnets (web 10.0.1.0/24, data 10.0.2.0/24, integration 10.0.3.0/24)
- 3 NSGs with PCI-DSS compliant rules (deny-by-default)
- Private DNS zones for all private endpoints
- Key Vault with private endpoint
- App Service Plan P1v4 (zone redundant)
- App Service with VNet integration
- Azure SQL with Azure AD-only auth
- Redis Cache with private endpoint
- Cognitive Search with private endpoint
- Service Bus Premium with private endpoint
- Azure Functions EP1 with VNet integration
- Front Door Premium with WAF policy
- Static Web App
- Log Analytics + App Insights
- RBAC role assignments

Use 4 deployment phases. Output to .bicep-planning-files/
```

### ✅ Expected Output

- 4-phase deployment strategy
- 18 module specifications
- Dependency diagram (Mermaid)
- Cost estimation table

### 🎙️ Talking Points

> "The plan breaks down into 4 phases: Foundation → Platform → Application → Edge/Monitoring."
>
> "This phased approach helps isolate issues and provides clear rollback points."

---

## Part 4: Bicep Implementation with bicep-implement (15-20 minutes)

### 📝 Setup

1. Press `Ctrl+Shift+A` → Select `bicep-implement`

### 💬 Prompt

```text
Generate Bicep templates from the e-commerce implementation plan.

Key requirements:
- Subscription scope for main.bicep
- Generate uniqueSuffix in main.bicep, pass to all modules
- Key Vault names ≤24 chars
- P1v4 App Service Plan (Linux, zone redundant)
- Front Door Premium (PCI-DSS WAF)
- Azure AD-only SQL auth
- Private endpoints for all data services
- Output to infra/bicep/ecommerce/

Include deploy.ps1 with:
- What-if support
- Bicep validation (build + lint)
- Auto-detect SQL admin identity
- Professional output formatting
```

### ✅ Expected Output

- 18 Bicep modules
- `main.bicep` orchestrator
- `main.bicepparam` parameter file
- `deploy.ps1` deployment script

### 🎙️ Talking Points

> "Notice the unique suffix generation in main.bicep - this prevents naming collisions for
> globally unique resources like Key Vault and Storage."
>
> "All modules follow CAF naming conventions with region abbreviations."

### 🔧 Validate Templates

```powershell
cd infra/bicep/ecommerce
bicep build main.bicep --stdout --no-restore
bicep lint main.bicep
```

---

## Part 5: Deployment (10-15 minutes)

### 📝 What-If Preview

```powershell
cd infra/bicep/ecommerce
.\deploy.ps1 -WhatIf
```

### ✅ Expected Output

```text
╔═══════════════════════════════════════════════════════════════════════╗
║   E-COMMERCE PLATFORM - Azure Deployment                              ║
╚═══════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────────────────────────────────────────────────┐
  │  DEPLOYMENT CONFIGURATION                                          │
  └────────────────────────────────────────────────────────────────────┘
    Environment .......... prod
    Location ............. swedencentral
    Resource Group ....... rg-ecommerce-prod

  [1/3] Validating Bicep templates...
      └─ ✓ bicep build passed
      └─ ✓ bicep lint passed (0 errors)

  [2/3] Running what-if analysis...
      └─ + Create: 61 resources

  ⚠ WHAT-IF MODE - No changes will be made
```

### 📝 Deploy (if approved)

```powershell
.\deploy.ps1
```

### 🎙️ Talking Points

> "The deployment script validates templates before any Azure changes.
> Lint warnings are shown but don't block deployment."
>
> "61 resources will be created - that's a full enterprise-grade e-commerce platform in under 15 minutes."

---

## Wrap-Up (3 minutes)

### 📊 Summary Metrics

| Metric                  | Traditional  | With Agents | Savings |
| ----------------------- | ------------ | ----------- | ------- |
| Architecture Assessment | 4 hours      | 30 min      | 87%     |
| Bicep Modules (18)      | 16 hours     | 2 hours     | 88%     |
| Cost Estimation         | 1 hour       | 10 min      | 83%     |
| Deploy Script           | 2 hours      | 30 min      | 75%     |
| **Total**               | **23 hours** | **3 hours** | **87%** |

### 🎯 Key Takeaways

1. **Real-time pricing** validates budget before implementation
2. **PCI-DSS patterns** built-in (private endpoints, WAF, encryption)
3. **Modular templates** ready for environment variants (dev/staging/prod)
4. **Professional deployment** with validation and confirmation

### 💡 Next Steps for Audience

1. Try `@plan` with your next infrastructure project
2. Set up Azure Pricing MCP for accurate cost estimates
3. Use `diagram-generator` for stakeholder documentation
4. Reference the issue solutions when you hit Bicep errors

---

## 🛠️ Troubleshooting

### MCP Server Not Found

```powershell
# Verify MCP configuration
cat .vscode/mcp.json

# Restart MCP servers
# Command Palette → MCP: Restart Servers
```

### Bicep Lint Errors

```powershell
# Auto-fix if possible
bicep lint main.bicep --fix

# Common fixes:
# - Remove unnecessary dependsOn (use symbolic references)
# - Add @description to parameters
```

### Deployment Fails

```powershell
# Check resource group exists
az group show --name rg-ecommerce-prod

# Check quota
az vm list-usage --location swedencentral -o table

# Try germanywestcentral if quota issues
.\deploy.ps1 -Location germanywestcentral
```

---

**Version**: 1.0.0
**Last Updated**: December 4, 2025
