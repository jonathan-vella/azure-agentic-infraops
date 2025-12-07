# Scenarios Overview

> **Version 3.1.0** | Last Updated: December 3, 2025
>
> **Hands-on learning scenarios demonstrating Agentic InfraOps as an efficiency multiplier for IT Professionals.**

---

## Defaults & Workflow

> **Region**: `swedencentral` (fallback: `germanywestcentral`). See [ADR-004](../docs/adr/ADR-004-region-defaults.md).
>
> **Modules**: AVM-first for policy-compliant deployments. See [ADR-003](../docs/adr/ADR-003-avm-first-approach.md).
>
> **Agent Workflow**: `@plan` → `azure-principal-architect` → `bicep-plan` → `bicep-implement`. See
> [Workflow Guide](../docs/workflow/WORKFLOW.md).

---

## Quick Start

| If you're...                     | Start with                                              |
| -------------------------------- | ------------------------------------------------------- |
| **New to Copilot**               | [S01 Bicep Baseline](#s01-bicep-baseline)               |
| **Want a quick demo**            | [S11 Quick Demos](S11-quick-demos/) - 15-30 min prompts |
| **Experienced with IaC**         | [S03 Five-Agent Workflow](#s03-five-agent-workflow)     |
| **Full workflow demo**           | [S04 E-Commerce Platform](#s04-e-commerce-platform)     |
| **Focused on Terraform**         | [S02 Terraform Baseline](#s02-terraform-baseline)       |
| **Looking for async automation** | [S10 Coding Agent](#s10-coding-agent)                   |

---

## Quick Demos

For simple, single-prompt scenarios, see the [S11 Quick Demos](S11-quick-demos/) folder:

| Demo                                                       | Complexity      | Time   | Description                           |
| ---------------------------------------------------------- | --------------- | ------ | ------------------------------------- |
| [E-Commerce Prompts](S11-quick-demos/ecommerce-prompts.md) | 🟡 Intermediate | 30 min | PCI-DSS compliant multi-tier platform |
| [Healthcare Portal](S11-quick-demos/healthcare-demo.md)    | 🔴 Advanced     | 30 min | HIPAA-compliant patient portal        |
| [Analytics Platform](S11-quick-demos/analytics-demo.md)    | 🟡 Intermediate | 30 min | Data analytics with Synapse           |
| [Static Website](S11-quick-demos/static-site-demo.md)      | 🟢 Beginner     | 15 min | Simple static web app                 |

---

## Scenario Index

| #   | Scenario                                                  | Character       | Challenge                              | Time      | Difficulty   |
| --- | --------------------------------------------------------- | --------------- | -------------------------------------- | --------- | ------------ |
| S01 | [Bicep Baseline](#s01-bicep-baseline)                     | Elena Rodriguez | Build secure Azure network foundation  | 30 min    | Beginner     |
| S02 | [Terraform Baseline](#s02-terraform-baseline)             | Jordan Martinez | Multi-cloud IaC with Terraform         | 30 min    | Beginner     |
| S03 | [Five-Agent Workflow](#s03-five-agent-workflow)           | —               | End-to-end infrastructure design       | 45-60 min | Advanced     |
| S04 | [E-Commerce Platform](#s04-e-commerce-platform)           | —               | PCI-DSS compliant retail platform      | 60-90 min | Advanced     |
| S05 | [Documentation Generation](#s05-documentation-generation) | Priya Sharma    | Auto-generate docs from code           | 90 min    | Intermediate |
| S06 | [Service Validation](#s06-service-validation)             | Marcus Chen     | Automated UAT and load testing         | 30 min    | Intermediate |
| S07 | [Troubleshooting](#s07-troubleshooting)                   | Maya Patel      | Diagnose infrastructure issues         | 25 min    | Intermediate |
| S08 | [SBOM Generator](#s08-sbom-generator)                     | Sarah Chen      | Software Bill of Materials             | 75 min    | Intermediate |
| S09 | [Diagrams as Code](#s09-diagrams-as-code)                 | David Kim       | Python-generated architecture diagrams | 20 min    | Beginner     |
| S10 | [Coding Agent](#s10-coding-agent)                         | Alex Petrov     | Async implementation via GitHub Issues | 30 min    | Advanced     |
| S11 | [Quick Demos](#s11-quick-demos)                           | —               | Single-prompt scenarios                | 15-30 min | Varies       |

---

## Scenario Details

### S01: Bicep Baseline

**[📁 View Scenario](S01-bicep-baseline/)**

> **Character**: Elena Rodriguez — Cloud Infrastructure Engineer with 10 years VMware experience, first Azure project

**Challenge**: Build a secure hub-spoke network foundation in 2 weeks with security requirements she's still learning.

**What You'll Learn**:

- Bicep fundamentals and Azure resource model
- Virtual Network concepts (mapped from VMware knowledge)
- Network Security Groups for microsegmentation
- Storage account security and private endpoints
- Module organization and parameter files

**Key Insight**: Copilot as a **learning partner** that maps existing skills to new platforms.

---

### S02: Terraform Baseline

**[📁 View Scenario](S02-terraform-baseline/)**

> **Character**: Jordan Martinez — Senior Infrastructure Engineer with multi-cloud responsibilities

**Challenge**: Same hub-spoke topology as S01, but using Terraform for multi-cloud consistency.

**What You'll Learn**:

- HCL syntax and Terraform Azure Provider
- State management with Azure Storage backend
- Module patterns for reusable infrastructure
- Security scanning with tfsec and Checkov

**Key Insight**: Copilot accelerates Terraform development while maintaining multi-cloud portability.

---

### S03: Five-Agent Workflow

**[📁 View Scenario](S03-five-agent-workflow/)**

> **Production Example**: [`infra/bicep/contoso-patient-portal/`](../infra/bicep/contoso-patient-portal/) —
> 1,070 lines of Bicep, 10 modules

**Challenge**: Design and implement a HIPAA-compliant patient portal for Contoso Healthcare.

**The Five Agents**:

```mermaid
%%{init: {'theme':'neutral'}}%%
flowchart LR
    A["@plan<br/>Strategic Planning"] --> B["ADR Generator<br/>Decision Docs"]
    B --> C["Azure Architect<br/>WAF Assessment"]
    C --> D["Bicep Planner<br/>Module Design"]
    D --> E["Bicep Implement<br/>Code Generation"]

    style A fill:#e3f2fd,stroke:#1976d2
    style B fill:#f3e5f5,stroke:#7b1fa2
    style C fill:#e8f5e9,stroke:#388e3c
    style D fill:#fff3e0,stroke:#f57c00
    style E fill:#fce4ec,stroke:#c2185b
```

| Agent                       | Type     | Purpose                                |
| --------------------------- | -------- | -------------------------------------- |
| `@plan`                     | Built-in | Strategic planning with cost estimates |
| `adr_generator`             | Custom   | Document architectural decisions       |
| `azure-principal-architect` | Custom   | Azure WAF assessment                   |
| `bicep-plan`                | Custom   | Infrastructure module design           |
| `bicep-implement`           | Custom   | Generate production-ready Bicep        |

> **Note:** The Plan Agent (`@plan`) is a **built-in VS Code feature**—see [VS Code docs](https://code.visualstudio.com/docs/copilot/chat/chat-planning).
> The other four agents are custom agents defined in `.github/agents/`.

**Time Comparison**:

| Approach                 | Duration       |
| ------------------------ | -------------- |
| Traditional manual       | 18+ hours      |
| With Five-Agent Workflow | **45 minutes** |

**Key Insight**: Structured agent handoffs preserve context and produce near-production-ready code.

---

### S04: E-Commerce Platform

**[📁 View Scenario](S04-ecommerce-platform/)**

> **Production Example**: [`infra/bicep/ecommerce/`](../infra/bicep/ecommerce/) — Multi-tier retail platform
> with PCI-DSS compliance

**Challenge**: Design and deploy a production-ready e-commerce platform with payment processing requirements.

**The Complete Workflow**:

```mermaid
%%{init: {'theme':'neutral'}}%%
flowchart LR
    A["@plan<br/>Requirements"] --> B["Azure Architect<br/>WAF Assessment"]
    B --> C["Pricing MCP<br/>Cost Analysis"]
    C --> D["Diagram Gen<br/>Architecture"]
    D --> E["Bicep Planner<br/>Module Design"]
    E --> F["Bicep Implement<br/>Code Generation"]

    style A fill:#e3f2fd,stroke:#1976d2
    style B fill:#e8f5e9,stroke:#388e3c
    style C fill:#fff9c4,stroke:#f9a825
    style D fill:#f3e5f5,stroke:#7b1fa2
    style E fill:#fff3e0,stroke:#f57c00
    style F fill:#fce4ec,stroke:#c2185b
```

| Agent/Tool                  | Type     | Purpose                         |
| --------------------------- | -------- | ------------------------------- |
| `@plan`                     | Built-in | Strategic requirements planning |
| `azure-principal-architect` | Custom   | Azure WAF & PCI-DSS assessment  |
| Azure Pricing MCP           | MCP      | Real-time cost estimation       |
| `diagram-generator`         | Custom   | Python architecture diagrams    |
| `bicep-plan`                | Custom   | Infrastructure module design    |
| `bicep-implement`           | Custom   | Generate production-ready Bicep |

**Time Comparison**:

| Approach              | Duration       |
| --------------------- | -------------- |
| Traditional manual    | 24+ hours      |
| With Agentic Workflow | **60 minutes** |

**Key Insight**: Complete workflow demonstration from requirements to deployed infrastructure with real-time pricing.

---

### S05: Documentation Generation

**[📁 View Scenario](S05-documentation-generation/)**

> **Character**: Priya Sharma — Senior Technical Writer needing to document 50-server migration in 1 week

**Challenge**: Transform Azure resource data into professional documentation using conversation patterns.

**What You'll Learn**:

- Resource Graph patterns for documentation
- Data-to-documentation flow
- Mermaid diagrams from code
- The 90/10 rule (what to automate vs. human judgment)

**Key Insight**: Documentation as a **conversation-driven** byproduct, not a separate task.

---

### S06: Service Validation

**[📁 View Scenario](S06-service-validation/)**

> **Character**: Marcus Chen — Senior QA Engineer at ValidationFirst Consulting

**Challenge**: Validate Azure infrastructure meets requirements through automated UAT and load testing.

**What You'll Learn**:

- PowerShell validation scripts with Pester
- Load testing with Azure Load Testing
- Automated test evidence collection
- Pre-deployment validation patterns

**Key Insight**: Catch issues **before** they reach production.

---

### S07: Troubleshooting

**[📁 View Scenario](S07-troubleshooting/)**

> **Character**: Maya Patel — On-Call SRE at RetailMax with 2 AM production incident

**Challenge**: Diagnose and fix checkout failures under time pressure before Black Friday.

**What You'll Learn**:

- AI-assisted log analysis with KQL
- Azure Monitor and Log Analytics queries
- Root cause identification patterns
- Systematic debugging with Copilot

**Key Insight**: Better **questions** lead to faster diagnosis, not just faster queries.

---

### S08: SBOM Generator

**[📁 View Scenario](S08-sbom-generator/)**

> **Character**: Sarah Chen — Security Engineer with 48-hour deadline for customer SBOM request

**Challenge**: Create comprehensive Software Bill of Materials for compliance without prior SBOM experience.

**What You'll Learn**:

- SBOM fundamentals and CycloneDX format
- Component discovery across application, container, and infrastructure layers
- License compliance analysis
- Validation techniques for SBOM completeness

**Key Insight**: Learn **how** to create SBOMs through conversation, not just get output.

---

### S09: Diagrams as Code

**[📁 View Scenario](S09-diagrams-as-code/)**

> **Character**: David Kim — Solutions Architect with design review in 2 hours

**Challenge**: Create version-controlled Azure architecture diagrams without prior diagrams-as-code experience.

**What You'll Learn**:

- Python Diagrams library for Azure
- Architecture visualization patterns
- Diagram automation in CI/CD
- Consistent visual language

**Key Insight**: Diagrams that **never go stale** because they're generated from code.

---

### S10: Coding Agent

**[📁 View Scenario](S10-coding-agent/)**

> **Character**: Alex Petrov — Cloud Operations Engineer with 24 hours to add monitoring before go-live

**Challenge**: Implement monitoring infrastructure while handling other priorities.

**What You'll Learn**:

- GitHub Issue → Copilot assignment
- Autonomous codebase analysis
- Pull Request review workflow
- Async development patterns

**⚠️ Requirements**: GitHub Copilot Business/Enterprise with Coding Agent enabled

**Key Insight**: Delegate implementation to Copilot, focus on review and approval.

---

### S11: Quick Demos

**[📁 View Scenario](S11-quick-demos/)**

**Challenge**: Quick single-prompt demonstrations for time-constrained presentations.

**Available Demos**:

| Demo               | Complexity      | Time   | Description                           |
| ------------------ | --------------- | ------ | ------------------------------------- |
| E-Commerce Prompts | 🟡 Intermediate | 30 min | PCI-DSS compliant multi-tier platform |
| Healthcare Portal  | 🔴 Advanced     | 30 min | HIPAA-compliant patient portal        |
| Analytics Platform | 🟡 Intermediate | 30 min | Data analytics with Synapse           |
| Static Website     | 🟢 Beginner     | 15 min | Simple static web app                 |

**Key Insight**: Proof-of-value demos that fit any meeting schedule.

---

## Scenario Structure

Each scenario follows a consistent structure:

```
scenarios/SXX-scenario-name/
├── README.md              # Overview, character, learning objectives
├── DEMO-SCRIPT.md         # Step-by-step walkthrough with 🎓 Learning Moments
├── solution/              # Reference implementation
│   └── README.md          # Solution explanation
├── examples/              # Conversation transcripts
│   └── copilot-conversation.md
├── prompts/               # Effective prompts for this scenario
│   └── effective-prompts.md
└── validation/            # Post-completion validation
    └── validate.ps1
```

---

## Learning Paths

### Path 1: IaC Fundamentals (2 hours)

```
S01 Bicep Baseline → S05 Documentation → S06 Validation
```

Best for: IT Pros new to Infrastructure as Code

### Path 2: Advanced Workflow (4 hours)

```
S03 Five-Agent Workflow → S04 E-Commerce Platform → S09 Diagrams as Code
```

Best for: Architects and senior engineers

### Path 3: Multi-Cloud (2 hours)

```
S01 Bicep Baseline → S02 Terraform Baseline → Compare approaches
```

Best for: Teams evaluating IaC tools

### Path 4: Operations Focus (2 hours)

```
S06 Service Validation → S07 Troubleshooting → S08 SBOM Generator
```

Best for: DevOps and platform engineers

### Path 5: Complete Demo (3 hours)

```
S04 E-Commerce Platform → S09 Diagrams as Code → S10 Coding Agent
```

Best for: Live demonstrations and workshops

---

## Time Savings Summary

For detailed methodology and research sources, see
[Time Savings Evidence](../docs/value-proposition/time-savings-evidence.md).

| Scenario                | Traditional | With Copilot | Savings |
| ----------------------- | ----------- | ------------ | ------- |
| S01 Bicep Baseline      | 4-6 hours   | 30 min       | 87-92%  |
| S02 Terraform Baseline  | 4-6 hours   | 30 min       | 87-92%  |
| S03 Five-Agent Workflow | 18+ hours   | 45 min       | 96%     |
| S04 E-Commerce Platform | 24+ hours   | 60 min       | 96%     |
| S05 Documentation Gen   | 20+ hours   | 90 min       | 93%     |
| S06 Service Validation  | 4-6 hours   | 30 min       | 87-92%  |
| S07 Troubleshooting     | 30 hours    | 5 hours      | 83%     |
| S08 SBOM Generator      | 6 hours     | 75 min       | 79%     |
| S09 Diagrams as Code    | 45 min      | 20 min       | 56%     |
| S10 Coding Agent        | 8+ hours    | 30 min       | 94%     |

---

## Contributing

Want to add a new scenario? See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

Each scenario should:

- Feature a relatable IT Pro character with a real challenge
- Include discovery-based learning (not just script generation)
- Provide measurable time savings
- Include validation scripts

---

## Document Info

|                |                             |
| -------------- | --------------------------- |
| **Created**    | November 2025               |
| **Updated**    | December 2025               |
| **Scenarios**  | 11 (S01-S11)                |
| **Total Time** | ~8-10 hours (all scenarios) |
| **Maintainer** | Repository maintainers      |
