# Agent Testing Framework - Workload Documentation

> **Status**: ✅ Complete | **Step**: 7 of 7 (docs)
>
> Comprehensive workload documentation for the Agent Testing Framework.

---

## 1. Document Package Contents

| Document                                               | Description                  | Status      |
| ------------------------------------------------------ | ---------------------------- | ----------- |
| [07-documentation-index.md](07-documentation-index.md) | Master index (this file)     | ✅ Complete |
| [07-resource-inventory.md](07-resource-inventory.md)   | As-built resource listing    | ✅ Complete |
| [07-operations-runbook.md](07-operations-runbook.md)   | Day-2 operational procedures | ✅ Complete |
| [07-backup-dr-plan.md](07-backup-dr-plan.md)           | Disaster recovery procedures | ✅ Complete |
| [07-ab-cost-estimate.md](07-ab-cost-estimate.md)       | As-built cost analysis       | ✅ Complete |

---

## 2. Source Artifacts

These documents were generated from the following agentic workflow outputs:

| Artifact            | Source                             | Generated  |
| ------------------- | ---------------------------------- | ---------- |
| Requirements        | 01-requirements.md                 | 2026-01-22 |
| WAF Assessment      | 02-architecture-assessment.md      | 2026-01-22 |
| Cost Estimate       | 03-des-cost-estimate.md            | 2026-01-22 |
| Implementation Plan | 04-implementation-plan.md          | 2026-01-22 |
| Bicep Code          | infra/bicep/agent-testing/         | 2026-01-22 |

---

## 3. Project Summary

| Attribute          | Value                                        |
| ------------------ | -------------------------------------------- |
| **Project Name**   | Agent Testing Framework                      |
| **Environment**    | Test                                         |
| **Primary Region** | swedencentral                                |
| **Compliance**     | N/A (test infrastructure)                    |
| **Monthly Cost**   | ~$45-55                                      |

---

## 4. Related Resources

- **Infrastructure Code**: [`infra/bicep/agent-testing/`](../../infra/bicep/agent-testing/)
- **Agent Outputs**: [`agent-output/agent-testing/`](./)
- **ADRs**: [03-des-adr-0001-ephemeral-test-infrastructure.md](03-des-adr-0001-ephemeral-test-infrastructure.md)

---

## 5. Quick Links

- [Deployment Script](../../infra/bicep/agent-testing/deploy.ps1)
- [Main Bicep Template](../../infra/bicep/agent-testing/main.bicep)
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                        Agent Testing Framework                                │
│                        Resource Group: rg-agenttest-test-swc                  │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────┐  ┌─────────────────────────────────────────────────┐   │
│  │  Scenario 1     │  │  Scenario 2: Multi-tier                         │   │
│  │  Static Web App │  │  ┌─────────────┐  ┌───────────┐  ┌──────────┐  │   │
│  │  (westeurope)   │  │  │ App Service │→ │ SQL Server│  │ Key Vault│  │   │
│  │  Free tier      │  │  │    B1       │  │   Basic   │  │ Standard │  │   │
│  └─────────────────┘  │  └─────────────┘  └───────────┘  └──────────┘  │   │
│                       └─────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │  Scenario 3: Microservices                                            │   │
│  │  ┌────────────────────┐  ┌─────────────┐  ┌──────────────────────┐   │   │
│  │  │ Container Apps Env │  │ Service Bus │  │ Storage Account      │   │   │
│  │  │   Consumption      │  │   Basic     │  │   Standard_LRS       │   │   │
│  │  └────────────────────┘  └─────────────┘  └──────────────────────┘   │   │
│  │  ┌────────────────────┐  ┌─────────────┐                             │   │
│  │  │ Log Analytics      │  │ Key Vault   │                             │   │
│  │  │   PerGB2018        │  │  Standard   │                             │   │
│  │  └────────────────────┘  └─────────────┘                             │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

### Endpoints

| Resource       | URL                                                         |
| -------------- | ----------------------------------------------------------- |
| Static Web App | https://polite-grass-0413f0403.2.azurestaticapps.net        |
| App Service    | https://app-test-agent-testing-swc-chw5en.azurewebsites.net |
| SQL Server     | sql-test-agent-testing-swc-chw5en.database.windows.net      |
| Container Apps | happysky-0bc10407.swedencentral.azurecontainerapps.io       |

---

_Documentation index generated by Workload Documentation Generator._
