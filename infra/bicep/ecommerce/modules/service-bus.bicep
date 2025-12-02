// ============================================================================
// Service Bus Module
// ============================================================================
// Creates Service Bus Premium namespace with queue and private endpoint
// ============================================================================

@description('Azure region for Service Bus deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the Service Bus namespace')
param serviceBusName string

@description('Subnet ID for private endpoint')
param subnetId string

@description('Private DNS zone ID for Service Bus')
param privateDnsZoneId string

// ============================================================================
// Service Bus Namespace
// ============================================================================

resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: serviceBusName
  location: location
  tags: tags
  sku: {
    name: 'Premium'
    tier: 'Premium'
    capacity: 1
  }
  properties: {
    zoneRedundant: true
    publicNetworkAccess: 'Disabled'
    disableLocalAuth: false
    minimumTlsVersion: '1.2'
  }
}

// ============================================================================
// Orders Queue
// ============================================================================

resource ordersQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: serviceBus
  name: 'orders'
  properties: {
    maxSizeInMegabytes: 5120
    requiresDuplicateDetection: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    requiresSession: false
    deadLetteringOnMessageExpiration: true
    maxDeliveryCount: 10
    enablePartitioning: false
    enableBatchedOperations: true
  }
}

// ============================================================================
// Dead Letter Queue (handled automatically by Service Bus)
// ============================================================================

// ============================================================================
// Private Endpoint
// ============================================================================

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: 'pe-${serviceBusName}'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${serviceBusName}-connection'
        properties: {
          privateLinkServiceId: serviceBus.id
          groupIds: [
            'namespace'
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
        name: 'privatelink-servicebus-windows-net'
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

@description('Service Bus namespace resource ID')
output serviceBusId string = serviceBus.id

@description('Service Bus namespace name')
output serviceBusName string = serviceBus.name

@description('Service Bus namespace FQDN')
output serviceBusNamespace string = '${serviceBus.name}.servicebus.windows.net'

@description('Orders queue name')
output ordersQueueName string = ordersQueue.name
