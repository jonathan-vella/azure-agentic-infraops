// ============================================================================
// RBAC Role Assignments Module
// ============================================================================
// Assigns required roles to managed identities
// ============================================================================

@description('Key Vault name')
param keyVaultName string

@description('App Service managed identity principal ID')
param appServicePrincipalId string

@description('Function App managed identity principal ID')
param functionAppPrincipalId string

@description('Service Bus namespace name')
param serviceBusName string

@description('Search service name')
param searchServiceName string

// ============================================================================
// Role Definition IDs
// ============================================================================

var roleDefinitions = {
  // Key Vault Secrets User - read secrets
  keyVaultSecretsUser: '4633458b-17de-408a-b874-0445c86b69e6'
  // Azure Service Bus Data Sender - send messages
  serviceBusDataSender: '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
  // Azure Service Bus Data Receiver - receive messages
  serviceBusDataReceiver: '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0'
  // Search Index Data Reader - query search indexes
  searchIndexDataReader: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
}

// ============================================================================
// Key Vault References
// ============================================================================

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusName
}

resource searchService 'Microsoft.Search/searchServices@2024-03-01-preview' existing = {
  name: searchServiceName
}

// ============================================================================
// Key Vault Role Assignments
// ============================================================================

// App Service - Key Vault Secrets User
resource appServiceKeyVaultRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVault
  name: guid(keyVault.id, appServicePrincipalId, roleDefinitions.keyVaultSecretsUser)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      roleDefinitions.keyVaultSecretsUser
    )
    principalId: appServicePrincipalId
    principalType: 'ServicePrincipal'
  }
}

// Function App - Key Vault Secrets User
resource functionAppKeyVaultRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVault
  name: guid(keyVault.id, functionAppPrincipalId, roleDefinitions.keyVaultSecretsUser)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      roleDefinitions.keyVaultSecretsUser
    )
    principalId: functionAppPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// ============================================================================
// Service Bus Role Assignments
// ============================================================================

// App Service - Service Bus Data Sender
resource appServiceServiceBusSenderRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: serviceBus
  name: guid(serviceBus.id, appServicePrincipalId, roleDefinitions.serviceBusDataSender)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      roleDefinitions.serviceBusDataSender
    )
    principalId: appServicePrincipalId
    principalType: 'ServicePrincipal'
  }
}

// Function App - Service Bus Data Receiver
resource functionAppServiceBusReceiverRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: serviceBus
  name: guid(serviceBus.id, functionAppPrincipalId, roleDefinitions.serviceBusDataReceiver)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      roleDefinitions.serviceBusDataReceiver
    )
    principalId: functionAppPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// ============================================================================
// Search Role Assignments
// ============================================================================

// App Service - Search Index Data Reader
resource appServiceSearchRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: searchService
  name: guid(searchService.id, appServicePrincipalId, roleDefinitions.searchIndexDataReader)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      roleDefinitions.searchIndexDataReader
    )
    principalId: appServicePrincipalId
    principalType: 'ServicePrincipal'
  }
}
