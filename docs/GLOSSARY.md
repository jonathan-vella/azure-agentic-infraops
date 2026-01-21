# Glossary

> **Version 5.3.0** | Quick reference for terms used throughout Agentic InfraOps documentation.

---

## A

### ADR (Architecture Decision Record)

A document that captures an important architectural decision along with its context and consequences.
Used to record "why" decisions were made for future reference.

📁 **See**: [docs/_superseded/adr/](_superseded/adr/)

### Agentic InfraOps

The methodology of using coordinated AI agents to transform requirements into deploy-ready Azure
infrastructure. Combines GitHub Copilot with custom agents for structured workflow.

### AVM (Azure Verified Modules)

Microsoft's official library of pre-built, tested Bicep modules that follow Azure best
practices. Using AVM modules ensures policy compliance and reduces custom code.

📁 **See**: [ADR-003 AVM-First Approach](_superseded/adr/ADR-003-avm-first-approach.md)

🔗 **External**: [Azure Verified Modules Registry](https://aka.ms/avm)

---

## B

### Bicep

Azure's domain-specific language (DSL) for deploying Azure resources declaratively. Compiles to ARM
templates but with cleaner syntax and better tooling support.

🔗 **External**: [Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)

### Bicep Lint

Static analysis tool that checks Bicep files for best practices, security issues, and common mistakes.
Run with `bicep lint main.bicep` or automatically via VS Code extension.

---

## C

### Copilot Chat

The conversational interface for GitHub Copilot in VS Code. Accessed via `Ctrl+Alt+I`. Supports
custom agents via the agent picker dropdown.

### Custom Agent

A specialized AI assistant defined in `.github/agents/` that focuses on specific tasks. Examples:
`azure-principal-architect`, `bicep-plan`, `bicep-implement`.

📁 **See**: [.github/agents/](../.github/agents/)

---

## D

### Dev Container

A Docker-based development environment defined in `.devcontainer/`. Provides consistent tooling
(Azure CLI, Bicep, PowerShell) across all machines.

🔗 **External**: [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)

---

## H

### HIPAA (Health Insurance Portability and Accountability Act)

US regulation governing protected health information (PHI). Azure provides HIPAA-compliant services
when properly configured. S03 scenario demonstrates HIPAA-compliant architecture.

### Hub-Spoke Network

Azure networking pattern where a central "hub" VNet contains shared services (firewall, VPN gateway)
and "spoke" VNets contain workloads. Spokes peer with the hub for connectivity.

---

## I

### IaC (Infrastructure as Code)

Practice of managing infrastructure through code files (Bicep, ARM) rather than manual
portal clicks. Enables version control, automation, and repeatability.

---

## K

### KQL (Kusto Query Language)

Query language used in Azure Monitor, Log Analytics, and Application Insights. Used for
troubleshooting and diagnostics (see S07 Troubleshooting scenario).

🔗 **External**: [KQL Reference](https://learn.microsoft.com/azure/data-explorer/kusto/query/)

---

## M

### MCP (Model Context Protocol)

Protocol for extending AI assistants with external tools and data sources. The Azure Pricing MCP
server provides real-time Azure pricing to Copilot.

📁 **See**: [mcp/azure-pricing-mcp/](../mcp/azure-pricing-mcp/)

### MTTR (Mean Time To Recovery)

Average time to restore service after an incident. Key SRE metric. Copilot-assisted troubleshooting
reduces MTTR by 73-85% (see Time Savings Evidence).

---

## N

### NSG (Network Security Group)

Azure resource that filters network traffic with allow/deny rules. Applied to subnets or NICs.
Essential for microsegmentation and defense-in-depth.

---

## P

### PCI-DSS (Payment Card Industry Data Security Standard)

Security standard for organizations handling credit card data. S04 E-Commerce scenario demonstrates
PCI-DSS compliant architecture patterns.

### Private Endpoint

Azure feature that assigns a private IP address to a PaaS service (Storage, SQL, Key Vault),
removing public internet exposure. Essential for zero-trust architectures.

---

## S

### SBOM (Software Bill of Materials)

Inventory of all software components in an application, including dependencies and versions.
Required for supply chain security. S08 scenario demonstrates SBOM generation.

### SI Partner (System Integrator Partner)

Microsoft partner organization that implements Azure solutions for customers. Primary audience
for Agentic InfraOps methodology.

---

## T

### Tags (Azure Resource Tags)

Key-value pairs applied to Azure resources for organization, cost tracking, and policy enforcement.
Required tags in this project: Environment, ManagedBy, Project, Owner.

---

## U

### UAT (User Acceptance Testing)

Final testing phase where end users verify the system meets business requirements. S06 scenario
demonstrates automated UAT validation.

---

## W

### WAF (Well-Architected Framework)

Microsoft's guidance for building reliable, secure, efficient Azure workloads. Five pillars:
Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency.

🔗 **External**: [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)

### What-If Deployment

Azure deployment preview that shows what resources will be created, modified, or deleted without
making actual changes. Run with `az deployment group create --what-if`.

---

## Numbers & Symbols

### 7-Step Agentic Workflow

The core Agentic InfraOps workflow: `project-planner` → `azure-principal-architect` → Design Artifacts →
`bicep-plan` → `bicep-implement` → Deploy → As-Built Artifacts. Each step has an approval gate before proceeding.
Steps 3 (Design Artifacts) and 7 (As-Built Artifacts) are optional for generating diagrams and ADRs.

📁 **See**: [Workflow Guide](reference/workflow.md)

### Project Planner

Custom agent for Azure infrastructure requirements gathering. Starting point for the 7-step workflow.
Gathers requirements and creates implementation plans. Defined in `project-planner.agent.md`.

> **Note**: VS Code includes a built-in "Plan" agent for general planning. This repository uses
> the custom **Project Planner** agent with Azure-specific instructions and workflow handoffs.

🔗 **External**: [VS Code Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

---

## Quick Reference Table

| Acronym | Full Name                                    | Category       |
| ------- | -------------------------------------------- | -------------- |
| ADR     | Architecture Decision Record                 | Documentation  |
| AVM     | Azure Verified Modules                       | IaC            |
| IaC     | Infrastructure as Code                       | Methodology    |
| KQL     | Kusto Query Language                         | Monitoring     |
| MCP     | Model Context Protocol                       | AI Integration |
| MTTR    | Mean Time To Recovery                        | Operations     |
| NSG     | Network Security Group                       | Networking     |
| PCI-DSS | Payment Card Industry Data Security Standard | Compliance     |
| SBOM    | Software Bill of Materials                   | Security       |
| UAT     | User Acceptance Testing                      | QA             |
| WAF     | Well-Architected Framework                   | Architecture   |

---

_Missing a term? [Open an issue](https://github.com/jonathan-vella/azure-agentic-infraops/issues) or add it via PR._
