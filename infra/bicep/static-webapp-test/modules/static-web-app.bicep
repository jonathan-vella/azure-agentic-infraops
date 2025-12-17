// =============================================================================
// Static Web App Module - Free Tier
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

var staticWebAppName = 'stapp-${projectName}-${environment}'

// -----------------------------------------------------------------------------
// Resources
// -----------------------------------------------------------------------------

// Static Web App - Free tier
resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  tags: tags
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    buildProperties: {
      appLocation: '/'
      apiLocation: 'api'
      outputLocation: 'build'
      skipGithubActionWorkflowGeneration: true
    }
  }
}

// -----------------------------------------------------------------------------
// Outputs
// -----------------------------------------------------------------------------

@description('Static Web App name')
output staticWebAppName string = staticWebApp.name

@description('Static Web App default hostname')
output staticWebAppUrl string = 'https://${staticWebApp.properties.defaultHostname}'

@description('Static Web App resource ID')
output staticWebAppId string = staticWebApp.id

@description('Static Web App API key (for CI/CD deployment)')
#disable-next-line outputs-should-not-contain-secrets
output staticWebAppApiKey string = staticWebApp.listSecrets().properties.apiKey
