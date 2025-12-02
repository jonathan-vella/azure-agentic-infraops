// ============================================================================
// Azure Front Door Module
// ============================================================================
// Creates Front Door Standard with WAF for global load balancing
// ============================================================================

@description('Resource tags')
param tags object

@description('Name of the Front Door profile')
param frontDoorName string

@description('WAF policy resource ID')
param wafPolicyId string

@description('App Service hostname')
param appServiceHostName string

@description('Static Web App hostname')
param staticWebAppHostName string

// ============================================================================
// Front Door Profile
// ============================================================================

resource frontDoorProfile 'Microsoft.Cdn/profiles@2024-02-01' = {
  name: frontDoorName
  location: 'global'
  tags: tags
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  properties: {
    originResponseTimeoutSeconds: 60
  }
}

// ============================================================================
// Endpoint
// ============================================================================

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdendpoints@2024-02-01' = {
  parent: frontDoorProfile
  name: 'ecommerce-endpoint'
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

// ============================================================================
// Origin Groups
// ============================================================================

// API Origin Group
resource apiOriginGroup 'Microsoft.Cdn/profiles/origingroups@2024-02-01' = {
  parent: frontDoorProfile
  name: 'api-origin-group'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/health'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 30
    }
    sessionAffinityState: 'Disabled'
  }
}

// SPA Origin Group
resource spaOriginGroup 'Microsoft.Cdn/profiles/origingroups@2024-02-01' = {
  parent: frontDoorProfile
  name: 'spa-origin-group'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 60
    }
    sessionAffinityState: 'Disabled'
  }
}

// ============================================================================
// Origins
// ============================================================================

// API Origin (App Service)
resource apiOrigin 'Microsoft.Cdn/profiles/origingroups/origins@2024-02-01' = {
  parent: apiOriginGroup
  name: 'api-origin'
  properties: {
    hostName: appServiceHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: appServiceHostName
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}

// SPA Origin (Static Web App)
resource spaOrigin 'Microsoft.Cdn/profiles/origingroups/origins@2024-02-01' = {
  parent: spaOriginGroup
  name: 'spa-origin'
  properties: {
    hostName: staticWebAppHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: staticWebAppHostName
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}

// ============================================================================
// Routes
// ============================================================================

// API Route
resource apiRoute 'Microsoft.Cdn/profiles/afdendpoints/routes@2024-02-01' = {
  parent: frontDoorEndpoint
  name: 'api-route'
  properties: {
    originGroup: {
      id: apiOriginGroup.id
    }
    supportedProtocols: [
      'Https'
    ]
    patternsToMatch: [
      '/api/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
  dependsOn: [
    apiOrigin
  ]
}

// SPA Route (catch-all)
resource spaRoute 'Microsoft.Cdn/profiles/afdendpoints/routes@2024-02-01' = {
  parent: frontDoorEndpoint
  name: 'spa-route'
  properties: {
    originGroup: {
      id: spaOriginGroup.id
    }
    supportedProtocols: [
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
  dependsOn: [
    spaOrigin
    apiRoute // API route should be matched first
  ]
}

// ============================================================================
// Security Policy (WAF)
// ============================================================================

resource securityPolicy 'Microsoft.Cdn/profiles/securitypolicies@2024-02-01' = {
  parent: frontDoorProfile
  name: 'waf-security-policy'
  properties: {
    parameters: {
      type: 'WebApplicationFirewall'
      wafPolicy: {
        id: wafPolicyId
      }
      associations: [
        {
          domains: [
            {
              id: frontDoorEndpoint.id
            }
          ]
          patternsToMatch: [
            '/*'
          ]
        }
      ]
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Front Door profile resource ID')
output frontDoorId string = frontDoorProfile.id

@description('Front Door profile name')
output frontDoorName string = frontDoorProfile.name

@description('Front Door endpoint hostname')
output endpointHostName string = frontDoorEndpoint.properties.hostName
