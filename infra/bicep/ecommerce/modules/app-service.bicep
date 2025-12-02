// ============================================================================
// App Service Module
// ============================================================================
// Creates .NET 8 App Service with VNet integration and managed identity
// ============================================================================

@description('Azure region for App Service deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the App Service')
param appServiceName string

@description('App Service Plan resource ID')
param appServicePlanId string

@description('Subnet ID for VNet integration')
param subnetId string

@description('Key Vault URI for configuration')
param keyVaultUri string

@description('Application Insights connection string')
param appInsightsConnectionString string

// ============================================================================
// App Service
// ============================================================================

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName
  location: location
  tags: tags
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    virtualNetworkSubnetId: subnetId
    vnetRouteAllEnabled: true
    vnetContentShareEnabled: false
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      alwaysOn: true
      http20Enabled: true
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      vnetRouteAllEnabled: true
      ipSecurityRestrictionsDefaultAction: 'Allow'
      scmIpSecurityRestrictionsDefaultAction: 'Deny'
      healthCheckPath: '/health'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Production'
        }
        {
          name: 'KeyVaultUri'
          value: keyVaultUri
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
      ]
    }
    clientAffinityEnabled: false
    publicNetworkAccess: 'Enabled' // Front Door access
  }
}

// ============================================================================
// Diagnostic Settings (App Service Logs)
// ============================================================================

resource appServiceLogs 'Microsoft.Web/sites/config@2023-12-01' = {
  parent: appService
  name: 'logs'
  properties: {
    httpLogs: {
      fileSystem: {
        enabled: true
        retentionInDays: 7
        retentionInMb: 35
      }
    }
    applicationLogs: {
      fileSystem: {
        level: 'Warning'
      }
    }
    detailedErrorMessages: {
      enabled: true
    }
    failedRequestsTracing: {
      enabled: true
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('App Service resource ID')
output appServiceId string = appService.id

@description('App Service name')
output appServiceName string = appService.name

@description('App Service default hostname')
output defaultHostName string = appService.properties.defaultHostName

@description('App Service managed identity principal ID')
output principalId string = appService.identity.principalId
