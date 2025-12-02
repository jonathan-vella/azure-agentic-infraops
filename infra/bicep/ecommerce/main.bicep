// ============================================================================
// E-Commerce Platform - Main Bicep Template
// ============================================================================
// PCI-DSS compliant multi-tier e-commerce platform
// Region: swedencentral
// ============================================================================

targetScope = 'resourceGroup'

// ============================================================================
// Parameters
// ============================================================================

@description('Azure region for all resources')
@allowed([
  'swedencentral'
  'germanywestcentral'
  'westeurope'
  'northeurope'
])
param location string = 'swedencentral'

@description('Environment name')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'prod'

@description('Project name used for resource naming')
param projectName string = 'ecommerce'

@description('Owner team or individual')
param owner string = 'platform-team'

@description('Cost center for billing')
param costCenter string = 'CC-ECOM-001'

@description('Azure AD admin group object ID for SQL Server')
param sqlAdminGroupObjectId string

@description('Azure AD admin group name for SQL Server')
param sqlAdminGroupName string = 'sql-admins'

// ============================================================================
// Variables
// ============================================================================

// Unique suffix for globally unique resource names
var uniqueSuffix = uniqueString(resourceGroup().id)

// Region abbreviations for CAF naming
var regionAbbreviations = {
  swedencentral: 'swc'
  germanywestcentral: 'gwc'
  westeurope: 'weu'
  northeurope: 'neu'
}
var locationShort = regionAbbreviations[location]

// Resource naming (CAF compliant)
var resourceNames = {
  // Phase 1 - Network
  vnet: 'vnet-${projectName}-${environment}-${locationShort}-001'
  nsgWeb: 'nsg-web-${environment}-${locationShort}-001'
  nsgData: 'nsg-data-${environment}-${locationShort}-001'
  nsgIntegration: 'nsg-integration-${environment}-${locationShort}-001'

  // Phase 2 - Platform Services
  keyVault: 'kv-${take(projectName, 4)}-${environment}-${take(uniqueSuffix, 6)}'
  appServicePlan: 'asp-${projectName}-${environment}-${locationShort}-001'
  sqlServer: 'sql-${projectName}-${environment}-${locationShort}-${take(uniqueSuffix, 6)}'
  sqlDatabase: 'sqldb-${projectName}-${environment}'
  redis: 'redis-${projectName}-${environment}-${take(uniqueSuffix, 6)}'

  // Phase 3 - Application
  appService: 'app-${projectName}-api-${environment}-${locationShort}-001'
  search: 'srch-${projectName}-${environment}-${take(uniqueSuffix, 6)}'
  serviceBus: 'sb-${projectName}-${environment}-${take(uniqueSuffix, 6)}'
  functionAppPlan: 'asp-func-${projectName}-${environment}-${locationShort}-001'
  functionApp: 'func-${projectName}-orders-${environment}-${locationShort}-001'

  // Phase 4 - Edge & Monitoring
  logAnalytics: 'log-${projectName}-${environment}-${locationShort}-001'
  appInsights: 'appi-${projectName}-${environment}-${locationShort}-001'
  frontDoor: 'afd-${projectName}-${environment}-001'
  wafPolicy: 'waf-${projectName}-${environment}-001'
  staticWebApp: 'swa-${projectName}-${environment}-${locationShort}-001'
}

// Required tags for all resources
var tags = {
  Environment: environment
  ManagedBy: 'Bicep'
  Project: '${projectName}-platform'
  Owner: owner
  CostCenter: costCenter
  Compliance: 'PCI-DSS'
  Region: location
}

// Network configuration
var networkConfig = {
  addressPrefix: '10.0.0.0/16'
  subnets: {
    web: {
      name: 'snet-web-${environment}'
      addressPrefix: '10.0.1.0/24'
    }
    data: {
      name: 'snet-data-${environment}'
      addressPrefix: '10.0.2.0/24'
    }
    integration: {
      name: 'snet-integration-${environment}'
      addressPrefix: '10.0.3.0/24'
    }
  }
}

// ============================================================================
// Phase 1 - Network Foundation
// ============================================================================

// Network Security Groups
module nsgModule 'modules/nsg.bicep' = {
  name: 'nsg-deployment'
  params: {
    location: location
    tags: tags
    nsgWebName: resourceNames.nsgWeb
    nsgDataName: resourceNames.nsgData
    nsgIntegrationName: resourceNames.nsgIntegration
    webSubnetPrefix: networkConfig.subnets.web.addressPrefix
    dataSubnetPrefix: networkConfig.subnets.data.addressPrefix
    integrationSubnetPrefix: networkConfig.subnets.integration.addressPrefix
  }
}

