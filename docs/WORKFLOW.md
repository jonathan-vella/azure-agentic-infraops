# Azure Infrastructure Agent Workflow

> **Version 2.1.0** | Last Updated: December 3, 2025

This document describes the 4-step agent workflow for Azure infrastructure development in this repository.

---

## Overview

```mermaid
%%{init: {'theme':'neutral'}}%%
graph TB
    subgraph "Step 1: Requirements"
        P["@plan<br/>(built-in)"]
    end

    subgraph "Step 2: Architecture"
        A["azure-principal-architect<br/>(NO CODE)"]
        subgraph "Optional During Architecture"
            MCP["💰 Azure Pricing MCP<br/>(real-time costs)"]
            D["📊 diagram-generator<br/>(visualization)"]
            ADR1["📝 adr-generator<br/>(decisions)"]
        end
    end

    subgraph "Step 3: Planning"
        B["bicep-plan<br/>(plan only)"]
    end

    subgraph "Step 4: Implementation"
        I["bicep-implement<br/>(code generation)"]
        subgraph "Optional After Implementation"
            ADR2["📝 adr-generator"]
        end
    end

    P -->|"requirements"| A
    A -->|"architecture"| B
    B -->|"plan"| I

    MCP -.->|"pricing data"| A
    D -.->|"diagrams"| A
    ADR1 -.->|"decisions"| A
    MCP -.->|"cost validation"| B
    ADR2 -.->|"decisions"| I

    style P fill:#e1f5fe
    style A fill:#fff3e0
    style MCP fill:#fff9c4
    style D fill:#f3e5f5
    style ADR1 fill:#e8eaf6
    style B fill:#e8f5e9
    style I fill:#fce4ec
    style ADR2 fill:#e8eaf6
```

## Workflow Steps

| Step | Agent                       | Purpose                  | Creates                      | Approval Required |
| ---- | --------------------------- | ------------------------ | ---------------------------- | ----------------- |
| 1    | `@plan` (built-in)          | Gather requirements      | Requirements plan            | ✅ Yes            |
| 2    | `azure-principal-architect` | WAF assessment & pricing | Architecture recommendations | ✅ Yes            |
| 3    | `bicep-plan`                | Implementation planning  | `INFRA.md` plan file         | ✅ Yes            |
| 4    | `bicep-implement`           | Code generation          | Bicep templates              | ✅ Yes            |

### Optional Integrations (During Step 2)

| Tool/Agent             | When to Use                       | Triggered By                        |
| ---------------------- | --------------------------------- | ----------------------------------- |
| 💰 Azure Pricing MCP   | Get real-time Azure pricing       | Automatic during architecture phase |
| 📊 `diagram-generator` | Create architecture visualization | Ask: "generate diagram"             |
| 📝 `adr-generator`     | Document key decisions            | Ask: "create ADR for this decision" |

---

## 💰 Azure Pricing MCP Integration

The Azure Pricing MCP Server provides **real-time cost data** to agents during infrastructure planning. This eliminates guesswork and ensures accurate cost estimates.

### Available Tools

| Tool                     | Purpose                                | Used By               |
| ------------------------ | -------------------------------------- | --------------------- |
| `azure_price_search`     | Query Azure retail prices with filters | architect, bicep-plan |
| `azure_price_compare`    | Compare prices across regions/SKUs     | architect             |
| `azure_cost_estimate`    | Calculate monthly/yearly costs         | architect, bicep-plan |
| `azure_region_recommend` | Find cheapest Azure regions for a SKU  | architect             |
| `azure_discover_skus`    | List available SKUs for a service      | architect, bicep-plan |
| `azure_sku_discovery`    | Fuzzy SKU name matching                | architect             |

### How It Works

```mermaid
%%{init: {'theme':'neutral'}}%%
sequenceDiagram
    participant User
    participant Architect as azure-principal-architect
    participant MCP as Azure Pricing MCP
    participant Azure as Azure Retail Prices API

    User->>Architect: "Recommend App Service SKU"
    Architect->>MCP: azure_discover_skus("App Service")
    MCP->>Azure: GET /api/retail/prices?serviceName=...
    Azure-->>MCP: [P1v4: $0.282/hr, P2v4: $0.564/hr, ...]
    MCP-->>Architect: SKU options with prices
    Architect-->>User: "P1v4 recommended: $206/mo"
```

### Setup

The MCP server is **automatically configured** when you open the Dev Container. Manual setup:

```bash
cd mcp/azure-pricing-mcp
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Configuration

Pre-configured in `.vscode/mcp.json`:

```json
{
  "servers": {
    "azure-pricing": {
      "type": "stdio",
      "command": "${workspaceFolder}/mcp/azure-pricing-mcp/.venv/bin/python",
      "args": ["-m", "azure_pricing_mcp"],
      "cwd": "${workspaceFolder}/mcp/azure-pricing-mcp/src"
    }
  }
}
```

### Creating Cost Documentation

During the architecture phase, ask:

- **"save costs"** - Creates `docs/{project}-cost-estimate.md`
- **"save"** - Creates `docs/{project}-waf-assessment.md`

### Fallback

If MCP tools are unavailable, agents will recommend [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

---

## How to Use

### Starting the Workflow

1. Open GitHub Copilot Chat (`Ctrl+Alt+I`)
2. Click the **Agent** button or press `Ctrl+Shift+A`
3. Select `@plan` to start with requirements
4. Follow the agent handoffs through each step

### Approval Gates

Each step requires your explicit approval before proceeding:

| Response                   | Action                             |
| -------------------------- | ---------------------------------- |
| **"yes"** or **"approve"** | Continue to next step              |
| **Feedback text**          | Agent refines output               |
| **"no"**                   | Return to previous step or restart |

### Example Conversation Flow

```
You: @plan Create a HIPAA-compliant patient portal with Azure App Service and SQL Database

