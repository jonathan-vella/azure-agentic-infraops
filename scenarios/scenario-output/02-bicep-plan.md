# Step 3: Bicep Plan Agent

> **Agent Used:** `bicep-plan`  
> **Purpose:** Create detailed Bicep implementation plan with AVM modules

---

## 💬 Prompt

```text
Now create a Bicep implementation plan for the visualized architecture.
Use the diagram as reference for resource dependencies and relationships.
```

---

## ❌ Error Encountered

```
Sorry, the response hit the length limit. Please rephrase your prompt.
```

> ⚠️ **Issue:** Asking for a complete Bicep implementation plan for 10+ resources in one prompt generates too much content.

---

## 💬 Follow-up Prompt

```text
I'm running into this problem when using the attached as a prompt:
"Sorry, the response hit the length limit. Please rephrase your prompt"

Help me fix it.
```

---

## ✅ Solution: Split into Phases

The recommended approach is to break the implementation into phases matching the deployment timeline:

### Phase-by-Phase Prompts

| Phase       | Prompt                                                                                       | Resources   |
| ----------- | -------------------------------------------------------------------------------------------- | ----------- |
| **Phase 1** | "Create Bicep implementation plan for Phase 1 only: VNet, NSGs, subnets"                     | 5 resources |
| **Phase 2** | "Create Bicep implementation plan for Phase 2: Key Vault, SQL, Redis, App Service Plan"      | 8 resources |
| **Phase 3** | "Create Bicep implementation plan for Phase 3: App Service, Search, Service Bus, Functions"  | 7 resources |
| **Phase 4** | "Create Bicep implementation plan for Phase 4: Front Door, WAF, Log Analytics, App Insights" | 6 resources |

---

## Phase 1 Prompt — Foundation

```text
Create Bicep implementation plan for Phase 1 only:
- VNet with 3 subnets (web, data, integration)
- NSGs with segmentation rules
- Resource group structure

Region: swedencentral
```

---

## Phase 2 Prompt — Platform Services

```text
Create Bicep implementation plan for Phase 2:
- Key Vault with private endpoint
- App Service Plan P1v3 (zone redundant)
- Azure SQL with Azure AD-only auth
- Azure Cache for Redis with private endpoint
- Private DNS zones

Reference Phase 1 network outputs.
```

---

## Phase 3 Prompt — Application Tier

```text
Create Bicep implementation plan for Phase 3:
- App Service with VNet integration
- Cognitive Search with private endpoint
- Service Bus Premium with private endpoint
- Azure Functions EP1

Reference Phase 1-2 outputs.
```

---

## Phase 4 Prompt — Edge & Monitoring

```text
Create Bicep implementation plan for Phase 4:
- Azure Front Door with WAF
- Application Insights
- Log Analytics
- Static Web App
- Diagnostic settings for all resources
```

---

## Alternative: Simplified Outline

If you prefer a single prompt, reduce the scope:

```text
Create a **module structure outline** (not full implementation) for:
- E-commerce platform in swedencentral
- PCI-DSS compliant with private endpoints
- 3-tier network (web/data/integration subnets)

Output only:
1. File/folder structure
2. Module dependencies diagram
3. AVM modules to use (names only)
4. Parameter file structure

Skip: detailed resource configurations, full code examples
```

---

## Generated Plans

After using the phased approach, the following planning files were created:

| File                                        | Phase             | Resources                                    | Cost       |
| ------------------------------------------- | ----------------- | -------------------------------------------- | ---------- |
| `INFRA.ecommerce-phase1-foundation.md`      | Foundation        | VNet, NSGs, Subnets                          | $0         |
| `INFRA.ecommerce-phase2-platform.md`        | Platform          | Key Vault, SQL, Redis, ASP                   | ~$625/mo   |
| `INFRA.ecommerce-phase3-application.md`     | Application       | App Service, Search, Service Bus, Functions  | ~$1,107/mo |
| `INFRA.ecommerce-phase4-edge-monitoring.md` | Edge & Monitoring | Front Door, WAF, Log Analytics, App Insights | ~$94/mo    |

**Total: 26 resources, ~$1,826/month**

---

## ➡️ Next Step

Proceed to **`bicep-implement`** agent to generate the actual Bicep code, using the same phased approach.
