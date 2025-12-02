// ============================================================================
// Virtual Network Module
// ============================================================================
// Creates VNet with subnets, NSG associations, and service endpoints
// ============================================================================

@description('Azure region for VNet deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the virtual network')
param vnetName string

@description('Address prefix for the VNet')
param addressPrefix string

@description('Subnet configurations')
param subnets array

// ============================================================================
// Virtual Network
// ============================================================================

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: subnet.nsgId != ''
            ? {
                id: subnet.nsgId
              }
            : null
          serviceEndpoints: subnet.serviceEndpoints
          delegations: subnet.delegations
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}

// ============================================================================
// Outputs
// ============================================================================

@description('Virtual network resource ID')
output vnetId string = vnet.id

@description('Virtual network name')
output vnetName string = vnet.name

@description('Web subnet resource ID')
output webSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnets[0].name)

@description('Data subnet resource ID')
output dataSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnets[1].name)

@description('Integration subnet resource ID')
output integrationSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnets[2].name)

@description('All subnet resource IDs')
output subnetIds object = {
  web: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnets[0].name)
  data: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnets[1].name)
  integration: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnets[2].name)
}
