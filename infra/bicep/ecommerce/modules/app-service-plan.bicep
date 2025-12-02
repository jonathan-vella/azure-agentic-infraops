// ============================================================================
// App Service Plan Module
// ============================================================================
// Creates P1v3 zone-redundant App Service Plan for production workloads
// ============================================================================

@description('Azure region for App Service Plan deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the App Service Plan')
param appServicePlanName string

@description('Number of worker instances')
@minValue(2)
@maxValue(10)
param capacity int = 2

// ============================================================================
// App Service Plan
// ============================================================================

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  kind: 'linux'
  sku: {
    name: 'P1v3'
    tier: 'PremiumV3'
    size: 'P1v3'
    capacity: capacity
  }
  properties: {
    reserved: true // Linux
    zoneRedundant: true // Requires Premium SKU
    targetWorkerCount: capacity
    targetWorkerSizeId: 0
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('App Service Plan resource ID')
output appServicePlanId string = appServicePlan.id

@description('App Service Plan name')
output appServicePlanName string = appServicePlan.name