// Virtual Network with Subnets
module networkModule 'modules/network.bicep' = {
  name: 'network-deployment'
  params: {
    location: location
    tags: tags
    vnetName: resourceNames.vnet
    addressPrefix: networkConfig.addressPrefix
    subnets: [
      {
        name: networkConfig.subnets.web.name
        addressPrefix: networkConfig.subnets.web.addressPrefix
        nsgId: nsgModule.outputs.nsgWebId
        serviceEndpoints: [
          { service: 'Microsoft.Web' }
        ]
        delegations: [
          {
            name: 'Microsoft.Web.serverFarms'
            properties: {
              serviceName: 'Microsoft.Web/serverFarms'
            }
          }
        ]
      }
      {
        name: networkConfig.subnets.data.name
        addressPrefix: networkConfig.subnets.data.addressPrefix
        nsgId: nsgModule.outputs.nsgDataId
        serviceEndpoints: [
          { service: 'Microsoft.Sql' }
          { service: 'Microsoft.Storage' }
          { service: 'Microsoft.KeyVault' }
        ]
        delegations: []
      }
      {
        name: networkConfig.subnets.integration.name
        addressPrefix: networkConfig.subnets.integration.addressPrefix
        nsgId: nsgModule.outputs.nsgIntegrationId
        serviceEndpoints: [
          { service: 'Microsoft.ServiceBus' }
        ]
        delegations: [
          {
            name: 'Microsoft.Web.serverFarms'
            properties: {
              serviceName: 'Microsoft.Web/serverFarms'
            }
          }
        ]
      }
    ]
  }
}

// ============================================================================
// Phase 2 - Platform Services
// ============================================================================

// Private DNS Zones
module privateDnsModule 'modules/private-dns.bicep' = {
  name: 'private-dns-deployment'
  params: {
    tags: tags
    vnetId: networkModule.outputs.vnetId
    vnetName: resourceNames.vnet
  }
}

// Key Vault
module keyVaultModule 'modules/key-vault.bicep' = {
  name: 'key-vault-deployment'
  params: {
    location: location
    tags: tags
    keyVaultName: resourceNames.keyVault
    subnetId: networkModule.outputs.dataSubnetId
    privateDnsZoneId: privateDnsModule.outputs.keyVaultDnsZoneId
  }
}

// App Service Plan (P1v3 Zone Redundant)
module appServicePlanModule 'modules/app-service-plan.bicep' = {
  name: 'app-service-plan-deployment'
  params: {
    location: location
    tags: tags
    appServicePlanName: resourceNames.appServicePlan
  }
}

// Azure SQL Server + Database
module sqlModule 'modules/sql.bicep' = {
  name: 'sql-deployment'
  params: {
    location: location
    tags: tags
    sqlServerName: resourceNames.sqlServer
    sqlDatabaseName: resourceNames.sqlDatabase
    adminGroupObjectId: sqlAdminGroupObjectId
    adminGroupName: sqlAdminGroupName
    subnetId: networkModule.outputs.dataSubnetId
    privateDnsZoneId: privateDnsModule.outputs.sqlDnsZoneId
  }
}

// Redis Cache
module redisModule 'modules/redis.bicep' = {
  name: 'redis-deployment'
  params: {
    location: location
    tags: tags
    redisName: resourceNames.redis
    subnetId: networkModule.outputs.dataSubnetId
    privateDnsZoneId: privateDnsModule.outputs.redisDnsZoneId
  }
}

// ============================================================================
// Phase 3 - Application Tier
// ============================================================================

// Cognitive Search
module searchModule 'modules/cognitive-search.bicep' = {
  name: 'search-deployment'
  params: {
    location: location
    tags: tags
    searchServiceName: resourceNames.search
    subnetId: networkModule.outputs.dataSubnetId
    privateDnsZoneId: privateDnsModule.outputs.searchDnsZoneId
  }
}

// Service Bus
module serviceBusModule 'modules/service-bus.bicep' = {
  name: 'service-bus-deployment'
  params: {
    location: location
    tags: tags
    serviceBusName: resourceNames.serviceBus
    subnetId: networkModule.outputs.integrationSubnetId
    privateDnsZoneId: privateDnsModule.outputs.serviceBusDnsZoneId
  }
}

// App Service
module appServiceModule 'modules/app-service.bicep' = {
  name: 'app-service-deployment'
  params: {
    location: location
    tags: tags
    appServiceName: resourceNames.appService
    appServicePlanId: appServicePlanModule.outputs.appServicePlanId
    subnetId: networkModule.outputs.webSubnetId
    keyVaultUri: keyVaultModule.outputs.keyVaultUri
    appInsightsConnectionString: appInsightsModule.outputs.connectionString
  }
}

// Functions App Service Plan (EP1)
module functionAppPlanModule 'modules/functions-plan.bicep' = {
  name: 'functions-plan-deployment'
  params: {
    location: location
    tags: tags
    functionAppPlanName: resourceNames.functionAppPlan
  }
}

