// ============================================================================
// Azure SQL Module
// ============================================================================
// Creates SQL Server with Azure AD-only auth and SQL Database with private endpoint
// ============================================================================

@description('Azure region for SQL deployment')
param location string

@description('Resource tags')
param tags object

@description('Name of the SQL Server')
param sqlServerName string

@description('Name of the SQL Database')
param sqlDatabaseName string

@description('Azure AD admin group object ID')
param adminGroupObjectId string

@description('Azure AD admin group name')
param adminGroupName string

@description('Subnet ID for private endpoint')
param subnetId string

@description('Private DNS zone ID for SQL')
param privateDnsZoneId string

// ============================================================================
// SQL Server
// ============================================================================

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  properties: {
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: adminGroupName
      sid: adminGroupObjectId
      tenantId: subscription().tenantId
      azureADOnlyAuthentication: true
    }
  }
}

// ============================================================================
// SQL Database
// ============================================================================

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  tags: tags
  sku: {
    name: 'S3'
    tier: 'Standard'
    capacity: 100
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 268435456000 // 250 GB
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Geo'
  }
}

// ============================================================================
// Transparent Data Encryption
// ============================================================================

resource tde 'Microsoft.Sql/servers/databases/transparentDataEncryption@2023-08-01-preview' = {
  parent: sqlDatabase
  name: 'current'
  properties: {
    state: 'Enabled'
  }
}

// ============================================================================
// Auditing Policy
// ============================================================================

resource auditingSettings 'Microsoft.Sql/servers/auditingSettings@2023-08-01-preview' = {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: true
    retentionDays: 90
  }
}

// ============================================================================
// Private Endpoint
// ============================================================================

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: 'pe-${sqlServerName}'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${sqlServerName}-connection'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
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
        name: 'privatelink-database-windows-net'
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

@description('SQL Server resource ID')
output sqlServerId string = sqlServer.id

@description('SQL Server name')
output sqlServerName string = sqlServer.name

@description('SQL Server FQDN')
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName

@description('SQL Database resource ID')
output sqlDatabaseId string = sqlDatabase.id

@description('SQL Database name')
output sqlDatabaseName string = sqlDatabase.name
