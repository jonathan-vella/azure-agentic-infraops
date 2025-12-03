# Step 6: Bicep Implementation Issues & Solutions

> **Agent Used:** `bicep-implement`  
> **Purpose:** Document issues encountered during Bicep code generation and their solutions

---

## 💬 Context

During the Bicep implementation phase, several issues were encountered that required
debugging and documentation updates. These are captured here for future reference.

---

## Issue 1: BCP036 Diagnostic Settings Scope Error

### ❌ Problem

When creating a diagnostic settings module that accepts resource IDs as parameters:

```bicep
// modules/diagnostics.bicep
param appServiceId string

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-appservice'
  scope: appServiceId  // ❌ ERROR: BCP036
  properties: { ... }
}
```

**Error Message:**

```
BCP036: The property "scope" expected a value of type "resource | tenant" but the
provided value is of type "string".
```

### ✅ Solution

Pass resource **names** (not IDs) and use the `existing` keyword:

```bicep
// main.bicep - Pass NAMES not IDs
module diagnosticsModule 'modules/diagnostics.bicep' = {
  params: {
    appServiceName: appServiceModule.outputs.appServiceName  // ✅ Name
    logAnalyticsWorkspaceId: logAnalyticsModule.outputs.workspaceId
  }
}

// modules/diagnostics.bicep - Use existing keyword
param appServiceName string

resource appService 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appServiceName
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-appservice'
  scope: appService  // ✅ Symbolic reference works
  properties: { ... }
}
```

### 📝 Documentation Updated

- `.github/copilot-instructions.md` - Added diagnostic settings pattern
- `.github/agents/bicep-implement.agent.md` - Added to anti-patterns table
- `.github/instructions/bicep-code-best-practices.instructions.md` - Added example

---

## Issue 2: WAF matchVariable Validation Error

### ❌ Problem

When creating WAF custom rules with `RequestHeaders`:

```bicep
// modules/waf-policy.bicep
customRules: [
  {
    name: 'BlockSuspiciousUserAgents'
    matchConditions: [
      {
        matchVariables: [
          {
            variableName: 'RequestHeaders'  // ❌ ERROR
            selector: 'User-Agent'
          }
        ]
      }
    ]
  }
]
```

**Error Message:**

```
InvalidRequestContent: The request content was invalid and could not be deserialized:
'Error converting value "RequestHeaders" to type '...' Path 'properties.customRules[0]
.matchConditions[0].matchVariables[0].variableName'
```

### ✅ Solution

Use `RequestHeader` (singular) not `RequestHeaders`:

```bicep
matchVariables: [
  {
    variableName: 'RequestHeader'  // ✅ Singular form
    selector: 'User-Agent'
  }
]
```

### Valid matchVariable Values

| Value           | Description                    |
| --------------- | ------------------------------ |
| `RemoteAddr`    | Client IP address              |
| `RequestMethod` | HTTP method (GET, POST, etc.)  |
| `QueryString`   | URL query string               |
| `PostArgs`      | POST request body arguments    |
| `RequestUri`    | Request URI path               |
| `RequestHeader` | HTTP request header (singular) |
| `RequestBody`   | Request body content           |
| `Cookies`       | HTTP cookies                   |
| `SocketAddr`    | Socket address                 |

### 📝 Documentation Updated

- `.github/copilot-instructions.md` - Added WAF matchVariable guidance
- `.github/agents/bicep-implement.agent.md` - Added to anti-patterns table
- `.github/instructions/bicep-code-best-practices.instructions.md` - Added valid values section

---

## Issue 3: Unnecessary dependsOn Warnings

### ⚠️ Warning

Bicep linter flagged explicit `dependsOn` entries:

```bicep
module appService 'modules/app-service.bicep' = {
  dependsOn: [
    networkModule
    keyVaultModule
  ]
}
```

**Warning:**

```
BCP254: This dependsOn entry is unnecessary because the resource or module is
already implicitly dependent.
```

### ✅ Solution

Remove redundant `dependsOn` when symbolic references create implicit dependencies:

```bicep
module appService 'modules/app-service.bicep' = {
  params: {
    subnetId: networkModule.outputs.webSubnetId  // ✅ Implicit dependency
    keyVaultName: keyVaultModule.outputs.keyVaultName
  }
  // No dependsOn needed - Bicep tracks dependencies automatically
}
```

---

## Issue 4: Resource Group Not Existing for What-If

### ❌ Problem

Running `what-if` analysis before creating resource group:

```powershell
az deployment group what-if --resource-group rg-ecommerce-prod-swc ...
```

**Error:**

```
ResourceGroupNotFound: Resource group 'rg-ecommerce-prod-swc' could not be found.
```

### ✅ Solution

Always create the resource group before running what-if:

```powershell
# deploy.ps1 - Always create RG first
$rgExists = az group exists --name $ResourceGroupName 2>&1
if ($rgExists -eq 'false') {
    az group create --name $ResourceGroupName --location $Location --tags ...
}

# Now what-if will work
az deployment group what-if --resource-group $ResourceGroupName ...
```

---

## Issue 5: SQL Admin Identity Not Provided

### ❌ Problem

Deployment required `SqlAdminGroupObjectId` parameter but users didn't always have it:

```powershell
./deploy.ps1 -ResourceGroupName "rg-ecommerce-prod-swc"
# ERROR: SqlAdminGroupObjectId is required
```

### ✅ Solution

Auto-detect current Azure user when parameter not provided:

```powershell
if (-not $SqlAdminGroupObjectId) {
    $signedInUser = az ad signed-in-user show 2>&1 | ConvertFrom-Json
    $SqlAdminGroupObjectId = $signedInUser.id
    $SqlAdminGroupName = $signedInUser.displayName
    Write-SubStep "Using current user as SQL admin"
    Write-Info "Name" $signedInUser.displayName
    Write-Info "Object ID" $SqlAdminGroupObjectId
}
```

---

## Summary of Documentation Updates

| File                                                             | Changes Added                                                                                       |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `.github/copilot-instructions.md`                                | Diagnostic settings pattern, WAF matchVariable, SQL admin auto-detect, deployment script formatting |
| `.github/agents/bicep-implement.agent.md`                        | Anti-patterns table with BCP036, WAF, scope errors; Deployment script requirements section          |
| `.github/instructions/bicep-code-best-practices.instructions.md` | `existing` keyword pattern, WAF valid values, deployment script section                             |

---

## ➡️ Next Step

Proceed with **deployment script enhancements** and actual Azure deployment.
