---
marp: true
theme: default
paginate: true
backgroundColor: #ffffff
style: |
  section {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  h1 {
    color: #0078D4;
  }
  h2 {
    color: #106EBE;
  }
  table {
    font-size: 0.8em;
  }
  blockquote {
    border-left: 4px solid #0078D4;
    background: #f0f8ff;
    padding: 1em;
    font-style: italic;
  }
  .columns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1em;
  }
---

<!-- _class: lead -->
<!-- _backgroundColor: #0078D4 -->
<!-- _color: white -->

# GitHub Copilot for IT Professionals

## Agentic InfraOps: Azure Infrastructure Engineered by AI Agents

**Jonathan Vella**
Cloud Solution Architect
December 2025

![bg right:40% 80%](https://github.githubassets.com/images/modules/site/copilot/copilot.png)

<!--
SPEAKER NOTES:
Welcome everyone. Today we're going to explore how GitHub Copilot has evolved beyond code completion into something that fundamentally changes how IT Professionals work. This isn't about replacing developers - it's about empowering IT Pros to build infrastructure at the speed of thought.
-->

---

# The Evolution of GitHub Copilot

## From Code Completion → Agentic Workflows

| Era      | Capability         | What It Means                          |
| -------- | ------------------ | -------------------------------------- |
| **2021** | Code Completion    | Autocomplete on steroids               |
| **2023** | AI Pair Programmer | Chat, explain, refactor                |
| **2024** | Agents & MCP       | Autonomous multi-step workflows        |
| **2025** | Agentic InfraOps   | Requirements → Deployed Infrastructure |

> **Key Insight:** Copilot now understands _intent_, not just syntax.

<!--
SPEAKER NOTES:
GitHub Copilot started as smart autocomplete - impressive but limited. In 2023, Chat made it conversational. But 2024 changed everything with agents - AI that can research, plan, and execute multi-step tasks autonomously. Today, we can go from business requirements to deployed Azure infrastructure in under an hour.
-->

---

# Key Capabilities

## Four Pillars of GitHub Copilot

| Capability       | Description                   | IT Pro Use Case                             |
| ---------------- | ----------------------------- | ------------------------------------------- |
| 💬 **Chat**      | Natural language conversation | "Write a PowerShell script to audit my VMs" |
| ✨ **Inline**    | Context-aware completions     | Auto-complete Bicep resource blocks         |
| 🤖 **Agents**    | Specialized AI assistants     | Architecture assessment, code generation    |
| 🔧 **MCP Tools** | External integrations         | Real-time Azure pricing, diagrams           |

![bg right:35% 90%](https://code.visualstudio.com/assets/docs/copilot/copilot-chat/copilot-chat-view.png)

<!--
SPEAKER NOTES:
Think of these as layers. Inline suggestions are always-on assistance. Chat is for complex questions. Agents are specialized experts - Azure architect, Bicep planner, implementation specialist. MCP tools connect to external systems like Azure pricing APIs.
-->

---

# Available Tiers & Integration

## Choose Your Path

| Tier           | Price          | Best For                    |
| -------------- | -------------- | --------------------------- |
| **Individual** | $10/month      | Personal projects, learning |
| **Business**   | $19/user/month | Teams, admin controls       |
| **Enterprise** | $39/user/month | Compliance, IP indemnity    |

**Works Everywhere:**
✅ VS Code & Visual Studio ✅ JetBrains IDEs ✅ GitHub.com ✅ CLI ✅ Azure Portal

<!--
SPEAKER NOTES:
For IT Pros, start with Individual to prove value, then move to Business for team adoption. The $19/month pays for itself in the first hour of work.
-->

---

<!-- _class: lead -->
<!-- _backgroundColor: #106EBE -->
<!-- _color: white -->

# Why IT Pros Should Use Copilot

## It's Not Just for Developers

---

# Challenging the Misconception

## ❌ "GitHub Copilot is only for developers"

## ✅ Copilot is for anyone who writes code, scripts, or configuration

| If you write...    | Copilot helps you...        |
| ------------------ | --------------------------- |
| PowerShell scripts | Generate, debug, optimize   |
| Bicep/Terraform    | Create, validate, document  |
| YAML pipelines     | Build CI/CD workflows       |
| Documentation      | Auto-generate from code     |
| KQL queries        | Write Log Analytics queries |

<!--
SPEAKER NOTES:
This is the biggest misconception I encounter. If you touch a keyboard to configure infrastructure, Copilot is for you. I'm not a developer - my programming skills were minimal. Yet I've built production systems that would have taken months without Copilot.
-->

---

# The Paradigm Shift

## From "Writing Code" → "Describing Intent"

**Old Way:**

```
Learn syntax → Debug errors → Search Stack Overflow →
Copy/paste → Debug again → Hope it works
```

**New Way:**

```
"Create a hub-spoke network with 3 VNets,
NSGs blocking internet, and private endpoints
for Key Vault and Storage"
```

⬇️ **Result:** Production-ready Bicep in 30 seconds

<!--
SPEAKER NOTES:
You don't need to know that Azure SQL requires azureADOnlyAuthentication: true. You say "HIPAA compliant SQL database" and Copilot knows. You leverage your architectural knowledge; Copilot handles implementation.
-->

---

# Time Savings Evidence

## Industry Research + Our Metrics

| Task                       | Traditional | With Copilot | Savings    |
| -------------------------- | ----------- | ------------ | ---------- |
| Bicep Baseline             | 4-6 hours   | 30 min       | **87-92%** |
| Full Infrastructure Design | 18+ hours   | 45 min       | **96%**    |
| E-Commerce Platform        | 24+ hours   | 60 min       | **96%**    |
| Documentation              | 2-3 hours   | 20 min       | **85-89%** |
| Troubleshooting            | 2-4 hours   | 25 min       | **79-90%** |

_Sources: GitHub (55%), Forrester (88%), Accenture (60-80%)_

<!--
SPEAKER NOTES:
These aren't theoretical - they're from our demo scenarios. Traditional patient portal design: 18 hours. With agents: 45 minutes. That's transformational.
-->

---

# Skills Amplification

## Copilot Makes Everyone Better

| Profile           | Without Copilot | With Copilot                      |
| ----------------- | --------------- | --------------------------------- |
| **Expert IT Pro** | Fast, accurate  | **Faster**, focus on architecture |
| **Mid-level**     | Competent, gaps | **Expert-level** output quality   |
| **Newcomer**      | Slow, errors    | **Accelerated learning**          |

> "GitHub Copilot bridged the gap between my architectural vision and actual implementation"

<!--
SPEAKER NOTES:
Experts skip boilerplate. Mid-level pros produce expert-quality work. Newcomers learn correct patterns immediately. Everyone levels up.
-->

---

<!-- _class: lead -->
<!-- _backgroundColor: #107C10 -->
<!-- _color: white -->

# Agentic InfraOps Demo

## E-Commerce Platform: Requirements → Deployed in 60 Minutes

---

# The Four-Step Agent Workflow

## From Requirements to Deployed Infrastructure

```
┌──────────┐    ┌─────────────────────┐    ┌─────────────┐    ┌─────────────────┐
│  @plan   │ → │ azure-principal-    │ → │ bicep-plan  │ → │ bicep-implement │
│(Built-in)│    │     architect       │    │             │    │                 │
└──────────┘    └─────────────────────┘    └─────────────┘    └─────────────────┘
   5-10 min         10-15 min               5-10 min           10-15 min
```

**Each step includes an approval gate - YOU remain in control**

<!--
SPEAKER NOTES:
Four specialized agents. @plan is built into VS Code. The architect assesses against WAF. The planner creates module specs. The implementer generates Bicep. Between each step? You approve.
-->

---

# E-Commerce Platform Overview

## S04: PCI-DSS Compliant Retail Platform

| Metric              | Value             |
| ------------------- | ----------------- |
| **Target Users**    | 10,000 concurrent |
| **Compliance**      | PCI-DSS aligned   |
| **Azure Resources** | 61 resources      |
| **Bicep Modules**   | 18 modules        |
| **Monthly Cost**    | ~$1,595           |
| **WAF Score**       | 8.0/10            |

**Traditional:** 24+ hours → **With Agents:** 60 min = **96% time saved**

![bg right:40% 95%](../scenarios/scenario-output/ecommerce/ecommerce_architecture.png)

<!--
SPEAKER NOTES:
This is our flagship demo. A real e-commerce platform - Front Door, App Services, SQL Database, Redis, Service Bus. We do this live, from a single prompt to deployed infrastructure.
-->

---

# Demo Workflow Steps

## The Complete 6-Step Flow

| Step | Agent/Tool                  | Duration  | Key Output           |
| ---- | --------------------------- | --------- | -------------------- |
| 1️⃣   | `@plan`                     | 5-10 min  | Implementation plan  |
| 2️⃣   | `azure-principal-architect` | 10-15 min | WAF assessment       |
| 3️⃣   | Azure Pricing MCP           | 5 min     | ~$1,595/mo estimate  |
| 4️⃣   | `diagram-generator`         | 5 min     | Architecture diagram |
| 5️⃣   | `bicep-plan`                | 10 min    | 4-phase deployment   |
| 6️⃣   | `bicep-implement`           | 15-20 min | 18 Bicep modules     |

<!--
SPEAKER NOTES:
Notice steps 3 and 4. The Pricing MCP queries Azure APIs for real costs. We discovered Front Door Premium is $330/month - required for PCI-DSS WAF rules. Real trade-offs, before you spend.
-->

---

# Architecture Output

## What Gets Deployed

![bg right:55% 95%](../scenarios/scenario-output/ecommerce/ecommerce_architecture.png)

- 🌐 **Networking:** Front Door Premium + WAF, Private Endpoints
- 💻 **Compute:** 2× App Service Plans (P1v4), Azure Functions
- 💾 **Data:** SQL Database, Redis Cache, Cognitive Search
- 📨 **Messaging:** Service Bus Premium
- 🔐 **Security:** Key Vault, Managed Identities

<!--
SPEAKER NOTES:
This diagram is generated automatically by the diagram-generator agent using Python's diagrams library. Notice the layered architecture: CDN and WAF in front, app tier, data tier with private endpoints.
-->

---

# Cost Breakdown

## ~$1,595/month - Where Does It Go?

| Category         | Monthly | %   |
| ---------------- | ------- | --- |
| 💻 Compute       | $535    | 34% |
| 💾 Data Services | $466    | 29% |
| 🌐 Networking    | $376    | 24% |
| 📨 Messaging     | $200    | 13% |
| 🔐 Security      | $18     | 1%  |

**Top Costs:**

1. Front Door Premium: $330 (PCI-DSS)
2. App Service Plans: $412 (zone redundancy)
3. Cognitive Search S1: $245

💡 **3-year reservations save ~$2,030/year (32%)**

<!--
SPEAKER NOTES:
Transparency before deployment. Front Door Premium is $330 because PCI-DSS needs managed WAF rules. App Services are P1v4 for zone redundancy - Standard doesn't support it.
-->

---

<!-- _class: lead -->
<!-- _backgroundColor: #5C2D91 -->
<!-- _color: white -->

# My Personal Experience

## From Architect to Builder

---

# My Transformation Story

## From Architect with Limited IaC Skills → Building Production Systems

> "I'm not a developer. My IaC skills were limited at best. Yet with GitHub Copilot, I built production-ready infrastructure that would have been impossible just a year ago."

| Before Copilot            | After Copilot                     |
| ------------------------- | --------------------------------- |
| ✅ Deep Azure knowledge   | ✅ Same knowledge                 |
| ❌ Minimal programming    | ✅ Production-ready code          |
| ❌ Struggled to implement | ✅ Design + implement in parallel |

<!--
SPEAKER NOTES:
This is my story. I could design elegant architectures on a whiteboard, but translating them to code was painful and slow. Copilot changed that. My architectural expertise became directly actionable.
-->

---

# Portfolio - What I've Built

## Projects That Would Have Been "Impossible"

| Project                        | Traditional | With Copilot |
| ------------------------------ | ----------- | ------------ |
| **SAIF** (3-tier security app) | 3-4 months  | **3 weeks**  |
| **PostgreSQL HA on AKS**       | 2-3 months  | **2 weeks**  |
| **Java App Modernization**     | 1-2 months  | **1 week**   |
| **Sovereign Cloud Brain Trek** | 2-3 months  | **3 weeks**  |
| **Arc SQL Server Workshop**    | 2 months    | **2 weeks**  |

**Technologies I "Learned":** Python, PHP, Docker, Kubernetes, Bash, PostgreSQL, Java, Bicep

<!--
SPEAKER NOTES:
Look at SAIF - PHP frontend, Python backend, SQL database, Docker containers, Bicep deployment. 3-4 months for a developer team. 3 weeks for me with Copilot.
-->

---

# Project Highlight

## PostgreSQL HA on AKS: 8,000-10,000 TPS

**What I Built:**

- 3-node PostgreSQL clusters with automatic failover
- RPO = 0 (zero data loss)
- 30,000 concurrent connections
- Complete workshop with hands-on labs

**Without Copilot:** 2-3 months with external help
**With Copilot:** 2 weeks, independently

> Now used by partners for production training

<!--
SPEAKER NOTES:
8,000 transactions per second with zero data loss on failover. Complex Kubernetes configurations I'd never written. Copilot didn't just help - it enabled work that wouldn't have happened.
-->

---

<!-- _class: lead -->
<!-- _backgroundColor: #D83B01 -->
<!-- _color: white -->

# Objection Handling

## Addressing Common Concerns

---

# "AI Will Replace IT Pros"

## The Fear vs. The Reality

| AI Does                   | IT Pros Do                       |
| ------------------------- | -------------------------------- |
| Generate boilerplate code | Make architectural decisions     |
| Remember API syntax       | Understand business requirements |
| Apply known patterns      | Navigate organizational politics |
| Work fast                 | Ensure compliance and governance |
| Follow instructions       | Define what "right" looks like   |

> "Copilot augments architects, doesn't replace them. You still make the decisions."

<!--
SPEAKER NOTES:
AI doesn't replace judgment. It replaces typing. You decide whether to use private endpoints, which SKU fits the budget, how to handle DR. Copilot executes your vision faster.
-->

---

# "I Don't Trust AI-Generated Code"

## Validation is Built In

```
Agent Output → Human Review → bicep build → Deploy
               (Approval)     bicep lint
                              --what-if
```

**Guardrails:**

- ✅ Approval gates between every step
- ✅ `bicep build` validates syntax
- ✅ `bicep lint` checks best practices
- ✅ `--what-if` shows changes before deployment
- ✅ Azure Policy catches compliance violations

<!--
SPEAKER NOTES:
Don't trust blindly - you don't have to. Every agent step requires your approval. We run bicep build/lint, do what-if, Azure Policy blocks non-compliant resources.
-->

---

# "It's Too Expensive"

## The Math: ROI = 39:1

| Scenario              | Time Saved   | @ $75/hour | Value    |
| --------------------- | ------------ | ---------- | -------- |
| 1 Bicep project/month | 5 hours      | $75        | **$375** |
| 2 PowerShell scripts  | 3 hours      | $75        | **$225** |
| Documentation         | 2 hours      | $75        | **$150** |
| **Monthly Value**     | **10 hours** |            | **$750** |
| **Monthly Cost**      |              |            | **$19**  |

**The question isn't "can I afford Copilot" - it's "can I afford not to?"**

<!--
SPEAKER NOTES:
Conservative: save 10 hours/month at $75/hour = $750 value. Cost: $19. ROI is 39:1. Even saving 2 hours/month, you're ahead.
-->

---

# "Security/Compliance Concerns"

## Enterprise-Grade Controls

| Concern                         | Reality                                   |
| ------------------------------- | ----------------------------------------- |
| "Will my code train the model?" | ❌ No. Enterprise guarantees no training  |
| "Is it compliant?"              | ✅ SOC 2 Type II certified                |
| "Can we control it?"            | ✅ Admin policies, content filters        |
| "IP protection?"                | ✅ Enterprise includes IP indemnification |

**Enterprise Features:** Content exclusions, approved repos only, audit logs, SSO

<!--
SPEAKER NOTES:
Enterprise tier: your code is NOT used for training. Period. SOC 2 Type II. Restrict repos, filter content, audit everything. For regulated industries, Enterprise with IP indemnification.
-->

---

# "Learning Curve / Org Approval"

## Getting Started is Simple

**Your First Month:**

- Week 1: Chat to explain existing code
- Week 2: Generate documentation
- Week 3: PowerShell scripts
- Week 4: First Bicep template

**Getting Approval:**

1. Individual license ($10/month personal)
2. Track time saved, document wins
3. Present ROI with real examples
4. Propose pilot with Business tier
5. Scale based on results

<!--
SPEAKER NOTES:
Start small. Natural language, gentle curve. For org approval: don't ask permission - build evidence. "I saved 10 hours last month" beats any vendor pitch.
-->

---

<!-- _class: lead -->
<!-- _backgroundColor: #0078D4 -->
<!-- _color: white -->

# Getting Started

## Your Path to Productivity

---

# Prerequisites

## What You Need (15 minutes to set up)

| Tool                  | Purpose               | Install                |
| --------------------- | --------------------- | ---------------------- |
| **VS Code**           | Primary IDE           | code.visualstudio.com  |
| **GitHub Account**    | Copilot subscription  | github.com             |
| **Copilot Extension** | Enable AI features    | VS Code Marketplace    |
| **Azure CLI**         | Deploy infrastructure | aka.ms/installazurecli |
| **Bicep CLI**         | Validate templates    | Built into Azure CLI   |

**Optional:** Dev Containers, PowerShell 7+, Azure subscription

<!--
SPEAKER NOTES:
15 minutes to get started. VS Code, GitHub account, Copilot extension, Azure CLI. Our repo includes a Dev Container with everything pre-configured.
-->

---

# Quick Wins - Your First Week

## Start Here, Build Confidence

| Day   | Activity      | Prompt to Try                                    |
| ----- | ------------- | ------------------------------------------------ |
| **1** | Explain code  | "Explain what this Bicep template does"          |
| **2** | Generate docs | "Create a README for this folder"                |
| **3** | PowerShell    | "Write a script to list all VMs"                 |
| **4** | Simple Bicep  | "Create a storage account with private endpoint" |
| **5** | Full workflow | Try the S04 e-commerce demo                      |

**Pro Tip:** Start with documentation - zero risk, immediate value

<!--
SPEAKER NOTES:
Day 1: explain code - zero risk. Day 2: documentation - safe and useful. Day 3: scripts. Day 4: infrastructure. Day 5: full agent workflow. Progressive complexity.
-->

---

# Resources & Next Steps

## Continue Your Journey

| Resource            | Link                                             |
| ------------------- | ------------------------------------------------ |
| **Repository**      | github.com/jonathan-vella/azure-agentic-infraops |
| **S04 Demo**        | scenarios/S04-ecommerce-platform/                |
| **Microsoft Learn** | learn.microsoft.com/copilot                      |
| **GitHub Docs**     | docs.github.com/copilot                          |

**Your Next Steps:**

1. ⬇️ Clone the repository
2. 🚀 Open in VS Code with Dev Container
3. 💬 Try `@plan` agent with e-commerce scenario
4. 📊 Track your time savings
5. 🎉 Share your results

<!--
SPEAKER NOTES:
Everything is open source. Clone, Dev Container, and you have my environment. Start with @plan agent. Track results. Share what you build.
-->

---

<!-- _class: lead -->
<!-- _backgroundColor: #0078D4 -->
<!-- _color: white -->

# Thank You

## Key Takeaways

1. 🚀 **Efficiency multiplier** - 87-96% time reduction
2. 🏗️ **Requirements → Deployed** in under an hour
3. ✅ **Well-Architected by design**
4. 🎯 **Start today** - gentle curve, immediate ROI

---

# Questions?

## Let's Connect

**Jonathan Vella**

- 📧 [Your Email]
- 💼 [LinkedIn]
- 🐦 [Twitter/X]

**Repository:**
github.com/jonathan-vella/azure-agentic-infraops

![bg right:40% 80%](https://github.githubassets.com/images/modules/site/copilot/copilot.png)

<!--
SPEAKER NOTES:
Four takeaways: efficiency multiplier with real savings, requirements to deployed in an hour, Well-Architected aligned, start today. The learning curve is gentle, ROI is immediate. Questions?
-->

---

<!-- _class: lead -->

# Appendix

---

# Detailed Time Savings

| Category        | Traditional | With Copilot | Source      |
| --------------- | ----------- | ------------ | ----------- |
| IaC Development | 4-8 hours   | 30-60 min    | GitHub      |
| Scripting       | 2-4 hours   | 20-40 min    | Microsoft   |
| Troubleshooting | 2-4 hours   | 25-40 min    | Gartner     |
| Documentation   | 2-3 hours   | 20 min       | Harvard/BCG |
| Large-Scale Ops | Days        | Hours        | McKinsey    |

---

# Agent Configuration

## Where Are the Agents Defined?

```
.github/agents/
├── azure-principal-architect.agent.md
├── bicep-plan.agent.md
├── bicep-implement.agent.md
├── diagram-generator.agent.md
└── adr-generator.agent.md
```

**Each agent has:** Role constraints, default behaviors, handoff instructions, approval gates

---

# Full Service Pricing

| Service              | SKU        | Monthly     |
| -------------------- | ---------- | ----------- |
| App Service Plan ×2  | P1v4 Linux | $411.72     |
| Azure Front Door     | Premium    | $330.00     |
| Cognitive Search     | S1         | $245.28     |
| Service Bus          | Premium    | $200.00     |
| SQL Database         | S3         | $145.16     |
| Azure Functions      | EP1        | $123.37     |
| Redis Cache          | C2         | $65.70      |
| Private Endpoints ×5 | -          | $36.50      |
| Static Web Apps      | Standard   | $9.00       |
| **Total**            |            | **~$1,595** |
