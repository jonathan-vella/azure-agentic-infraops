// ============================================================================
// Static Web App Module
// ============================================================================
// Creates Azure Static Web App for React SPA hosting
// ============================================================================

@description('Azure region for Static Web App (limited availability)')
@allowed([
  'westeurope'
  'eastus2'
  'westus2'
  'centralus'
  'eastasia'
])
param location string = 'westeurope'

@description('Resource tags')
param tags object

@description('Name of the Static Web App')
param staticWebAppName string

// ============================================================================
// Static Web App
// ============================================================================

resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    enterpriseGradeCdnStatus: 'Disabled' // Using Front Door instead
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Static Web App resource ID')
output staticWebAppId string = staticWebApp.id

@description('Static Web App name')
output staticWebAppName string = staticWebApp.name

@description('Static Web App default hostname')
output defaultHostName string = staticWebApp.properties.defaultHostname

@description('Static Web App deployment token')
#disable-next-line outputs-should-not-contain-secrets
output deploymentToken string = staticWebApp.listSecrets().properties.apiKey
