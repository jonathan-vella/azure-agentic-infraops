// =============================================================================
// SQL Database Module - Standard S0 Tier
// =============================================================================

@description('Azure region for resources')
param location string

@description('Environment name')
param environment string

@description('Project name')
param projectName string

@description('SQL Server name (from sql-server module)')
param sqlServerName string

@description('Resource tags')
param tags object

// -----------------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------------

var databaseName = 'sqldb-${projectName}-${environment}'

// -----------------------------------------------------------------------------
// Resources
// -----------------------------------------------------------------------------

// Reference existing SQL Server
resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: sqlServerName
}

// SQL Database - Standard S0 (10 DTU)
resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 10 // 10 DTU = S0
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 268435456000 // 250 GB
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Local'
  }
}

// -----------------------------------------------------------------------------
// Outputs
// -----------------------------------------------------------------------------

@description('Database name')
output databaseName string = sqlDatabase.name

@description('Database resource ID')
output databaseId string = sqlDatabase.id

@description('Connection string template (replace {your_password} with actual)')
output connectionStringTemplate string = 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};Authentication=Active Directory Default;'
