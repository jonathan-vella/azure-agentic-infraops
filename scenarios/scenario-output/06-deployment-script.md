# Step 7: Enhanced Deployment Script

> **Files Created:** `deploy.ps1`  
> **Purpose:** Professional deployment automation with visual formatting and user experience

---

## 💬 Prompt

```text
Can we make the deployment script look better? I want professional formatting with:
- ASCII art banner for branding
- Boxed sections for organization
- Numbered progress steps
- Color-coded status messages
- Change summary from what-if analysis
- Auto-detect SQL admin identity
```

---

## ✅ Enhanced Deploy.ps1 Features

### 1. ASCII Art Banner

```powershell
Write-Host @"
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                                                                       ║
    ║   ███████╗       ██████╗ ██████╗ ███╗   ███╗███╗   ███╗███████╗       ║
    ║   ██╔════╝      ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔════╝       ║
    ║   █████╗  █████╗██║     ██║   ██║██╔████╔██║██╔████╔██║█████╗         ║
    ║   ██╔══╝  ╚════╝██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══╝         ║
    ║   ███████╗      ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║███████╗       ║
    ║   ╚══════╝       ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝       ║
    ║                                                                       ║
    ║          Azure Infrastructure Deployment                              ║
    ║          PCI-DSS Compliant E-Commerce Platform                        ║
    ║                                                                       ║
    ╚═══════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan
```

---

### 2. Deployment Configuration Box

```powershell
Write-Host "  ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
Write-Host "  │  DEPLOYMENT CONFIGURATION                                          │" -ForegroundColor DarkGray
Write-Host "  ├────────────────────────────────────────────────────────────────────┤" -ForegroundColor DarkGray
Write-Host "  │  Resource Group   : rg-ecommerce-prod-swc                          │" -ForegroundColor Cyan
Write-Host "  │  Location         : swedencentral                                  │" -ForegroundColor Cyan
Write-Host "  │  Environment      : PROD                                           │" -ForegroundColor Red
Write-Host "  └────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkGray
```

---

### 3. Numbered Progress Steps

```powershell
function Write-Step {
    param([string]$Message, [int]$StepNumber, [int]$TotalSteps)
    Write-Host "  [$StepNumber/$TotalSteps] " -ForegroundColor DarkGray -NoNewline
    Write-Host $Message -ForegroundColor Yellow
}

function Write-SubStep {
    param([string]$Message)
    Write-Host "      └─ " -ForegroundColor DarkGray -NoNewline
    Write-Host $Message -ForegroundColor Gray
}

# Usage:
Write-Step "Checking Azure CLI installation..." -StepNumber 1 -TotalSteps 3
Write-SubStep "Azure CLI found"
Write-SubStep "Bicep CLI ready"
```

**Output:**

```
  [1/3] Checking Azure CLI installation...
      └─ Azure CLI found
      └─ Bicep CLI ready
```

---

### 4. Color-Coded Status Messages

```powershell
function Write-Success {
    param([string]$Message)
    Write-Host "  ✓ " -ForegroundColor Green -NoNewline
    Write-Host $Message -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "  ⚠ " -ForegroundColor Yellow -NoNewline
    Write-Host $Message -ForegroundColor Yellow
}

function Write-ErrorMessage {
    param([string]$Message)
    Write-Host "  ✗ " -ForegroundColor Red -NoNewline
    Write-Host $Message -ForegroundColor Red
}

function Write-Info {
    param([string]$Label, [string]$Value)
    Write-Host "      • " -ForegroundColor DarkGray -NoNewline
    Write-Host "$Label`: " -ForegroundColor Gray -NoNewline
    Write-Host $Value -ForegroundColor Cyan
}
```

---

### 5. What-If Change Summary

```powershell
# Parse what-if output for resource counts
$whatIfText = $whatIfResult -join "`n"
$createCount = [regex]::Matches($whatIfText, "(?m)^\s*\+\s").Count
$modifyCount = [regex]::Matches($whatIfText, "(?m)^\s*~\s").Count
$deleteCount = [regex]::Matches($whatIfText, "(?m)^\s*-\s").Count

# Display formatted summary
Write-Host "  ┌─────────────────────────────────────────┐" -ForegroundColor DarkGray
Write-Host "  │  CHANGE SUMMARY                          │" -ForegroundColor White
Write-Host "  ├─────────────────────────────────────────┤" -ForegroundColor DarkGray
Write-Host "  │  + Create     : $createCount resources  │" -ForegroundColor Green
Write-Host "  │  ~ Modify     : $modifyCount resources  │" -ForegroundColor Yellow
Write-Host "  │  - Delete     : $deleteCount resources  │" -ForegroundColor Red
Write-Host "  └─────────────────────────────────────────┘" -ForegroundColor DarkGray
```

---

### 6. Auto-Detect SQL Admin Identity

```powershell
if (-not $SqlAdminGroupObjectId) {
    Write-Step "Resolving SQL admin identity..." -StepNumber 3 -TotalSteps 3

    $signedInUser = az ad signed-in-user show 2>&1 | ConvertFrom-Json

    if ($signedInUser) {
        $SqlAdminGroupObjectId = $signedInUser.id
        $SqlAdminGroupName = $signedInUser.displayName

        Write-SubStep "Using current user as SQL admin"
        Write-Info "Name" $signedInUser.displayName
        Write-Info "Object ID" $SqlAdminGroupObjectId
    } else {
        Write-ErrorMessage "Could not determine current user"
        exit 1
    }
}
```

---

### 7. Deployment Confirmation Box

```powershell
Write-Host "  ┌─────────────────────────────────────────────────────────────────┐" -ForegroundColor Yellow
Write-Host "  │  ⚡ READY TO DEPLOY                                             │" -ForegroundColor White
Write-Host "  │                                                                 │" -ForegroundColor Yellow
Write-Host "  │  This will create Azure resources that incur costs.            │" -ForegroundColor Yellow
Write-Host "  │  Estimated monthly cost: ~`$2,212 USD                           │" -ForegroundColor Yellow
Write-Host "  └─────────────────────────────────────────────────────────────────┘" -ForegroundColor Yellow

