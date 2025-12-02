// ============================================================================
// Diagnostic Settings Module
// ============================================================================
// Configures diagnostic settings for all resources to send logs to Log Analytics
// ============================================================================

@description('Log Analytics workspace resource ID')
param logAnalyticsWorkspaceId string

@description('App Service name')
param appServiceName string

@description('Function App name')
param functionAppName string

@description('Key Vault name')
param keyVaultName string

@description('SQL Server name')
param sqlServerName string

@description('Redis Cache name')
param redisCacheName string

@description('Service Bus namespace name')
param serviceBusName string

@description('Search service name')
param searchServiceName string

@description('Front Door profile name')
param frontDoorName string

// ============================================================================
// Reference Existing Resources
// ============================================================================

resource appService 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appServiceName
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' existing = {
  name: functionAppName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: sqlServerName
}

resource redisCache 'Microsoft.Cache/redis@2024-03-01' existing = {
  name: redisCacheName
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: serviceBusName
}

resource searchService 'Microsoft.Search/searchServices@2024-03-01-preview' existing = {
  name: searchServiceName
}

resource frontDoor 'Microsoft.Cdn/profiles@2024-02-01' existing = {
  name: frontDoorName
}

// ============================================================================
// App Service Diagnostic Settings
// ============================================================================

resource appServiceDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-appservice'
  scope: appService
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
      {
        category: 'AppServicePlatformLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// ============================================================================
// Function App Diagnostic Settings
// ============================================================================

resource functionAppDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-functionapp'
  scope: functionApp
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'FunctionAppLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// ============================================================================
// Key Vault Diagnostic Settings
// ============================================================================

resource keyVaultDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-keyvault'
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
      {
        category: 'AzurePolicyEvaluationDetails'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// ============================================================================
// SQL Server Diagnostic Settings
// ============================================================================

resource sqlServerDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-sqlserver'
  scope: sqlServer
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
      }
      {
        category: 'DevOpsOperationsAudit'
        enabled: true
      }
    ]
  }
}

// ============================================================================
// Redis Cache Diagnostic Settings
// ============================================================================

resource redisDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-redis'
  scope: redisCache
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'ConnectedClientList'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// ============================================================================
// Service Bus Diagnostic Settings
// ============================================================================

resource serviceBusDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-servicebus'
  scope: serviceBus
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'OperationalLogs'
        enabled: true
      }
      {
        category: 'VNetAndIPFilteringLogs'
        enabled: true
      }
      {
        category: 'RuntimeAuditLogs'
        enabled: true
      }
      {
        category: 'ApplicationMetricsLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// ============================================================================
// Search Service Diagnostic Settings
// ============================================================================

resource searchDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-search'
  scope: searchService
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'OperationLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// ============================================================================
// Front Door Diagnostic Settings
// ============================================================================

resource frontDoorDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-frontdoor'
  scope: frontDoor
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'FrontDoorAccessLog'
        enabled: true
      }
      {
        category: 'FrontDoorHealthProbeLog'
        enabled: true
      }
      {
        category: 'FrontDoorWebApplicationFirewallLog'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
