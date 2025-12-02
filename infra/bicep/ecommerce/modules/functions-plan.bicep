// ============================================================================
// Functions App Service Plan Module
// ============================================================================
// Creates Elastic Premium EP1 plan for VNet-integrated Functions
// ============================================================================

@description('Azure region for Functions plan deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the Functions App Service Plan')
param functionAppPlanName string

@description('Maximum elastic worker count')
@minValue(1)
@maxValue(20)
param maximumElasticWorkerCount int = 10

// ============================================================================
// Elastic Premium App Service Plan
// ============================================================================

resource functionAppPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: functionAppPlanName
  location: location
  tags: tags
  kind: 'elastic'
  sku: {
    name: 'EP1'
    tier: 'ElasticPremium'
    size: 'EP1'
    family: 'EP'
    capacity: 1
  }
  properties: {
    reserved: true // Linux
    maximumElasticWorkerCount: maximumElasticWorkerCount
    zoneRedundant: false // EP1 doesn't support zone redundancy
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Functions App Service Plan resource ID')
output functionAppPlanId string = functionAppPlan.id

@description('Functions App Service Plan name')
output functionAppPlanName string = functionAppPlan.name
