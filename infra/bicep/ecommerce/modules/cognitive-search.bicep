// ============================================================================
// Cognitive Search Module
// ============================================================================
// Creates Azure Cognitive Search service with private endpoint
// ============================================================================

@description('Azure region for Search deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the Search service')
param searchServiceName string

@description('Subnet ID for private endpoint')
param subnetId string

@description('Private DNS zone ID for Search')
param privateDnsZoneId string

// ============================================================================
// Cognitive Search Service
// ============================================================================

resource searchService 'Microsoft.Search/searchServices@2024-03-01-preview' = {
  name: searchServiceName
  location: location
  tags: tags
  sku: {
    name: 'standard'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'disabled'
    networkRuleSet: {
      ipRules: []
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http403'
      }
    }
  }
}

// ============================================================================
// Private Endpoint
// ============================================================================

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: 'pe-${searchServiceName}'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${searchServiceName}-connection'
        properties: {
          privateLinkServiceId: searchService.id
          groupIds: [
            'searchService'
          ]
        }
      }
    ]
  }
}

// ============================================================================
// Private DNS Zone Group
// ============================================================================

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-01-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-search-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Search service resource ID')
output searchServiceId string = searchService.id

@description('Search service name')
output searchServiceName string = searchService.name

@description('Search service principal ID')
output searchServicePrincipalId string = searchService.identity.principalId