// Function App
module functionAppModule 'modules/functions.bicep' = {
  name: 'functions-deployment'
  params: {
    location: location
    tags: tags
    functionAppName: resourceNames.functionApp
    functionAppPlanId: functionAppPlanModule.outputs.functionAppPlanId
    subnetId: networkModule.outputs.integrationSubnetId
    keyVaultUri: keyVaultModule.outputs.keyVaultUri
    serviceBusNamespace: serviceBusModule.outputs.serviceBusNamespace
    appInsightsConnectionString: appInsightsModule.outputs.connectionString
  }
}

// RBAC Role Assignments
module rbacModule 'modules/rbac.bicep' = {
  name: 'rbac-deployment'
  params: {
    keyVaultName: resourceNames.keyVault
    appServicePrincipalId: appServiceModule.outputs.principalId
    functionAppPrincipalId: functionAppModule.outputs.principalId
    serviceBusName: resourceNames.serviceBus
    searchServiceName: resourceNames.search
  }
  dependsOn: [
    // searchModule is needed to ensure Search exists before RBAC assignment
    searchModule
  ]
}

// ============================================================================
// Phase 4 - Edge & Monitoring
// ============================================================================

// Log Analytics Workspace
module logAnalyticsModule 'modules/log-analytics.bicep' = {
  name: 'log-analytics-deployment'
  params: {
    location: location
    tags: tags
    workspaceName: resourceNames.logAnalytics
  }
}

// Application Insights
module appInsightsModule 'modules/app-insights.bicep' = {
  name: 'app-insights-deployment'
  params: {
    location: location
    tags: tags
    appInsightsName: resourceNames.appInsights
    logAnalyticsWorkspaceId: logAnalyticsModule.outputs.workspaceId
  }
}

// WAF Policy
module wafPolicyModule 'modules/waf-policy.bicep' = {
  name: 'waf-policy-deployment'
  params: {
    tags: tags
    wafPolicyName: resourceNames.wafPolicy
  }
}

// Front Door
module frontDoorModule 'modules/front-door.bicep' = {
  name: 'front-door-deployment'
  params: {
    tags: tags
    frontDoorName: resourceNames.frontDoor
    wafPolicyId: wafPolicyModule.outputs.wafPolicyId
    appServiceHostName: appServiceModule.outputs.defaultHostName
    staticWebAppHostName: staticWebAppModule.outputs.defaultHostName
  }
}

// Static Web App
module staticWebAppModule 'modules/static-web-app.bicep' = {
  name: 'static-web-app-deployment'
  params: {
    location: 'westeurope' // SWA has limited region support
    tags: tags
    staticWebAppName: resourceNames.staticWebApp
  }
}

// Diagnostic Settings
module diagnosticsModule 'modules/diagnostics.bicep' = {
  name: 'diagnostics-deployment'
  params: {
    logAnalyticsWorkspaceId: logAnalyticsModule.outputs.workspaceId
    appServiceName: appServiceModule.outputs.appServiceName
    functionAppName: functionAppModule.outputs.functionAppName
    keyVaultName: keyVaultModule.outputs.keyVaultName
    sqlServerName: sqlModule.outputs.sqlServerName
    redisCacheName: redisModule.outputs.redisCacheName
    serviceBusName: serviceBusModule.outputs.serviceBusName
    searchServiceName: searchModule.outputs.searchServiceName
    frontDoorName: frontDoorModule.outputs.frontDoorName
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Resource group name')
output resourceGroupName string = resourceGroup().name

@description('Virtual network resource ID')
output vnetId string = networkModule.outputs.vnetId

@description('Web subnet resource ID')
output webSubnetId string = networkModule.outputs.webSubnetId

@description('Data subnet resource ID')
output dataSubnetId string = networkModule.outputs.dataSubnetId

@description('Integration subnet resource ID')
output integrationSubnetId string = networkModule.outputs.integrationSubnetId

@description('Key Vault URI')
output keyVaultUri string = keyVaultModule.outputs.keyVaultUri

@description('SQL Server FQDN')
output sqlServerFqdn string = sqlModule.outputs.sqlServerFqdn

@description('Redis hostname')
output redisHostName string = redisModule.outputs.redisHostName

@description('App Service default hostname')
output appServiceHostName string = appServiceModule.outputs.defaultHostName

@description('Function App default hostname')
output functionAppHostName string = functionAppModule.outputs.defaultHostName

@description('Front Door endpoint hostname')
output frontDoorHostName string = frontDoorModule.outputs.endpointHostName

@description('Static Web App default hostname')
output staticWebAppHostName string = staticWebAppModule.outputs.defaultHostName

@description('Application Insights connection string')
output appInsightsConnectionString string = appInsightsModule.outputs.connectionString

@description('Log Analytics workspace ID')
output logAnalyticsWorkspaceId string = logAnalyticsModule.outputs.workspaceId