$confirm = Read-Host "  Type 'yes' to proceed with deployment"
```

---

### 8. Deployment Success Output

```powershell
Write-Host "  ┌─────────────────────────────────────────────────────────────────┐" -ForegroundColor Green
Write-Host "  │  ✓ DEPLOYMENT SUCCESSFUL                                       │" -ForegroundColor White
Write-Host "  │                                                                 │" -ForegroundColor Green
Write-Host "  │  Duration: 00:18:32                                            │" -ForegroundColor Cyan
Write-Host "  │  Finished: 2025-12-02 16:30:45                                 │" -ForegroundColor Cyan
Write-Host "  └─────────────────────────────────────────────────────────────────┘" -ForegroundColor Green

Write-Host "  ┌─────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkCyan
Write-Host "  │  RESOURCE ENDPOINTS                                            │" -ForegroundColor White
Write-Host "  │                                                                 │" -ForegroundColor DarkCyan
Write-Host "  │  🌐 Front Door      https://ecommerce-xxx.azurefd.net          │" -ForegroundColor Cyan
Write-Host "  │  🔧 App Service     https://app-ecommerce-prod-xxx.azurewebsites.net │" -ForegroundColor Cyan
Write-Host "  │  📱 Static Web App  https://xxx.azurestaticapps.net            │" -ForegroundColor Cyan
Write-Host "  │  🔐 Key Vault       https://kv-ecomm-prod-xxx.vault.azure.net  │" -ForegroundColor Cyan
Write-Host "  │  💾 SQL Server      sql-ecommerce-prod-xxx.database.windows.net│" -ForegroundColor Cyan
Write-Host "  └─────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkCyan
```

---

## 📋 Full Script Structure

```powershell
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [ValidateSet('swedencentral', 'germanywestcentral')]
    [string]$Location = 'swedencentral',

    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment = 'prod',

    [string]$SqlAdminGroupObjectId  # Auto-detected if not provided
)

# 1. Display Banner
Write-Banner

# 2. Display Configuration
Write-DeploymentSummary

# 3. Pre-flight Checks
#    [1/3] Check Azure CLI
#    [2/3] Verify Authentication
#    [3/3] Resolve SQL Admin

# 4. Template Validation
#    - bicep build
#    - bicep lint

# 5. Resource Group Setup

# 6. What-If Analysis
#    - Show change summary

# 7. User Confirmation
#    - Display cost estimate
#    - Require "yes" to proceed

# 8. Deploy Infrastructure
#    - az deployment group create

# 9. Display Results
#    - Duration
#    - Resource endpoints
#    - Next steps
```

---

## 🎨 Before vs After

### Before (Basic Output)

```
Starting deployment...
Creating resource group...
Deploying...
Done.
```

### After (Professional Output)

```
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║   E-COMMERCE - Azure Infrastructure Deployment                        ║
    ╚═══════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────────────────────────────────────────────────┐
  │  DEPLOYMENT CONFIGURATION                                          │
  ├────────────────────────────────────────────────────────────────────┤
  │  Resource Group   : rg-ecommerce-prod-swc                          │
  │  Location         : swedencentral                                  │
  │  Environment      : PROD                                           │
  └────────────────────────────────────────────────────────────────────┘

  [1/3] Checking Azure CLI installation...
      └─ Azure CLI found
      └─ Bicep CLI ready
  [2/3] Verifying Azure authentication...
      └─ Authenticated to Azure
      • Subscription: noalz
      • User: jonathan@lordofthecloud.eu
  [3/3] Resolving SQL admin identity...
      └─ Using current user as SQL admin
      • Name: Jonathan Vella
      • Object ID: 2dcbd005-a02f-49c9-b5fb-5c03d4f6e28a
  ✓ Pre-flight checks completed

  ┌─────────────────────────────────────────┐
  │  CHANGE SUMMARY                          │
  ├─────────────────────────────────────────┤
  │  + Create     : 61 resources           │
  │  ~ Modify     : 0 resources            │
  │  - Delete     : 0 resources            │
  └─────────────────────────────────────────┘

  ✓ DEPLOYMENT SUCCESSFUL
```

---

## 📝 Documentation Updated

Added deployment script patterns to:

- `.github/copilot-instructions.md` - Professional formatting section
- `.github/agents/bicep-implement.agent.md` - Deployment script requirements
- `.github/instructions/bicep-code-best-practices.instructions.md` - Full deployment scripts section

---

## ➡️ Next Step

Execute the deployment with `./deploy.ps1 -ResourceGroupName "rg-ecommerce-prod-swc"`
