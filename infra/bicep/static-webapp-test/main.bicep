// =============================================================================
// Static Web App Test - Main Bicep Template
// =============================================================================
// Project: static-webapp-test
// Purpose: Deploy Azure Static Web App with SQL Database backend
// Generated: 2024-12-17 by bicep-implement agent
// =============================================================================

targetScope = 'resourceGroup'

// -----------------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------------

@description('Azure region for all resources')
@allowed([
  'swedencentral'
  'germanywestcentral'
  'northeurope'
  'westeurope'
])
param location string = 'swedencentral'

@description('Environment name')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'dev'

@description('Project name used for resource naming')
@minLength(3)
@maxLength(20)
param projectName string = 'static-webapp-test'

@description('Azure AD Object ID for SQL Server administrator')
param sqlAdminObjectId string

@description('Display name for SQL Server administrator')
param sqlAdminName string = 'SQL Admin'

@description('Resource tags')
param tags object = {
  Environment: environment
  ManagedBy: 'Bicep'
  Project: projectName
  Owner: 'DevOps Team'
}

// -----------------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------------

@description('Unique suffix for globally unique resource names')
var uniqueSuffix = uniqueString(resourceGroup().id)

// -----------------------------------------------------------------------------
// Modules
// -----------------------------------------------------------------------------

// Deploy monitoring resources first (required for diagnostic settings)
module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring-deployment'
  params: {
    location: location
    environment: environment
    projectName: projectName
    tags: tags
  }
}

// Deploy SQL Server
module sqlServer 'modules/sql-server.bicep' = {
  name: 'sql-server-deployment'
  params: {
    location: location
    environment: environment
    projectName: projectName
    uniqueSuffix: uniqueSuffix
    sqlAdminObjectId: sqlAdminObjectId
    sqlAdminName: sqlAdminName
    tags: tags
  }
}

// Deploy SQL Database
module sqlDatabase 'modules/sql-database.bicep' = {
  name: 'sql-database-deployment'
  params: {
    location: location
    environment: environment
    projectName: projectName
    sqlServerName: sqlServer.outputs.sqlServerName
    tags: tags
  }
}

// Deploy Static Web App
module staticWebApp 'modules/static-web-app.bicep' = {
  name: 'static-web-app-deployment'
  params: {
    location: location
    environment: environment
    projectName: projectName
    tags: tags
  }
}

// -----------------------------------------------------------------------------
// Outputs
// -----------------------------------------------------------------------------

@description('Static Web App URL')
output staticWebAppUrl string = staticWebApp.outputs.staticWebAppUrl

@description('Static Web App name')
output staticWebAppName string = staticWebApp.outputs.staticWebAppName

@description('SQL Server fully qualified domain name')
output sqlServerFqdn string = sqlServer.outputs.sqlServerFqdn

@description('SQL Database name')
output databaseName string = sqlDatabase.outputs.databaseName

@description('Application Insights connection string')
output appInsightsConnectionString string = monitoring.outputs.appInsightsConnectionString

@description('Log Analytics Workspace ID')
output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
