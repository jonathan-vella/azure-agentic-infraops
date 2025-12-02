// ============================================================================
// Private DNS Zones Module
// ============================================================================
// Creates private DNS zones for all Azure services with private endpoints
// ============================================================================

@description('Resource tags')
param tags object

@description('VNet resource ID for linking')
param vnetId string

@description('VNet name for link naming')
param vnetName string

// ============================================================================
// Private DNS Zone Names
// ============================================================================

var dnsZones = [
  'privatelink.vaultcore.azure.net' // Key Vault
  'privatelink.database.windows.net' // SQL
  'privatelink.redis.cache.windows.net' // Redis
  'privatelink.search.windows.net' // Cognitive Search
  'privatelink.servicebus.windows.net' // Service Bus
]

// ============================================================================
// Private DNS Zones
// ============================================================================

resource privateDnsZones 'Microsoft.Network/privateDnsZones@2024-06-01' = [
  for zone in dnsZones: {
    name: zone
    location: 'global'
    tags: tags
  }
]

// ============================================================================
// VNet Links
// ============================================================================

resource vnetLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = [
  for (zone, i) in dnsZones: {
    parent: privateDnsZones[i]
    name: '${vnetName}-link'
    location: 'global'
    tags: tags
    properties: {
      registrationEnabled: false
      virtualNetwork: {
        id: vnetId
      }
    }
  }
]

// ============================================================================
// Outputs
// ============================================================================

@description('Key Vault private DNS zone ID')
output keyVaultDnsZoneId string = privateDnsZones[0].id

@description('SQL private DNS zone ID')
output sqlDnsZoneId string = privateDnsZones[1].id

@description('Redis private DNS zone ID')
output redisDnsZoneId string = privateDnsZones[2].id

@description('Search private DNS zone ID')
output searchDnsZoneId string = privateDnsZones[3].id

@description('Service Bus private DNS zone ID')
output serviceBusDnsZoneId string = privateDnsZones[4].id
