// ============================================================================
// Azure Functions Module
// ============================================================================
// Creates .NET 8 Isolated Function App with VNet integration
// ============================================================================

@description('Azure region for Functions deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the Function App')
param functionAppName string

@description('Function App Plan resource ID')
param functionAppPlanId string

@description('Subnet ID for VNet integration')
param subnetId string

@description('Key Vault URI for configuration')
param keyVaultUri string

@description('Service Bus namespace FQDN')
param serviceBusNamespace string

@description('Application Insights connection string')
param appInsightsConnectionString string

// ============================================================================
// Storage Account for Functions
// ============================================================================

var storageAccountName = 'st${take(replace(functionAppName, '-', ''), 18)}${take(uniqueString(resourceGroup().id), 4)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: take(storageAccountName, 24)
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow' // Required for Functions to access storage
    }
  }
}

// ============================================================================
// Function App
// ============================================================================

resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: functionAppPlanId
    httpsOnly: true
    virtualNetworkSubnetId: subnetId
    vnetRouteAllEnabled: true
    vnetContentShareEnabled: false
    siteConfig: {
      linuxFxVersion: 'DOTNET-ISOLATED|8.0'
      alwaysOn: true
      http20Enabled: true
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      vnetRouteAllEnabled: true
      functionsRuntimeScaleMonitoringEnabled: true
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet-isolated'
        }
        {
          name: 'KeyVaultUri'
          value: keyVaultUri
        }
        {
          name: 'ServiceBusConnection__fullyQualifiedNamespace'
          value: serviceBusNamespace
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
    publicNetworkAccess: 'Disabled'
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Function App resource ID')
output functionAppId string = functionApp.id

@description('Function App name')
output functionAppName string = functionApp.name

@description('Function App default hostname')
output defaultHostName string = functionApp.properties.defaultHostName

@description('Function App managed identity principal ID')
output principalId string = functionApp.identity.principalId

@description('Storage account name')
output storageAccountName string = storageAccount.name
