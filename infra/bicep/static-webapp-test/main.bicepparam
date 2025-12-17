using 'main.bicep'

// =============================================================================
// Static Web App Test - Parameter File
// =============================================================================
// Environment: dev
// Region: swedencentral
// =============================================================================

param location = 'swedencentral'
param environment = 'dev'
param projectName = 'static-webapp-test'

// SQL Admin - Replace with your Azure AD Object ID
// Get your Object ID: az ad signed-in-user show --query id -o tsv
param sqlAdminObjectId = '' // REQUIRED: Set before deployment
param sqlAdminName = 'SQL Admin'

param tags = {
  Environment: 'dev'
  ManagedBy: 'Bicep'
  Project: 'static-webapp-test'
  Owner: 'DevOps Team'
  CostCenter: 'Demo'
}
