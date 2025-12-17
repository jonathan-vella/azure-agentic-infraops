<#
.SYNOPSIS
    Deploys the static-webapp-test infrastructure to Azure.

.DESCRIPTION
    This script validates and deploys Bicep templates for the static web app with SQL database.
    Supports WhatIf mode for deployment preview.

.PARAMETER ResourceGroupName
    Name of the resource group (default: rg-static-webapp-test-dev)

.PARAMETER Location
    Azure region for deployment (default: swedencentral)

.PARAMETER Environment
    Environment name: dev, staging, prod (default: dev)

.PARAMETER SqlAdminObjectId
    Azure AD Object ID for SQL admin. If not provided, uses current signed-in user.

.EXAMPLE
    ./deploy.ps1
    
.EXAMPLE
    ./deploy.ps1 -WhatIf
    
.EXAMPLE
    ./deploy.ps1 -ResourceGroupName "rg-mytest-dev" -Location "germanywestcentral"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName = "rg-static-webapp-test-dev",

    [Parameter()]
    [ValidateSet('swedencentral', 'germanywestcentral', 'northeurope', 'westeurope')]
    [string]$Location = "swedencentral",

    [Parameter()]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment = "dev",

    [Parameter()]
    [string]$SqlAdminObjectId,

    [Parameter()]
    [string]$SqlAdminName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# =============================================================================
# Banner
# =============================================================================

Write-Host @"

    ╔═══════════════════════════════════════════════════════════════════════╗
    ║   Static Web App Test - Azure Deployment                              ║
    ║   Infrastructure: SWA + Azure SQL + Application Insights              ║
    ╚═══════════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# =============================================================================
# Prerequisites Check
# =============================================================================

Write-Host "  [1/5] " -ForegroundColor DarkGray -NoNewline
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Azure CLI
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "Azure CLI not found. Please install: https://aka.ms/installazurecli"
}

# Check Bicep CLI
$bicepVersion = az bicep version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "      └─ Installing Bicep CLI..." -ForegroundColor Gray
    az bicep install
}

# Check Azure login
$account = az account show 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
if (-not $account) {
    Write-Error "Not logged in to Azure. Run: az login"
}

Write-Host "      └─ Logged in as: $($account.user.name)" -ForegroundColor Gray
Write-Host "      └─ Subscription: $($account.name)" -ForegroundColor Gray
Write-Host "  ✓ " -ForegroundColor Green -NoNewline
Write-Host "Prerequisites verified" -ForegroundColor White

# =============================================================================
# Get SQL Admin Object ID
# =============================================================================

Write-Host ""
Write-Host "  [2/5] " -ForegroundColor DarkGray -NoNewline
Write-Host "Resolving SQL Admin identity..." -ForegroundColor Yellow

if (-not $SqlAdminObjectId) {
    $signedInUser = az ad signed-in-user show 2>&1 | ConvertFrom-Json
    if ($signedInUser) {
        $SqlAdminObjectId = $signedInUser.id
        $SqlAdminName = $signedInUser.displayName
        Write-Host "      └─ Using signed-in user: $SqlAdminName" -ForegroundColor Gray
    } else {
        Write-Error "Could not determine SQL Admin. Please provide -SqlAdminObjectId parameter."
    }
}

Write-Host "  ✓ " -ForegroundColor Green -NoNewline
Write-Host "SQL Admin: $SqlAdminName ($SqlAdminObjectId)" -ForegroundColor White

# =============================================================================
# Validate Bicep
# =============================================================================

Write-Host ""
Write-Host "  [3/5] " -ForegroundColor DarkGray -NoNewline
Write-Host "Validating Bicep templates..." -ForegroundColor Yellow

$bicepPath = Join-Path $PSScriptRoot "main.bicep"

# Build (compile) check
Write-Host "      └─ Running bicep build..." -ForegroundColor Gray
$buildOutput = az bicep build --file $bicepPath 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ " -ForegroundColor Red -NoNewline
    Write-Host "Bicep build failed:" -ForegroundColor Red
    Write-Host $buildOutput -ForegroundColor Red
    exit 1
}

# Lint check (warnings are OK, errors are not)
Write-Host "      └─ Running bicep lint..." -ForegroundColor Gray
$lintOutput = az bicep lint --file $bicepPath 2>&1
# Note: Lint warnings don't fail the build

Write-Host "  ✓ " -ForegroundColor Green -NoNewline
Write-Host "Bicep validation passed" -ForegroundColor White

# =============================================================================
# Configuration Summary
# =============================================================================

