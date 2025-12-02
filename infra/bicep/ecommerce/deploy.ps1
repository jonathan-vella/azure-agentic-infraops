<#
.SYNOPSIS
    Deploys the E-Commerce Platform infrastructure to Azure.

.DESCRIPTION
    This script deploys the PCI-DSS compliant e-commerce platform infrastructure
    using Azure Bicep templates. It supports what-if analysis, validation, and
    incremental deployment.

.PARAMETER ResourceGroupName
    The name of the resource group to deploy to.

.PARAMETER Location
    The Azure region for deployment. Defaults to 'swedencentral'.

.PARAMETER Environment
    The environment name (dev, staging, prod). Defaults to 'prod'.

.PARAMETER SqlAdminGroupObjectId
    The Azure AD group object ID for SQL Server administration.
    If not provided, the script will use the current signed-in user's object ID.

.PARAMETER SqlAdminGroupName
    The Azure AD group name for SQL Server administration.
    If not provided and using current user, defaults to the user's display name.

.PARAMETER UseCurrentUser
    Use the current signed-in user as the SQL admin instead of a group.
    This is the default behavior when SqlAdminGroupObjectId is not provided.

.PARAMETER SkipValidation
    Skip Bicep validation before deployment.

.EXAMPLE
    ./deploy.ps1 -ResourceGroupName "rg-ecommerce-prod-swc"
    # Uses current signed-in user as SQL admin

.EXAMPLE
    ./deploy.ps1 -ResourceGroupName "rg-ecommerce-prod-swc" -SqlAdminGroupObjectId "12345678-1234-1234-1234-123456789012"

.EXAMPLE
    ./deploy.ps1 -ResourceGroupName "rg-ecommerce-dev-swc" -Environment "dev" -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $false)]
    [ValidateSet('swedencentral', 'germanywestcentral', 'westeurope', 'northeurope')]
    [string]$Location = 'swedencentral',

    [Parameter(Mandatory = $false)]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment = 'prod',

    [Parameter(Mandatory = $false)]
    [string]$SqlAdminGroupObjectId,

    [Parameter(Mandatory = $false)]
    [string]$SqlAdminGroupName,

    [Parameter(Mandatory = $false)]
    [switch]$UseCurrentUser,

    [Parameter(Mandatory = $false)]
    [switch]$SkipValidation
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ============================================================================
# Configuration
# ============================================================================

$ScriptRoot = $PSScriptRoot
$TemplateFile = Join-Path $ScriptRoot 'main.bicep'
$DeploymentName = "ecommerce-$Environment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# ============================================================================
# Functions
# ============================================================================

function Write-Header {
    param([string]$Message)
    Write-Host "`n$('=' * 70)" -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Cyan
    Write-Host "$('=' * 70)`n" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Message)
    Write-Host "➡️  $Message" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# ============================================================================
# Pre-flight Checks
# ============================================================================

Write-Header "E-Commerce Platform Deployment"

Write-Step "Checking prerequisites..."

# Check Azure CLI
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "Azure CLI is not installed. Please install it first."
    exit 1
}

# Check Bicep CLI
$bicepVersion = az bicep version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Step "Installing Bicep CLI..."
    az bicep install
}

# Check Azure login
$account = az account show 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
if (-not $account) {
    Write-Error "Not logged in to Azure. Please run 'az login' first."
    exit 1
}

Write-Success "Prerequisites check passed"
Write-Host "  Subscription: $($account.name)" -ForegroundColor Gray
Write-Host "  User: $($account.user.name)" -ForegroundColor Gray

# ============================================================================
# Resolve SQL Admin Identity
# ============================================================================

if (-not $SqlAdminGroupObjectId) {
    Write-Step "Resolving SQL admin identity..."
    
    # Get current signed-in user's object ID
    $signedInUser = az ad signed-in-user show 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
    
    if ($signedInUser) {
        $SqlAdminGroupObjectId = $signedInUser.id
        if (-not $SqlAdminGroupName) {
            $SqlAdminGroupName = $signedInUser.displayName
        }
        Write-Success "Using current user as SQL admin"
        Write-Host "  Name: $($signedInUser.displayName)" -ForegroundColor Gray
        Write-Host "  Object ID: $SqlAdminGroupObjectId" -ForegroundColor Gray
    } else {
        Write-Error "Could not determine current user. Please provide -SqlAdminGroupObjectId parameter."
        exit 1
    }
} else {
    Write-Step "Using provided SQL admin identity"
    Write-Host "  Object ID: $SqlAdminGroupObjectId" -ForegroundColor Gray
    if (-not $SqlAdminGroupName) {
        # Try to resolve the name from the object ID
        $adObject = az ad group show --group $SqlAdminGroupObjectId 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($adObject) {
            $SqlAdminGroupName = $adObject.displayName
            Write-Host "  Group Name: $SqlAdminGroupName" -ForegroundColor Gray
        } else {
            # Try as user
            $adObject = az ad user show --id $SqlAdminGroupObjectId 2>&1 | ConvertFrom-Json -ErrorAction SilentlyContinue
            if ($adObject) {
                $SqlAdminGroupName = $adObject.displayName
                Write-Host "  User Name: $SqlAdminGroupName" -ForegroundColor Gray
            } else {
                $SqlAdminGroupName = "sql-admin"
                Write-Host "  Name: $SqlAdminGroupName (default)" -ForegroundColor Gray
            }
        }
    }
}

# ============================================================================
# Validate Bicep Templates
# ============================================================================

