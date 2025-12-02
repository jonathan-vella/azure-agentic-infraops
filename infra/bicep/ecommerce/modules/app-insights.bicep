// ============================================================================
// Application Insights Module
// ============================================================================
// Creates Application Insights for APM and distributed tracing
// ============================================================================

@description('Azure region for Application Insights deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the Application Insights resource')
param appInsightsName string

@description('Log Analytics workspace resource ID')
param logAnalyticsWorkspaceId string

@description('Data retention in days')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

// ============================================================================
// Application Insights
// ============================================================================

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
    RetentionInDays: retentionInDays
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    DisableIpMasking: false // Keep IP masking for GDPR
    DisableLocalAuth: false
    ForceCustomerStorageForProfiler: false
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Application Insights resource ID')
output appInsightsId string = appInsights.id

@description('Application Insights name')
output appInsightsName string = appInsights.name

@description('Application Insights connection string')
output connectionString string = appInsights.properties.ConnectionString

@description('Application Insights instrumentation key (legacy)')
output instrumentationKey string = appInsights.properties.InstrumentationKey
