---
description: "Infrastructure as Code best practices for Azure Bicep templates"
applyTo: "**/*.bicep"
---

# Bicep Development Best Practices

Guidelines for writing high-quality, secure, and maintainable Bicep infrastructure-as-code templates for Azure deployments. Follow these standards to ensure consistency across the repository.

## General Instructions

- Use latest stable API versions for all Azure resources
- Default to `swedencentral` region (alternative: `germanywestcentral` for quota issues)
- Generate unique resource name suffixes in main.bicep: `var uniqueSuffix = uniqueString(resourceGroup().id)`
- Pass `uniqueSuffix` parameter to ALL modules for consistent naming

## Naming Conventions

Use lowerCamelCase for all Bicep identifiers:

| Element    | Convention                  | Example                                  |
| ---------- | --------------------------- | ---------------------------------------- |
| Parameters | lowerCamelCase, descriptive | `storageAccountName`, `environment`      |
| Variables  | lowerCamelCase              | `uniqueSuffix`, `resourceNamePrefix`     |
| Resources  | Descriptive symbolic name   | `storageAccount` (not `sa` or `storage`) |
| Modules    | lowerCamelCase              | `networkModule`, `keyVaultModule`        |

### Resource Naming Patterns

| Resource Type   | Max Length | Pattern                        | Example                  |
| --------------- | ---------- | ------------------------------ | ------------------------ |
| Storage Account | 24 chars   | `st{project}{env}{suffix}`     | `stcontosodev7xk2`       |
| Key Vault       | 24 chars   | `kv-{project}-{env}-{suffix}`  | `kv-contoso-dev-abc123`  |
| SQL Server      | 63 chars   | `sql-{project}-{env}-{suffix}` | `sql-contoso-dev-abc123` |
| App Service     | 60 chars   | `app-{project}-{env}-{suffix}` | `app-contoso-dev-abc123` |

### Good Example - Resource naming with unique suffix

```bicep
// main.bicep - Generate suffix once, pass to all modules
var uniqueSuffix = uniqueString(resourceGroup().id)

module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVaultDeployment'
  params: {
    uniqueSuffix: uniqueSuffix
    environment: environment
  }
}
```

### Bad Example - Hardcoded or missing unique names

```bicep
// Avoid: Hardcoded names cause deployment collisions
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'mykeyvault'  // Will fail if name already exists globally
}
```

## Code Standards

### Parameters

- Declare all parameters at the top of files
- Add `@description()` decorator for every parameter
- Use `@allowed()` sparingly to avoid blocking valid deployments
- Set safe default values for test environments (low-cost tiers)

### Good Example - Well-documented parameters

```bicep
@description('Azure region for all resources. Defaults to Sweden Central for sustainability.')
@allowed([
  'swedencentral'
  'germanywestcentral'
  'northeurope'
])
param location string = 'swedencentral'

@description('Environment name used in resource naming.')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('Unique suffix for resource naming. Generate with uniqueString(resourceGroup().id).')
@minLength(5)
@maxLength(13)
param uniqueSuffix string
```

### Bad Example - Missing decorators and validation

```bicep
// Avoid: No documentation, no validation
param location string
param env string
param suffix string
```

### Variables

- Use variables for complex expressions to improve readability
- Variables automatically infer types from resolved values
- Combine related values into structured variables

```bicep
var resourceTags = {
  Environment: environment
  ManagedBy: 'Bicep'
  Project: projectName
}

var keyVaultName = 'kv-${take(projectName, 10)}-${environment}-${take(uniqueSuffix, 6)}'
```

### Resource References

- Use symbolic names for resource references (not `reference()` or `resourceId()`)
- Create dependencies through symbolic names (`resourceA.id`) not explicit `dependsOn`
- Use `existing` keyword to reference resources defined elsewhere

### Good Example - Symbolic references

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  // ...
}

resource appService 'Microsoft.Web/sites@2023-01-01' = {
  name: appServiceName
  properties: {
    // Implicit dependency through symbolic reference
    siteConfig: {
      appSettings: [
        {
          name: 'STORAGE_CONNECTION'
          value: storageAccount.properties.primaryEndpoints.blob
        }
      ]
    }
  }
}
```

### Good Example - Referencing existing resources for diagnostic settings

When creating diagnostic settings or other extension resources that need a `scope`, use the `existing` keyword to reference resources by name, not by resource ID string:

```bicep
// ✅ CORRECT: Use existing keyword to reference resources
param appServiceName string
param logAnalyticsWorkspaceId string