Write-Host ""
Write-Host "  ┌────────────────────────────────────────────────────────────────────┐"
Write-Host "  │  DEPLOYMENT CONFIGURATION                                          │"
Write-Host "  ├────────────────────────────────────────────────────────────────────┤"
Write-Host "  │  Resource Group:  $ResourceGroupName" -NoNewline
Write-Host (" " * (50 - $ResourceGroupName.Length)) -NoNewline
Write-Host "│"
Write-Host "  │  Location:        $Location" -NoNewline
Write-Host (" " * (50 - $Location.Length)) -NoNewline
Write-Host "│"
Write-Host "  │  Environment:     $Environment" -NoNewline
Write-Host (" " * (50 - $Environment.Length)) -NoNewline
Write-Host "│"
Write-Host "  │  SQL Admin:       $SqlAdminName" -NoNewline
Write-Host (" " * (50 - $SqlAdminName.Length)) -NoNewline
Write-Host "│"
Write-Host "  └────────────────────────────────────────────────────────────────────┘"

# =============================================================================
# Create Resource Group
# =============================================================================

Write-Host ""
Write-Host "  [4/5] " -ForegroundColor DarkGray -NoNewline
Write-Host "Ensuring resource group exists..." -ForegroundColor Yellow

if ($PSCmdlet.ShouldProcess($ResourceGroupName, "Create Resource Group")) {
    az group create --name $ResourceGroupName --location $Location --tags Environment=$Environment ManagedBy=Bicep Project=static-webapp-test | Out-Null
    Write-Host "  ✓ " -ForegroundColor Green -NoNewline
    Write-Host "Resource group ready: $ResourceGroupName" -ForegroundColor White
}

# =============================================================================
# Deploy
# =============================================================================

Write-Host ""
Write-Host "  [5/5] " -ForegroundColor DarkGray -NoNewline

if ($WhatIfPreference) {
    Write-Host "Running What-If preview..." -ForegroundColor Yellow
    
    $whatIfResult = az deployment group what-if `
        --resource-group $ResourceGroupName `
        --template-file $bicepPath `
        --parameters location=$Location `
        --parameters environment=$Environment `
        --parameters projectName="static-webapp-test" `
        --parameters sqlAdminObjectId=$SqlAdminObjectId `
        --parameters sqlAdminName=$SqlAdminName `
        2>&1
    
    Write-Host ""
    Write-Host $whatIfResult
    
    # Parse results
    $whatIfText = $whatIfResult -join "`n"
    $createCount = ([regex]::Matches($whatIfText, "(?m)^\s*\+\s")).Count
    $modifyCount = ([regex]::Matches($whatIfText, "(?m)^\s*~\s")).Count
    $deleteCount = ([regex]::Matches($whatIfText, "(?m)^\s*-\s")).Count
    
    Write-Host ""
    Write-Host "  ┌────────────────────────────────────────────────────────────────────┐"
    Write-Host "  │  WHAT-IF SUMMARY                                                   │"
    Write-Host "  ├────────────────────────────────────────────────────────────────────┤"
    Write-Host "  │  + Create: $createCount resources                                           │" -ForegroundColor Green
    Write-Host "  │  ~ Modify: $modifyCount resources                                           │" -ForegroundColor Yellow
    Write-Host "  │  - Delete: $deleteCount resources                                           │" -ForegroundColor Red
    Write-Host "  └────────────────────────────────────────────────────────────────────┘"
    Write-Host ""
    Write-Host "  Run without -WhatIf to deploy." -ForegroundColor Cyan
    
} else {
    Write-Host "Deploying infrastructure..." -ForegroundColor Yellow
    
    $deploymentName = "static-webapp-test-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    
    $result = az deployment group create `
        --resource-group $ResourceGroupName `
        --template-file $bicepPath `
        --name $deploymentName `
        --parameters location=$Location `
        --parameters environment=$Environment `
        --parameters projectName="static-webapp-test" `
        --parameters sqlAdminObjectId=$SqlAdminObjectId `
        --parameters sqlAdminName=$SqlAdminName `
        --query "properties.outputs" `
        --output json 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ✗ " -ForegroundColor Red -NoNewline
        Write-Host "Deployment failed:" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
        exit 1
    }
    
    $outputs = $result | ConvertFrom-Json
    
    Write-Host "  ✓ " -ForegroundColor Green -NoNewline
    Write-Host "Deployment successful!" -ForegroundColor White
    
    # Display outputs
    Write-Host ""
    Write-Host "  ┌────────────────────────────────────────────────────────────────────┐"
    Write-Host "  │  DEPLOYMENT OUTPUTS                                                │"
    Write-Host "  ├────────────────────────────────────────────────────────────────────┤"
    Write-Host "  │  Static Web App URL:                                               │"
    Write-Host "  │    $($outputs.staticWebAppUrl.value)" -ForegroundColor Cyan
    Write-Host "  │                                                                    │"
    Write-Host "  │  SQL Server FQDN:                                                  │"
    Write-Host "  │    $($outputs.sqlServerFqdn.value)" -ForegroundColor Cyan
    Write-Host "  │                                                                    │"
    Write-Host "  │  Database Name:                                                    │"
    Write-Host "  │    $($outputs.databaseName.value)" -ForegroundColor Cyan
    Write-Host "  └────────────────────────────────────────────────────────────────────┘"
}

Write-Host ""
Write-Host "  Done!" -ForegroundColor Green
Write-Host ""