if (-not $SkipValidation) {
    Write-Header "Validating Bicep Templates"

    Write-Step "Running bicep build..."
    $buildResult = az bicep build --file $TemplateFile 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Bicep build failed:"
        Write-Host $buildResult -ForegroundColor Red
        exit 1
    }
    Write-Success "Bicep build passed"

    Write-Step "Running bicep lint..."
    $lintResult = az bicep lint --file $TemplateFile 2>&1
    # Lint warnings are acceptable, only fail on errors
    if ($lintResult -match "Error") {
        Write-Error "Bicep lint found errors:"
        Write-Host $lintResult -ForegroundColor Red
        exit 1
    }
    if ($lintResult -match "Warning") {
        Write-Host "⚠️  Bicep lint warnings (non-blocking):" -ForegroundColor Yellow
        Write-Host $lintResult -ForegroundColor Yellow
    } else {
        Write-Success "Bicep lint passed"
    }

    # Clean up generated ARM template
    $armFile = $TemplateFile -replace '\.bicep$', '.json'
    if (Test-Path $armFile) {
        Remove-Item $armFile -Force
    }
}

# ============================================================================
# Create Resource Group
# ============================================================================

Write-Header "Resource Group"

$rgExists = az group exists --name $ResourceGroupName 2>&1
if ($rgExists -eq 'false') {
    # Always create the RG (required for what-if analysis)
    Write-Step "Creating resource group '$ResourceGroupName' in '$Location'..."
    az group create --name $ResourceGroupName --location $Location --tags Environment=$Environment ManagedBy=Bicep Project=ecommerce-platform | Out-Null
    Write-Success "Resource group created"
} else {
    Write-Success "Resource group '$ResourceGroupName' already exists"
}

# ============================================================================
# What-If Analysis
# ============================================================================

Write-Header "Deployment Analysis"

$deploymentParams = @(
    '--resource-group', $ResourceGroupName
    '--template-file', $TemplateFile
    '--parameters', "location=$Location"
    '--parameters', "environment=$Environment"
    '--parameters', "sqlAdminGroupObjectId=$SqlAdminGroupObjectId"
    '--parameters', "sqlAdminGroupName=$SqlAdminGroupName"
)

Write-Step "Running what-if analysis..."
$whatIfResult = az deployment group what-if @deploymentParams 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "What-if analysis failed:"
    Write-Host $whatIfResult -ForegroundColor Red
    exit 1
}

Write-Host "`nPlanned changes:" -ForegroundColor Cyan
Write-Host $whatIfResult

# Check if running in WhatIf mode
if ($WhatIfPreference) {
    Write-Header "What-If Mode Complete"
    Write-Host "No changes were made. Remove -WhatIf to deploy." -ForegroundColor Yellow
    exit 0
}

# ============================================================================
# Confirm Deployment
# ============================================================================

Write-Host "`n"
$confirm = Read-Host "Do you want to proceed with the deployment? (yes/no)"
if ($confirm -ne 'yes') {
    Write-Host "Deployment cancelled." -ForegroundColor Yellow
    exit 0
}

# ============================================================================
# Deploy
# ============================================================================

Write-Header "Deploying Infrastructure"

Write-Step "Starting deployment '$DeploymentName'..."
$startTime = Get-Date

$deployResult = az deployment group create `
    --name $DeploymentName `
    @deploymentParams `
    --verbose 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Error "Deployment failed:"
    Write-Host $deployResult -ForegroundColor Red
    
    Write-Step "Fetching deployment error details..."
    az deployment group show --name $DeploymentName --resource-group $ResourceGroupName --query 'properties.error' 2>&1
    exit 1
}

$endTime = Get-Date
$duration = $endTime - $startTime

Write-Success "Deployment completed successfully!"
Write-Host "  Duration: $($duration.ToString('hh\:mm\:ss'))" -ForegroundColor Gray

# ============================================================================
# Output Results
# ============================================================================

Write-Header "Deployment Outputs"

$outputs = az deployment group show `
    --name $DeploymentName `
    --resource-group $ResourceGroupName `
    --query 'properties.outputs' 2>&1 | ConvertFrom-Json

if ($outputs) {
    Write-Host "Key Resources:" -ForegroundColor Cyan
    Write-Host "  Front Door Endpoint:  https://$($outputs.frontDoorHostName.value)" -ForegroundColor Green
    Write-Host "  App Service:          https://$($outputs.appServiceHostName.value)" -ForegroundColor Green
    Write-Host "  Static Web App:       https://$($outputs.staticWebAppHostName.value)" -ForegroundColor Green
    Write-Host "  Key Vault URI:        $($outputs.keyVaultUri.value)" -ForegroundColor Green
    Write-Host "  SQL Server FQDN:      $($outputs.sqlServerFqdn.value)" -ForegroundColor Green
}

Write-Header "Next Steps"
Write-Host @"
1. Configure Azure AD authentication for SQL Server
2. Deploy application code to App Service
3. Deploy React SPA to Static Web App
4. Configure custom domain for Front Door
5. Review WAF logs in Log Analytics

Useful commands:
  # View deployment details
  az deployment group show --name $DeploymentName --resource-group $ResourceGroupName

  # List all resources
  az resource list --resource-group $ResourceGroupName --output table

  # Check Front Door health
  az afd endpoint show --profile-name afd-ecommerce-$Environment-001 --endpoint-name ecommerce-endpoint --resource-group $ResourceGroupName
"@ -ForegroundColor Gray

Write-Host "`n✅ Deployment complete!`n" -ForegroundColor Green
