// ============================================================================
// Network Security Groups Module
// ============================================================================
// Creates NSGs for web, data, and integration tiers with deny-by-default rules
// ============================================================================

@description('Azure region for NSG deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the web tier NSG')
param nsgWebName string

@description('Name of the data tier NSG')
param nsgDataName string

@description('Name of the integration tier NSG')
param nsgIntegrationName string

@description('Web subnet address prefix')
param webSubnetPrefix string

@description('Data subnet address prefix')
param dataSubnetPrefix string

@description('Integration subnet address prefix')
param integrationSubnetPrefix string

// ============================================================================
// Web Tier NSG - Allows HTTPS from Front Door only
// ============================================================================

resource nsgWeb 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: nsgWebName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowFrontDoorHTTPS'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureFrontDoor.Backend'
          sourcePortRange: '*'
          destinationAddressPrefix: webSubnetPrefix
          destinationPortRange: '443'
          description: 'Allow HTTPS traffic from Azure Front Door'
        }
      }
      {
        name: 'AllowHealthProbes'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationAddressPrefix: webSubnetPrefix
          destinationPortRange: '*'
          description: 'Allow Azure health probes'
        }
      }
      {
        name: 'AllowVNetInbound'
        properties: {
          priority: 200
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '*'
          description: 'Allow VNet internal communication'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          description: 'Deny all other inbound traffic'
        }
      }
    ]
  }
}

// ============================================================================
// Data Tier NSG - Allows traffic from web and integration tiers only
// ============================================================================

resource nsgData 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: nsgDataName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowWebSubnetInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: webSubnetPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: dataSubnetPrefix
          destinationPortRange: '*'
          description: 'Allow traffic from web tier'
        }
      }
      {
        name: 'AllowIntegrationSubnetInbound'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: integrationSubnetPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: dataSubnetPrefix
          destinationPortRange: '*'
          description: 'Allow traffic from integration tier'
        }
      }
      {
        name: 'AllowAzureServicesInbound'
        properties: {
          priority: 200
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'AzureCloud'
          sourcePortRange: '*'
          destinationAddressPrefix: dataSubnetPrefix
          destinationPortRange: '*'
          description: 'Allow Azure services for private endpoints'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          description: 'Deny all other inbound traffic'
        }
      }
    ]
  }
}

// ============================================================================
// Integration Tier NSG - Allows traffic from web and data tiers
// ============================================================================

resource nsgIntegration 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: nsgIntegrationName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowWebSubnetInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: webSubnetPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: integrationSubnetPrefix
          destinationPortRange: '*'
          description: 'Allow traffic from web tier'
        }
      }
      {
        name: 'AllowDataSubnetInbound'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: dataSubnetPrefix
          sourcePortRange: '*'
          destinationAddressPrefix: integrationSubnetPrefix
          destinationPortRange: '*'
          description: 'Allow traffic from data tier'
        }
      }
      {
        name: 'AllowAzureServicesInbound'
        properties: {
          priority: 200
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'AzureCloud'
          sourcePortRange: '*'
          destinationAddressPrefix: integrationSubnetPrefix
          destinationPortRange: '*'
          description: 'Allow Azure services for Service Bus'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          description: 'Deny all other inbound traffic'
        }
      }
    ]
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Web tier NSG resource ID')
output nsgWebId string = nsgWeb.id

@description('Data tier NSG resource ID')
output nsgDataId string = nsgData.id

@description('Integration tier NSG resource ID')
output nsgIntegrationId string = nsgIntegration.id

@description('Web tier NSG name')
output nsgWebName string = nsgWeb.name

@description('Data tier NSG name')
output nsgDataName string = nsgData.name

@description('Integration tier NSG name')
output nsgIntegrationName string = nsgIntegration.name
