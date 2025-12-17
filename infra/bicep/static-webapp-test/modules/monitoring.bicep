// =============================================================================
// Monitoring Module - Log Analytics & Application Insights
// =============================================================================

@description('Azure region for resources')
param location string

@description('Environment name')
param environment string

@description('Project name')
param projectName string

@description('Resource tags')
param tags object

// -----------------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------------

var logAnalyticsName = 'log-${projectName}-${environment}'
var appInsightsName = 'appi-${projectName}-${environment}'

// -----------------------------------------------------------------------------
// Resources
// -----------------------------------------------------------------------------

// Log Analytics Workspace (Free tier)
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: 1 // Free tier limit
    }
  }
}

// Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// -----------------------------------------------------------------------------
// Outputs
// -----------------------------------------------------------------------------

@description('Log Analytics Workspace ID')
output logAnalyticsWorkspaceId string = logAnalytics.id

@description('Log Analytics Workspace name')
output logAnalyticsWorkspaceName string = logAnalytics.name

@description('Application Insights ID')
output appInsightsId string = appInsights.id

@description('Application Insights name')
output appInsightsName string = appInsights.name

@description('Application Insights connection string')
output appInsightsConnectionString string = appInsights.properties.ConnectionString

@description('Application Insights instrumentation key')
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