Plan Agent: [Generates requirements plan]
           Do you approve this plan?

You: yes

[Handoff to azure-principal-architect]

Architect: [Provides WAF assessment with scores]
           [Queries Azure Pricing MCP for real-time costs]

           💰 Cost Breakdown (via MCP):
           ┌─────────────────────────┬──────────────┐
           │ Resource                │ Monthly Cost │
           ├─────────────────────────┼──────────────┤
           │ App Service P1v4 (x2)   │ $412         │
           │ Azure SQL S3            │ $150         │
           │ Key Vault Standard      │ $3           │
           │ Log Analytics (5GB/day) │ $50          │
           └─────────────────────────┴──────────────┘
           Total: ~$615/month

           Do you approve? Want a diagram first?

You: yes generate the diagram

Architect: [Invokes diagram-generator]
           ✅ Created docs/diagrams/patient-portal/architecture.py
           ✅ Generated architecture.png

           Ready to continue to Bicep planning?

You: approve

[Handoff to bicep-plan]

Planner: [Creates implementation plan in .bicep-planning-files/]
         [Validates costs with Azure Pricing MCP]
         Do you approve this implementation plan?

You: yes

[Handoff to bicep-implement]

Implementer: [Generates Bicep templates]
             Validation: bicep build ✅ | bicep lint ✅
             Do you approve this implementation?

You: deploy

Implementer: [Executes deployment to Azure]
```

---

## Agent Responsibilities

### @plan (Built-in VS Code Feature)

- **Input**: Natural language requirements
- **Output**: Structured requirements plan
- **Limitations**: Cannot access workspace files

### azure-principal-architect

- **Input**: Requirements from @plan or user
- **Output**: WAF pillar assessment, SKU recommendations, cost estimates
- **Integrations**:
  - 💰 Uses Azure Pricing MCP for real-time costs
  - 📊 Can invoke diagram-generator for visualizations
  - 📝 Can invoke adr-generator for decisions
- **Limitations**: ❌ Cannot create or edit Bicep/Terraform code files
- **Documentation**: Can create `docs/{project}-waf-assessment.md` and `docs/{project}-cost-estimate.md`

### diagram-generator

- **Input**: Architecture context from azure-principal-architect
- **Output**: Python diagram file in `docs/diagrams/{goal}/` + PNG image
- **Triggered By**: User request during architecture phase ("generate diagram")
- **Library**: Uses Python `diagrams` library

### bicep-plan

- **Input**: Architecture assessment from azure-principal-architect
- **Output**: Implementation plan in `.bicep-planning-files/INFRA.{goal}.md`
- **Integrations**: 💰 Uses Azure Pricing MCP for SKU cost validation
- **Limitations**: ❌ Cannot create actual Bicep code
- **Focus**: Detailed planning with AVM modules

### bicep-implement

- **Input**: Implementation plan from `.bicep-planning-files/`
- **Output**: Bicep templates in `infra/bicep/{goal}/`
- **Limitations**: Must follow the approved plan
- **Validation**: Runs `bicep build` and `bicep lint`
- **Focus**: Code generation and deployment

### adr-generator (Optional)

- **Input**: Any architectural decision during the workflow
- **Output**: ADR in `docs/adr/`
- **When to Use**: Major technology choices, trade-off decisions, policy exceptions

---

## Alternative: Unified Agent

For simple infrastructure or quick iterations, use `infrastructure-specialist` which combines all steps into a single agent. This is useful for:

- Small projects (< 5 resources)
- Prototyping and experimentation
- Users familiar with Azure who don't need step-by-step guidance

---

## File Locations

| Artifact              | Location                                |
| --------------------- | --------------------------------------- |
| Implementation plans  | `.bicep-planning-files/INFRA.{goal}.md` |
| Bicep templates       | `infra/bicep/{goal}/`                   |
| Architecture diagrams | `docs/diagrams/{goal}/`                 |
| MCP diagrams          | `docs/diagrams/mcp/`                    |
| Cost estimates        | `docs/{project}-cost-estimate.md`       |
| WAF assessments       | `docs/{project}-waf-assessment.md`      |
| ADRs                  | `docs/adr/`                             |
| Agent definitions     | `.github/agents/`                       |
| MCP server            | `mcp/azure-pricing-mcp/`                |
| MCP configuration     | `.vscode/mcp.json`                      |

---

## Troubleshooting

### Agent Not Available

1. Press `Ctrl+Shift+A` to open agent picker
2. Verify agent files exist in `.github/agents/`
3. Restart VS Code if agents don't appear

### MCP Pricing Not Working

1. Check MCP server status: Command Palette → "MCP: List Servers"
2. Verify `azure-pricing` shows 6 tools
3. If not, run setup: `cd mcp/azure-pricing-mcp && pip install -r requirements.txt`
4. Restart VS Code

### Handoff Not Working

1. Look for the handoff button in chat response
2. If no button, manually switch agents with `Ctrl+Shift+A`
3. Copy relevant context to new agent conversation

### Validation Failures

| Error                 | Solution                            |
| --------------------- | ----------------------------------- |
| `bicep build` fails   | Check syntax errors in Bicep files  |
| `bicep lint` warnings | Address best practice violations    |
| Deployment fails      | Verify Azure permissions and quotas |

---

## Related Documentation

- [Demo Prompts](../demos/demo-prompts.md)
- [Copilot Instructions](../.github/copilot-instructions.md)
- [Azure Pricing MCP README](../mcp/azure-pricing-mcp/README.md)
- [README](../README.md)