resource appService 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appServiceName
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-appservice'
  scope: appService  // Symbolic reference to existing resource
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      { category: 'AppServiceHTTPLogs', enabled: true }
    ]
  }
}
```

### Bad Example - Using resource ID strings for scope

```bicep
// ❌ WRONG: Causes BCP036 error - scope expects resource type, not string
param appServiceId string

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-appservice'
  scope: resourceId('Microsoft.Web/sites', last(split(appServiceId, '/')))  // ERROR!
  properties: { ... }
}
```

### Bad Example - Explicit dependsOn and reference functions

```bicep
// Avoid: Unnecessary explicit dependencies
resource appService 'Microsoft.Web/sites@2023-01-01' = {
  name: appServiceName
  dependsOn: [storageAccount]  // Unnecessary if already referencing
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'STORAGE_CONNECTION'
          value: reference(storageAccount.id).primaryEndpoints.blob  // Use symbolic name instead
        }
      ]
    }
  }
}
```

## Security Best Practices

- Enable HTTPS-only traffic: `supportsHttpsTrafficOnly: true`
- Require TLS 1.2 minimum: `minimumTlsVersion: 'TLS1_2'`
- Disable public blob access: `allowBlobPublicAccess: false`
- Use Azure AD authentication for SQL Server (Azure AD-only auth)
- Never include secrets or keys in outputs
- Use managed identities instead of connection strings

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    encryption: {
      services: {
        blob: { enabled: true }
        file: { enabled: true }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}
```

## Common Patterns

### Child Resources

- Use `parent` property or nesting instead of constructing resource names
- Avoid excessive nesting depth (max 2 levels)

### Good Example - Parent property

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  // ...
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}
```

### Bad Example - Constructed names

```bicep
// Avoid: Manual name construction
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: '${storageAccountName}/default'  // Use parent property instead
}
```

## Patterns to Avoid

| Anti-Pattern                              | Problem                      | Solution                                       |
| ----------------------------------------- | ---------------------------- | ---------------------------------------------- |
| Hardcoded resource names                  | Deployment collisions        | Use `uniqueString()` suffix                    |
| Missing `@description`                    | Poor maintainability         | Document all parameters                        |
| Explicit `dependsOn`                      | Unnecessary complexity       | Use symbolic references                        |
| Secrets in outputs                        | Security vulnerability       | Use Key Vault references                       |
| S1 SKU for zone redundancy                | Policy violation             | Use P1v3 or higher                             |
| Old API versions                          | Missing features             | Use latest stable versions                     |
| Resource ID strings for scope             | BCP036 type error            | Use `existing` resource references             |
| Passing resource IDs to modules for scope | Scope requires resource type | Pass resource names and use `existing` keyword |
| WAF `RequestHeaders` matchVariable        | ARM EnumerationOutOfRange    | Use `RequestHeader` (singular) - see valid values below |

### WAF Policy matchVariable Valid Values

When creating WAF custom rules, use only these valid `matchVariable` values:

- `RemoteAddr` - Client IP address
- `RequestMethod` - HTTP method (GET, POST, etc.)
- `QueryString` - URL query string
- `PostArgs` - POST request body arguments
- `RequestUri` - Request URI path
- `RequestHeader` - HTTP request header (requires `selector` for header name)
- `RequestBody` - Request body content
- `Cookies` - HTTP cookies
- `SocketAddr` - Socket address

**Common Mistake**: Using `RequestHeaders` (plural) instead of `RequestHeader` (singular).

## Validation

Run these commands before committing Bicep code:

```bash
# Build - Compile Bicep to ARM template
bicep build main.bicep

# Lint - Check for best practice violations
bicep lint main.bicep

# What-If - Preview deployment changes
az deployment group what-if \
  --resource-group rg-example \
  --template-file main.bicep \
  --parameters @parameters.json
```

## Documentation

- Include `//` comments explaining complex logic
- Add module-level comments describing purpose
- Document outputs with descriptions
