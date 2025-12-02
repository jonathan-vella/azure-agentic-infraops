// ============================================================================
// Log Analytics Workspace Module
// ============================================================================
// Creates Log Analytics workspace for centralized logging (PCI-DSS 90-day retention)
// ============================================================================

@description('Azure region for Log Analytics deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the Log Analytics workspace')
param workspaceName string

@description('Data retention in days (90 days for PCI-DSS)')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Daily ingestion cap in GB')
@minValue(-1)
@maxValue(100)
param dailyQuotaGb int = 5

// ============================================================================
// Log Analytics Workspace
// ============================================================================

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    features: {
      enableDataExport: true
      immediatePurgeDataOn30Days: false
      disableLocalAuth: false
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Log Analytics workspace resource ID')
output workspaceId string = logAnalyticsWorkspace.id

@description('Log Analytics workspace name')
output workspaceName string = logAnalyticsWorkspace.name

@description('Log Analytics workspace customer ID (for agents)')
output customerId string = logAnalyticsWorkspace.properties.customerId
