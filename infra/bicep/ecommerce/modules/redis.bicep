// ============================================================================
// Redis Cache Module
// ============================================================================
// Creates Azure Cache for Redis with private endpoint
// ============================================================================

@description('Azure region for Redis deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the Redis Cache')
param redisName string

@description('Subnet ID for private endpoint')
param subnetId string

@description('Private DNS zone ID for Redis')
param privateDnsZoneId string

// ============================================================================
// Redis Cache
// ============================================================================

resource redisCache 'Microsoft.Cache/redis@2024-03-01' = {
  name: redisName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'Standard'
      family: 'C'
      capacity: 2
    }
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    redisConfiguration: {
      'maxmemory-policy': 'volatile-lru'
      'maxmemory-reserved': '50'
    }
  }
}

// ============================================================================
// Private Endpoint
// ============================================================================

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: 'pe-${redisName}'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${redisName}-connection'
        properties: {
          privateLinkServiceId: redisCache.id
          groupIds: [
            'redisCache'
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
        name: 'privatelink-redis-cache-windows-net'
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

@description('Redis Cache resource ID')
output redisCacheId string = redisCache.id

@description('Redis Cache name')
output redisCacheName string = redisCache.name

@description('Redis Cache hostname')
output redisHostName string = redisCache.properties.hostName

@description('Redis Cache SSL port')
output redisSslPort int = redisCache.properties.sslPort
