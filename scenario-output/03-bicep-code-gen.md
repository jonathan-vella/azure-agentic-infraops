# Step 4: Bicep Implementation Strategy

> **Agent Used:** `bicep-implement`  
> **Purpose:** Generate Bicep code using Azure Verified Modules (AVM)

---

## 💬 Prompt

```text
Before you proceed with Bicep code generation, how can we make sure that we do not
run into the same issue as before (response hit the length limit)?
```

---

## ✅ Solution: Phase-by-Phase Code Generation

The same token limit issue will occur when generating Bicep code for 26 resources. Use the phased approach:

---

## Strategy Options

### Option A: Sequential Phase Implementation ✅ Recommended

| Prompt                    | Files Generated                                                                                                           | Est. Size     |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------------- |
| "Implement Phase 1 Bicep" | `main.bicep` scaffold, `network.bicep`, `nsg.bicep`                                                                       | ~2,500 tokens |
| "Implement Phase 2 Bicep" | `key-vault.bicep`, `sql.bicep`, `redis.bicep`, `app-service-plan.bicep`, `private-dns.bicep`                              | ~3,000 tokens |
| "Implement Phase 3 Bicep" | `app-service.bicep`, `search.bicep`, `service-bus.bicep`, `functions.bicep`, `rbac.bicep`                                 | ~3,000 tokens |
| "Implement Phase 4 Bicep" | `log-analytics.bicep`, `app-insights.bicep`, `front-door.bicep`, `waf.bicep`, `static-web-app.bicep`, `diagnostics.bicep` | ~2,500 tokens |
| "Finalize"                | Update `main.bicep`, `main.bicepparam`, `deploy.ps1`, `README.md`                                                         | ~2,000 tokens |

**Pros:**

- Matches planning phases
- Easy to track progress
- Can validate each phase before continuing
- Clear rollback points

---

### Option B: Module-by-Module Implementation

Generate 2-3 modules per prompt for smaller chunks.

**Pros:**

- Smallest possible chunks
- Least likely to hit limits

**Cons:**

- More prompts needed (8-10 total)
- Harder to track

---

### Option C: Scaffold First, Then Fill

```text
Prompt 1: Create all empty module files with interfaces (params/outputs only)
Prompt 2-N: Fill each module implementation
```

**Pros:**

- Clear structure first
- Consistent interfaces

**Cons:**

- More round trips

---

## Recommended Prompts (Option A)

### Phase 1 — Foundation

```text
Implement Phase 1 Bicep code:
- Create main.bicep scaffold with uniqueSuffix and parameters
- Create modules/network.bicep using avm/res/network/virtual-network
- Create modules/nsg.bicep using avm/res/network/network-security-group

Use the implementation plan from INFRA.ecommerce-phase1-foundation.md
Region: swedencentral
```

### Phase 2 — Platform Services

```text
Implement Phase 2 Bicep code:
- modules/key-vault.bicep using avm/res/key-vault/vault
- modules/sql.bicep using avm/res/sql/server
- modules/redis.bicep using avm/res/cache/redis
- modules/app-service-plan.bicep using avm/res/web/serverfarm
- modules/private-dns.bicep

Reference Phase 1 outputs for VNet and subnet IDs.
```

### Phase 3 — Application Tier

```text
Implement Phase 3 Bicep code:
- modules/app-service.bicep using avm/res/web/site
- modules/cognitive-search.bicep using avm/res/search/search-service
- modules/service-bus.bicep using avm/res/service-bus/namespace
- modules/functions.bicep
- modules/rbac.bicep for managed identity role assignments

Reference Phase 1-2 outputs.
```

### Phase 4 — Edge & Monitoring

```text
Implement Phase 4 Bicep code:
- modules/log-analytics.bicep using avm/res/operational-insights/workspace
- modules/app-insights.bicep using avm/res/insights/component
- modules/front-door.bicep using avm/res/cdn/profile
- modules/waf-policy.bicep
- modules/static-web-app.bicep using avm/res/web/static-site
- modules/diagnostics.bicep
```

### Finalize

```text
Complete the Bicep implementation:
- Update main.bicep with all module references
- Create main.bicepparam with environment-specific values
- Create deploy.ps1 PowerShell deployment script
- Create README.md with deployment instructions
```

---

## Expected File Structure

```
infra/bicep/ecommerce/
├── main.bicep                    # Orchestration
├── main.bicepparam               # Parameters
├── modules/
│   ├── network.bicep             # Phase 1
│   ├── nsg.bicep                 # Phase 1
│   ├── private-dns.bicep         # Phase 2-3
│   ├── key-vault.bicep           # Phase 2
│   ├── sql.bicep                 # Phase 2
│   ├── redis.bicep               # Phase 2
│   ├── app-service-plan.bicep    # Phase 2
│   ├── cognitive-search.bicep    # Phase 3
│   ├── service-bus.bicep         # Phase 3
│   ├── app-service.bicep         # Phase 3
│   ├── functions.bicep           # Phase 3
│   ├── rbac.bicep                # Phase 3
│   ├── log-analytics.bicep       # Phase 4
│   ├── app-insights.bicep        # Phase 4
│   ├── waf-policy.bicep          # Phase 4
│   ├── front-door.bicep          # Phase 4
│   ├── static-web-app.bicep      # Phase 4
│   └── diagnostics.bicep         # Phase 4
├── deploy.ps1                    # Deployment script
└── README.md                     # Documentation
```

---

## Validation Commands

After each phase, validate the Bicep code:

```bash
# Build (checks syntax and references)
bicep build infra/bicep/ecommerce/main.bicep

# Lint (checks best practices)
bicep lint infra/bicep/ecommerce/main.bicep

# What-if deployment (preview changes)
az deployment group what-if \
  --resource-group rg-ecommerce-prod-swc \
  --template-file infra/bicep/ecommerce/main.bicep \
  --parameters infra/bicep/ecommerce/main.bicepparam
```

---

## ➡️ Next Step

Reply with **"Phase 1"** to start generating the foundation Bicep code.
