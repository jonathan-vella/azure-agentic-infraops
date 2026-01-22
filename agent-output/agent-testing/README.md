# Agent Testing - Workflow Outputs

> **Agent Validation Framework** - Complete 7-step workflow demonstrating all 9 Agentic InfraOps agents

**Created**: 2026-01-22  
**Last Updated**: 2026-01-22  
**Region**: Sweden Central (westeurope for Static Web App)  
**Resource Group**: rg-agenttest-test-swc

---

## Workflow Progress

- [x] Step 1: Requirements (`@requirements`)
- [x] Step 2: Architecture (`@architect`)
- [x] Step 3: Design Artifacts (`@diagram`, `@adr`)
- [x] Step 4: Planning (`@bicep-plan`)
- [x] Step 5: Implementation (`@bicep-code`)
- [x] Step 6: Deployment (`@deploy`)
- [x] Step 7: Documentation (`@docs`)
- [x] Step 8: Validation (`@diagnose`)

---

## Generated Artifacts

### Step 1: Requirements

| File                                       | Description                                       |
| ------------------------------------------ | ------------------------------------------------- |
| [01-requirements.md](./01-requirements.md) | 50+ test cases across 9 agents, 7 test categories |

### Step 2: Architecture

| File                                                             | Description                         |
| ---------------------------------------------------------------- | ----------------------------------- |
| [02-architecture-assessment.md](./02-architecture-assessment.md) | WAF pillar scores, design decisions |

### Step 3: Design Artifacts

| File                                                                                                   | Description                                    |
| ------------------------------------------------------------------------------------------------------ | ---------------------------------------------- |
| [03-des-diagram.py](./03-des-diagram.py)                                                               | Architecture diagram source (Diagrams library) |
| [03-des-diagram.png](./03-des-diagram.png)                                                             | Architecture diagram image                     |
| [03-des-cost-estimate.md](./03-des-cost-estimate.md)                                                   | Design-phase cost estimate                     |
| [03-des-adr-0001-ephemeral-test-infrastructure.md](./03-des-adr-0001-ephemeral-test-infrastructure.md) | ADR: Ephemeral test infrastructure decision    |

### Step 4: Planning

| File                                                               | Description                           |
| ------------------------------------------------------------------ | ------------------------------------- |
| [04-implementation-plan.md](./04-implementation-plan.md)           | 12 resources, 10 Bicep modules        |
| [04-governance-constraints.md](./04-governance-constraints.md)     | Azure Policy constraints              |
| [04-governance-constraints.json](./04-governance-constraints.json) | Policy constraints (machine-readable) |

### Step 5: Implementation

| File                                                               | Description         |
| ------------------------------------------------------------------ | ------------------- |
| [05-implementation-reference.md](./05-implementation-reference.md) | Links to Bicep code |

**Bicep Code**: [`infra/bicep/agent-testing/`](../../infra/bicep/agent-testing/)

### Step 6: Deployment

| File                                                   | Description                    |
| ------------------------------------------------------ | ------------------------------ |
| [06-deployment-summary.md](./06-deployment-summary.md) | 16 resources deployed, outputs |

### Step 7: Documentation

| File                                                     | Description                               |
| -------------------------------------------------------- | ----------------------------------------- |
| [07-documentation-index.md](./07-documentation-index.md) | Master documentation index                |
| [07-resource-inventory.md](./07-resource-inventory.md)   | All 16 resources with SKUs, endpoints     |
| [07-operations-runbook.md](./07-operations-runbook.md)   | Health checks, scaling, incident response |
| [07-backup-dr-plan.md](./07-backup-dr-plan.md)           | RTO 15 min, IaC-based recovery            |
| [07-ab-cost-estimate.md](./07-ab-cost-estimate.md)       | As-built cost: ~$45-55/month              |

### Step 8: Validation

| File                                                           | Description                                          |
| -------------------------------------------------------------- | ---------------------------------------------------- |
| [08-resource-health-report.md](./08-resource-health-report.md) | Resource health, endpoint tests, security validation |

---

## Deployed Resources

16 Azure resources across multiple service types:

| Service                          | Resources | Purpose                          |
| -------------------------------- | --------- | -------------------------------- |
| Static Web App                   | 1         | Test `@diagram` scenario outputs |
| App Service + Plan               | 2         | Test container scenarios         |
| SQL Server + Database            | 2         | Test data tier patterns          |
| Container Apps Environment + App | 2         | Test serverless containers       |
| Key Vault                        | 2         | Test secrets management (S2, S3) |
| Storage Account                  | 1         | Test blob/file scenarios         |
| Service Bus                      | 1         | Test messaging patterns          |
| Log Analytics                    | 1         | Centralized logging              |
| Automation Account               | 1         | Cleanup automation               |

---

## Key Configurations

| Setting            | Value                           |
| ------------------ | ------------------------------- |
| SQL Authentication | Entra ID-only (no SQL auth)     |
| TLS Version        | 1.2 minimum                     |
| Public Blob Access | Disabled                        |
| Key Vault Auth     | RBAC authorization              |
| Container Apps     | Consumption tier, scale-to-zero |

---

## Cleanup

```bash
az group delete --name rg-agenttest-test-swc --yes --no-wait
```

---

## Related

- **Bicep Templates**: [infra/bicep/agent-testing/](../../infra/bicep/agent-testing/)
- **Workflow Guide**: [docs/reference/workflow.md](../../docs/reference/workflow.md)
- **Agent Definitions**: [.github/agents/](../../.github/agents/)
