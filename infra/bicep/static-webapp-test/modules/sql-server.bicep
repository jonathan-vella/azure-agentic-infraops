// =============================================================================
// SQL Server Module - Azure AD Authentication Only
// =============================================================================

@description('Azure region for resources')
param location string

@description('Environment name')
param environment string

@description('Project name')
param projectName string

@description('Unique suffix for globally unique names')
param uniqueSuffix string

@description('Azure AD Object ID for SQL Server administrator')
param sqlAdminObjectId string

@description('Display name for SQL Server administrator')
param sqlAdminName string

@description('Resource tags')
param tags object

// -----------------------------------------------------------------------------
// Variables
// -----------------------------------------------------------------------------

// SQL Server name must be globally unique, lowercase, 1-63 chars
var sqlServerName = 'sql-${take(replace(projectName, '-', ''), 10)}-${environment}-${take(uniqueSuffix, 6)}'

// -----------------------------------------------------------------------------
// Resources
// -----------------------------------------------------------------------------

// SQL Server with Azure AD-only authentication (required by policy)
resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  properties: {
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: sqlAdminName
      sid: sqlAdminObjectId
      tenantId: tenant().tenantId
      azureADOnlyAuthentication: true
    }
  }
}

// Allow Azure services to access SQL Server
resource sqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2023-08-01-preview' = {
  parent: sqlServer
  name: 'AllowAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// -----------------------------------------------------------------------------
// Outputs
// -----------------------------------------------------------------------------

@description('SQL Server name')
output sqlServerName string = sqlServer.name

@description('SQL Server fully qualified domain name')
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName

@description('SQL Server resource ID')
output sqlServerId string = sqlServer.id
