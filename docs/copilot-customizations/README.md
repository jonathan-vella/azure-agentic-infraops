# GitHub Copilot Customizations for IT Pros

> **Version 3.0.0** | Last Updated: December 3, 2025

This directory contains curated resources from the [github/awesome-copilot](https://github.com/github/awesome-copilot) repository, specifically selected to enhance your GitHub Copilot experience when working with Azure infrastructure and IT Pro scenarios.

## 🚀 Five-Agent Workflow

This repository uses **five GitHub Copilot agents** (including the built-in Plan agent) with automatic handoffs for Azure infrastructure development:

**Agents** (in `.github/agents/` + built-in):

| #   | Agent                                                       | Type             | Purpose                                         |
| --- | ----------------------------------------------------------- | ---------------- | ----------------------------------------------- |
| 0   | **Plan Agent** (`@plan`)                                    | Built-in VS Code | Create implementation plans with cost estimates |
| 1   | **ADR Generator** (`adr_generator`)                         | Custom           | Document architectural decisions                |
| 2   | **Azure Principal Architect** (`azure-principal-architect`) | Custom           | WAF assessment and guidance                     |
| 3   | **Bicep Planning Specialist** (`bicep-plan`)                | Custom           | Create machine-readable implementation plans    |
| 4   | **Bicep Implementation Specialist** (`bicep-implement`)     | Custom           | Generate near-production-ready Bicep code       |

> **Note:** The Plan Agent is a **built-in VS Code feature** that generates reusable `*.prompt.md` files.
> See [VS Code Plan Agent documentation](https://code.visualstudio.com/docs/copilot/chat/chat-planning) for details.

**Key Features**:

- ✅ **Automatic Handoffs**: Click buttons to switch agents with context
- ✅ **Machine-Readable Plans**: Structured YAML for deterministic code generation
- ✅ **near-production-ready Code**: Latest APIs, security best practices, validation
- ✅ **94% Time Savings**: 5.25 hours → 20 minutes for complete infrastructure

📖 **Complete Guide:** [FIVE-MODE-WORKFLOW.md](FIVE-MODE-WORKFLOW.md)  
🎬 **Demo Script:** [AGENT-HANDOFF-DEMO.md](AGENT-HANDOFF-DEMO.md) (15-20 minutes)

### How to Use Custom Agents

1. **Open Copilot Chat** (`Ctrl+Alt+I`)
2. **Click Agent button** (`Ctrl+Shift+A`) or use the Agent dropdown
3. **Select agent**: `adr_generator`, `azure-principal-architect`, `bicep-plan`, or `bicep-implement`
4. **Type prompt** and submit
5. **Click handoff buttons** to automatically switch agents with context

**Example**:

```text
(Using adr_generator agent)
Document the decision to use hub network topology.
Include rationale and alternatives.
```

→ Creates ADR → Click "Review Against WAF Pillars" → Automatically switches to `azure-principal-architect`

## 🎯 What's Included

These customizations provide Copilot with specialized knowledge about:

- **Infrastructure as Code**: Bicep and Terraform best practices for Azure
- **Automation**: PowerShell scripting and testing conventions
- **DevOps**: Core principles and DORA metrics
- **Azure Architecture**: Well-Architected Framework guidance
- **Documentation**: Diátaxis framework for technical writing

## 📁 Directory Structure

```text
copilot-customizations/
├── FIVE-MODE-WORKFLOW.md  # Complete five-agent workflow guide
├── instructions/          # Project-wide coding standards and conventions
│   ├── bicep-code-best-practices.instructions.md
│   ├── powershell-pester-5.instructions.md
│   ├── terraform-azure.instructions.md
│   └── devops-core-principles.instructions.md
├── chatmodes/            # Specialized AI personas for specific tasks
│   ├── README.md         # Chat mode usage guide and decision trees
│   ├── azure-principal-architect.chatmode.md (Five-Agent Workflow)
│   ├── bicep-plan.chatmode.md (Five-Agent Workflow)
│   ├── bicep-implement.chatmode.md (Five-Agent Workflow)
│   ├── azure-saas-architect.chatmode.md
│   ├── azure-verified-modules-bicep.chatmode.md
│   ├── azure-verified-modules-terraform.chatmode.md
│   ├── terraform-azure-planning.chatmode.md
│   ├── terraform-azure-implement.chatmode.md
│   ├── debug.chatmode.md
│   ├── plan.chatmode.md
│   └── planner.chatmode.md
├── prompts/              # Reusable task templates
│   ├── documentation-writer.prompt.md
│   └── azure-resource-health-diagnose.prompt.md
└── collections/          # Bundled resources by workflow
    └── azure-cloud-development.md
```

## 🚀 Quick Start

### Recommended: Use the Five-Agent Workflow

The most effective way to use GitHub Copilot for Azure infrastructure is through our structured five-agent workflow:

1. **Install Custom Agents** (if not already done)

   - ADR Generator is located in `.github/agents/adr-generator.agent.md`
   - Automatically available in VS Code GitHub Copilot

2. **Activate Chat Modes**

   - All 11 chat modes are in `chatmodes/` directory
   - Use `@workspace` in Copilot Chat to invoke workspace context
   - Reference modes: "Using azure-principal-architect mode..."

3. **Follow the Workflow**

   ```mermaid
   %%{init: {'theme':'neutral'}}%%
   graph LR
       P[@plan] --> A[ADR Generator]
       A --> B[Principal Architect]
       B --> C[Bicep Planning]
       C --> D[Bicep Implementation]
   ```

````

4. **Learn by Example**
   - See [FIVE-MODE-WORKFLOW.md](FIVE-MODE-WORKFLOW.md) for complete examples
   - See [chatmodes/README.md](chatmodes/README.md) for mode-specific guidance

### Option 1: Project-Wide Instructions (Recommended for This Repo)

Copy the instructions you want to use to `.github/copilot-instructions.md`:

```bash
# Navigate to repository root
cd /path/to/azure-agentic-infraops

# Create or append to project instructions
cat resources/copilot-customizations/instructions/bicep-code-best-practices.instructions.md >> .github/copilot-instructions.md
cat resources/copilot-customizations/instructions/devops-core-principles.instructions.md >> .github/copilot-instructions.md
````

This makes Copilot aware of these standards across the entire project.

### Option 2: File-Specific Instructions

For file-pattern-specific guidance, use the `applyTo` frontmatter in the instruction files. Example from `bicep-code-best-practices.instructions.md`:

```yaml
---
applyTo: "**/*.bicep"
---
```

### Option 3: Install Chat Modes in VS Code

Chat modes provide specialized AI personas. Install them directly in VS Code:

1. **Bicep Implementation Specialist**

   - Open VS Code
   - Open Copilot Chat
   - Install: Use the install badge in `chatmodes/bicep-implement.chatmode.md`
   - Or manually: Copy content to a new chat mode in VS Code

2. **Azure Principal Architect**

   - Expert guidance using Azure Well-Architected Framework
   - Install from `chatmodes/azure-principal-architect.chatmode.md`

3. **Terraform Azure Specialist**
   - IaC implementation for Terraform on Azure
   - Install from `chatmodes/terraform-azure-implement.chatmode.md`

### Option 4: Use Prompts as Slash Commands

Prompts are reusable task templates:

1. Open the prompt file (e.g., `prompts/documentation-writer.prompt.md`)
2. Copy the prompt content
3. In VS Code Copilot Chat, use it as a command
4. Or install it as a custom prompt in your VS Code settings

## 📚 Resource Guide

### Instructions (Coding Standards)

#### `bicep-code-best-practices.instructions.md`

**When to use**: Working with any `.bicep` files in this repository

**What it provides**:

- Naming conventions (lowerCamelCase, symbolic names)
- Parameter and variable best practices
- Resource reference patterns
- Security guidelines
- Latest API versions

**Example impact**:

- Before: `param storageAccountName string`
- After: `param storageAccount string` (no redundant 'Name' suffix)

#### `powershell-pester-5.instructions.md`

**When to use**: Writing PowerShell tests in `*.Tests.ps1` files

**What it provides**:

- Pester v5 testing patterns
- Mocking and assertion syntax
- Test structure (Describe, Context, It)
- Data-driven tests with `-TestCases`

**Example impact**:
Generates proper test structure automatically:

```powershell
Describe 'Get-VMInfo' {
    Context 'When VM exists' {
        BeforeAll {
            Mock Get-AzVM { @{ Name = 'TestVM' } }
        }
        It 'Should return VM object' {
            $result = Get-VMInfo -Name 'TestVM'
            $result | Should -Not -BeNullOrEmpty
        }
    }
}
```

#### `terraform-azure.instructions.md`

**When to use**: Working with Terraform `*.tf` files for Azure

**What it provides**:

- Terraform and Azure provider conventions
- Module organization patterns
- Variable and output best practices
- Choosing between azurerm and azapi providers
- State management guidance

**Example impact**:
Ensures consistent module structure:

```hcl
# main.tf, variables.tf, outputs.tf separation
# Proper provider version constraints
# Remote backend configuration
```

#### `devops-core-principles.instructions.md`

**When to use**: Any CI/CD, automation, or infrastructure work

**What it provides**:

- CALMS framework (Culture, Automation, Lean, Measurement, Sharing)
- DORA metrics understanding (Deployment Frequency, Lead Time, Change Failure Rate, MTTR)
- Guidance on automation, monitoring, and continuous improvement

**Example impact**:
Copilot suggests adding:

- Automated testing in CI/CD pipelines
- Monitoring and alerting configurations
- Deployment frequency optimizations
- Rollback strategies

### Chat Modes (Specialized Personas)

#### `bicep-implement.chatmode.md`

**Persona**: Azure Bicep IaC Specialist

**Capabilities**:

- Creates Bicep templates following best practices
- Validates against Azure Verified Modules
- Runs `bicep build`, `bicep lint`, `bicep format`
- Ensures no secrets or hardcoded values

**Use case**: "Create a Bicep template for a 3-tier network with NSGs and NAT Gateway"

#### `azure-principal-architect.chatmode.md`

**Persona**: Azure Principal Architect

**Capabilities**:

- Applies Well-Architected Framework principles
- Reviews architecture for cost, security, reliability, performance, operational excellence
- Provides strategic guidance

**Use case**: "Review my hub-spoke network design for security and cost optimization"

#### `terraform-azure-implement.chatmode.md`

**Persona**: Terraform Azure IaC Specialist

**Capabilities**:

- Creates Terraform configurations for Azure
- Follows Azure provider best practices
- Implements modules and state management
- Validates idempotency

**Use case**: "Create Terraform modules for Azure Kubernetes Service with monitoring"

### Prompts (Task Templates)

#### `documentation-writer.prompt.md`

**Framework**: Diátaxis Documentation Framework

**Capabilities**:

- Creates tutorials, how-to guides, reference docs, or explanations
- Proposes structure before writing
- Ensures clarity and user-centricity

**Use case**: "Generate a how-to guide for deploying the Bicep templates in demo 01"

#### `azure-resource-health-diagnose.prompt.md`

**Purpose**: Azure Resource Troubleshooting

**Capabilities**:

- Analyzes resource health
- Reviews logs and telemetry
- Creates remediation plans
- Generates GitHub issues for problems

**Use case**: "Diagnose why my VM is showing degraded performance"

### Collections (Bundled Workflows)

#### `azure-cloud-development.md`

**Bundle**: Complete Azure Development Toolkit

**Contains**: 18 curated items including:

- Azure Verified Modules (Bicep & Terraform)
- Cost optimization prompts
- Azure Functions patterns
- DevOps pipeline best practices
- Kubernetes deployment guidance

**Use case**: "I want a complete Copilot setup for Azure cloud development"

## 💡 Best Practices for Using These Customizations

### 1. Start with Project-Wide Instructions

Add the most relevant instructions to `.github/copilot-instructions.md`:

```bash
# For this IT Pro repository, we recommend:
cat resources/copilot-customizations/instructions/bicep-code-best-practices.instructions.md >> .github/copilot-instructions.md
cat resources/copilot-customizations/instructions/devops-core-principles.instructions.md >> .github/copilot-instructions.md
```

### 2. Use Chat Modes for Specialized Tasks

When working on a specific type of task, invoke the appropriate chat mode:

- Infrastructure implementation → Bicep or Terraform chat mode
- Architecture review → Azure Principal Architect
- Documentation → Documentation Writer

### 3. Layer Instructions Appropriately

- **Project-level** (`.github/copilot-instructions.md`): Standards that apply to all code
- **File-level** (individual `.instructions.md` files): Language or framework-specific
- **Chat-level** (chat modes): Task-specific expertise

### 4. Combine with Effective Prompts

The more context you provide, the better results you'll get:

**❌ Vague**:

```text
Create a storage account
```

**✅ Specific**:

```yaml
Create a Bicep template for an Azure Storage Account with:
  - HTTPS only
  - TLS 1.2 minimum
  - No public blob access
  - ZRS redundancy
  - Using naming convention from our project standards
```

### 5. Iterate and Refine

Don't expect perfection on the first try:

1. Generate initial code with Copilot
2. Review against the instruction guidelines
3. Ask Copilot to refine specific sections
4. Validate with `bicep build` or `terraform validate`

## 🔗 Integration with Demo Modules

These customizations are designed to enhance the demo modules in this repository:

| Demo                             | Recommended Customizations                                                   |
| -------------------------------- | ---------------------------------------------------------------------------- |
| **S01-bicep-baseline**           | `bicep-code-best-practices.instructions.md`<br>`bicep-implement.chatmode.md` |
| **S02-terraform-baseline**       | `terraform-azure.instructions.md`<br>`terraform-azure-implement.chatmode.md` |
| **S03-five-agent-workflow**      | `azure-principal-architect.chatmode.md`<br>`bicep-implement.chatmode.md`     |
| **S04-documentation-generation** | `documentation-writer.prompt.md`<br>`markdown.instructions.md`               |
| **S05-service-validation**       | `powershell-pester-5.instructions.md`                                        |
| **S06-troubleshooting**          | `azure-resource-health-diagnose.prompt.md`                                   |
| **S07-sbom-generator**           | `devops-core-principles.instructions.md`                                     |
| **S08-diagrams-as-code**         | `markdown.instructions.md`                                                   |

## 📖 Learning Path

### For Partners Delivering Demos

1. ✅ Read this README
2. ✅ Install `bicep-implement.chatmode.md` in VS Code
3. ✅ Try generating a Bicep template with the chat mode
4. ✅ Review output against `bicep-code-best-practices.instructions.md`
5. ✅ Add project-wide instructions to `.github/copilot-instructions.md`

### For IT Pros Learning IaC

1. ✅ Start with `devops-core-principles.instructions.md` (understanding)
2. ✅ Install the language-specific instruction (Bicep or Terraform)
3. ✅ Work through demo 01 or 02 with Copilot active
4. ✅ Use the chat modes to ask questions about best practices
5. ✅ Gradually add more customizations as you learn

## 🔄 Keeping Customizations Updated

The source repository ([github/awesome-copilot](https://github.com/github/awesome-copilot)) is actively maintained. To get updates:

```bash
# Update the awesome-copilot repo (in a temp location)
cd /tmp
git clone https://github.com/github/awesome-copilot.git
cd awesome-copilot

# Check for updates to specific files
git log --oneline -- instructions/bicep-code-best-practices.instructions.md

# Copy updated files back to this repo
cp instructions/bicep-code-best-practices.instructions.md \
   /path/to/azure-agentic-infraops/resources/copilot-customizations/instructions/
```

## 🤝 Contributing

Found a better way to use these customizations? Have suggestions for additional resources from awesome-copilot that would benefit IT Pros?

1. Open an issue describing your suggestion
2. Reference the awesome-copilot resource URL
3. Explain how it helps IT Pro scenarios

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines.

## 📜 Attribution

All customizations in this directory are sourced from the [github/awesome-copilot](https://github.com/github/awesome-copilot) repository, which is licensed under the MIT License.

**Original Repository**: https://github.com/github/awesome-copilot  
**License**: MIT License  
**Community**: 200+ customizations contributed by developers worldwide

We've curated a subset specifically relevant to Azure infrastructure and IT Pro workflows. For the complete collection, visit the awesome-copilot repository.

## 🔗 Related Resources

### In This Repository

- [Main README](../../README.md) - Project overview
- [Demo Modules](../../scenarios/) - Hands-on examples
- [Presenter Toolkit](../presenter-toolkit/) - Demo delivery materials

### External Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Awesome Copilot Repository](https://github.com/github/awesome-copilot)
- [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework/)

---

**Made with ❤️ for IT Pros**  
Curated from the awesome-copilot community for the IT Pro community
