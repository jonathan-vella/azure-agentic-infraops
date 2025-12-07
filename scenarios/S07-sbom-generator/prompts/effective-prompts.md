# Effective Prompts for SBOM Discovery with GitHub Copilot

This guide provides conversation-based prompts for learning SBOM creation with GitHub Copilot as your expert partner.
These prompts emphasize **understanding concepts** while building production deliverables.

---

## Conversation Approach Philosophy

**Goal**: Learn SBOM fundamentals through guided conversation (not just generate scripts)

**Key Principles**:
1. ✅ **Ask "why"** - Understand the reasoning behind decisions
2. ✅ **Admit what you don't know** - Copilot teaches better when you're honest
3. ✅ **Provide context** - Share your scenario (healthcare, finance, compliance need)
4. ✅ **Iterate naturally** - Ask follow-up questions like talking to a colleague
5. ✅ **Request explanations** - Don't just accept output, understand it

---

## Phase 1: Problem Definition & Strategy (10 minutes)

### Initial Discovery Prompts

#### Prompt 1.1: Starting from Zero

```
I need to create a Software Bill of Materials (SBOM) for a [healthcare/finance/retail] 
application that [customer name] is requiring for [procurement/audit/compliance]. 
I've never created an SBOM before - can you help me understand what it is and what 
I need to include?
```

**Why This Works**: 
- Honest about experience level
- Provides business context
- Asks for understanding, not just instructions

**Expected Learning**: SBOM definition, purpose, basic structure

#### Prompt 1.2: Format Selection

```
What's the difference between CycloneDX and SPDX? Which format should I use for 
[healthcare compliance/security audit/customer procurement]?
```

**Why This Works**: 
- Comparative question (teaches through contrast)
- Context-specific guidance

**Expected Learning**: Format trade-offs, industry standards, when to use each

#### Prompt 1.3: Scope Clarification

```
What components should I include in my SBOM? Just application code dependencies, 
or also the Docker container and Azure infrastructure?
```

**Why This Works**: 
- Reveals common confusion (scope boundaries)
- Copilot explains layered approach

**Expected Learning**: 3-layer model (application, container, infrastructure)

---

## Phase 2: Application Dependencies Discovery (20 minutes)

### Component Identification Prompts

#### Prompt 2.1: Analyzing Package Files

```
I have a package.json file with [6/10/20] npm dependencies. How should I document 
these in the SBOM? What fields are required?
```

**Attach**: Your actual package.json file

**Why This Works**: 
- Specific to your project
- Asks about structure, not just execution

**Expected Learning**: CycloneDX component structure, required fields

#### Prompt 2.2: PURL Format Education

```
I see Express version 4.18.2 in my dependencies. How do I format this as a PURL 
(Package URL)? What's the pattern for npm packages?
```

**Why This Works**: 
- Asks about ONE package (easier to learn)
- Requests pattern (transferable knowledge)

**Expected Learning**: PURL specification, format variations across ecosystems

#### Prompt 2.3: License Compliance

```
How do I find license information for npm packages? Does the license type matter 
for [commercial use/healthcare/government contracting]?
```

**Why This Works**: 
- Practical question (where to find data)
- Business context (why it matters)

**Expected Learning**: License types, implications, compliance considerations

#### Prompt 2.4: Batch Generation (After Learning)

```
Now that I understand the pattern, can you generate CycloneDX components for all 
[X] packages in my package.json? Use PURL format and include license information.
```

**Why This Works**: 
- Shows you learned the pattern (validates understanding)
- Asks for batch automation (efficiency)

**Expected Learning**: Applying pattern at scale

---

## Phase 3: Container Components Analysis (15 minutes)

### Container Discovery Prompts

#### Prompt 3.1: Base Image Investigation

```
My Dockerfile uses [node:20-alpine/python:3.11-slim/ubuntu:22.04] as the base image. 
Do I need to include components from that base image in my SBOM? What would 
[customer name] expect to see?
```

**Why This Works**: 
- Questions the assumption (do containers count?)
- Stakeholder perspective (customer expectations)

**Expected Learning**: Base image importance, supply chain visibility

#### Prompt 3.2: System Package Identification

```
What packages are typically in [Alpine Linux/Debian/Ubuntu] that I should document? 
Which ones are security-critical?
```

**Why This Works**: 
- Ecosystem-specific question
- Security prioritization

**Expected Learning**: Common system packages, security considerations (OpenSSL, musl, etc.)

#### Prompt 3.3: Container Component Formatting

```
How do I format Alpine Linux packages in PURL? Is it different from npm packages?
```

**Why This Works**: 
- Compares to learned pattern (npm)
- Reveals cross-ecosystem consistency

**Expected Learning**: PURL versatility, ecosystem-specific prefixes

#### Prompt 3.4: Comprehensive Container SBOM

```
Generate CycloneDX components for the key packages in [node:20-alpine]:
- Alpine Linux base
- musl (C library)
- OpenSSL
- [Node.js/Python/other] runtime

Use PURL format for Alpine packages (pkg:alpine/...)
```

**Why This Works**: 
- Lists specific components (shows understanding)
- References learned format (PURL)

**Expected Learning**: Complete container documentation

---

## Phase 4: Infrastructure Documentation (15 minutes)

### Infrastructure Prompts

#### Prompt 4.1: Cloud Service Inclusion

```
My application runs on [Azure App Service/AWS ECS/Google Cloud Run] with 
[database/cache/storage] services. Should I document these cloud services as 
components in the SBOM? Or is it just code and containers?
```

**Why This Works**: 
- Challenges scope boundaries
- Platform-specific context

**Expected Learning**: Infrastructure-as-component concept, stakeholder needs

#### Prompt 4.2: Cloud Service Formatting

```
How do I format Azure services as SBOM components? What version information 
should I include for [App Service/Cosmos DB/Key Vault]?
```

**Why This Works**: 
- Extends PURL understanding to new domain
- Asks about versioning (SKU, API version)

**Expected Learning**: Cloud service documentation patterns

#### Prompt 4.3: Azure-Specific Generation

```
Generate CycloneDX components for these Azure services:
- App Service (P1v2 tier)
- Cosmos DB (Core SQL API, version 4.0)
- Key Vault (Standard tier)
- Application Insights

Use PURL format like pkg:azure/[service-name]
```

**Why This Works**: 
- Applies learned pattern to new context
- Includes SKU/version details

**Expected Learning**: Infrastructure SBOM completeness

---

## Phase 5: Assembly & Validation (15 minutes)

### Integration Prompts

#### Prompt 5.1: SBOM Assembly

```
Can you combine all [15/30/50] components (from application, container, and 
infrastructure) into a complete CycloneDX 1.5 SBOM? Include the required 
metadata (bomFormat, specVersion, serialNumber, version, metadata with 
component details for [application name]).
```

**Why This Works**: 
- Synthesizes all learned pieces
- References CycloneDX structure learned earlier

**Expected Learning**: Complete SBOM document structure

#### Prompt 5.2: Validation

```
How can I validate this SBOM is correct? Are there any required fields missing?
What makes a "valid" CycloneDX 1.5 SBOM?
```

**Why This Works**: 
- Quality assurance mindset
- Learns validation process

**Expected Learning**: Validation tools, schema compliance, quality checks

#### Prompt 5.3: Stakeholder Reporting

```
Can you generate an HTML report from this SBOM that I can send to [customer name]'s 
[procurement/security/compliance] team? Make it non-technical, showing component 
counts, license summary, and risk assessment.
```

**Why This Works**: 
- Communication focus (technical → non-technical)
- Stakeholder-specific needs

**Expected Learning**: Stakeholder communication, data visualization

---

## Follow-Up & Refinement Prompts

### Clarification Prompts

When Copilot's explanation is unclear:

```
Can you explain [PURL/CycloneDX/license compliance] in simpler terms? 
Give me an example using [specific package from my project].
```

```
I don't understand the difference between [bomFormat and specVersion / 
type and bom-ref / component and dependency]. Can you clarify?
```

### Iteration Prompts

When refining the SBOM:

```
Are there any components we might have missed? Let's review:
- Development dependencies (should we include those?)
- Build tools (webpack, babel, etc.)
- Runtime libraries loaded dynamically
```

```
The SBOM has [X] components now. Is this comprehensive for a [type] 
application running on [platform]?
```

### Error Correction Prompts

When something seems wrong:

```
I validated the SBOM and got this error: [error message]. 
What's wrong and how do I fix it?
```

```
The PURL for [package name] doesn't look right. Should it be 
pkg:npm/... or pkg:github/...?
```

---

## Advanced Prompts (Post-Learning)

### Automation After Understanding

Once you understand SBOMs (after creating 2-3 manually), scale with automation:

#### Automation Prompt 1: Script Generation

```
I've created several SBOMs manually and understand the structure. Now I want to 
automate this. Can you generate a PowerShell script that:
1. Reads package.json
2. Scans Docker image with Syft
3. Queries Azure Resource Graph for infrastructure
4. Merges into CycloneDX 1.5 JSON
5. Generates HTML report

Include error handling and parameters for customization.
```

**Why This Works**: 
- Shows mastery of concepts (manual → automation)
- Specific requirements based on learned patterns

#### Automation Prompt 2: CI/CD Integration

```
How can I integrate SBOM generation into my Azure DevOps / GitHub Actions pipeline? 
Generate a workflow that creates an SBOM on every release and uploads it as an artifact.
```

**Why This Works**: 
- Natural progression (manual → automated → CI/CD)
- Production deployment

---

## Common Mistakes to Avoid

### ❌ Wrong Approach: Asking for Scripts Immediately

```
Generate a PowerShell script that creates SBOMs.
```

**Why This Fails**: 
- No learning occurs
- Can't troubleshoot or customize
- Doesn't understand output

### ✅ Right Approach: Learn First, Automate Later

```
I need to create an SBOM. I've never done this before. Can you explain 
what it is and walk me through the process step-by-step?
```

**Why This Works**: 
- Builds understanding
- Transferable knowledge
- Can explain to auditors/stakeholders

---

## Prompt Templates by Use Case

### Use Case 1: Urgent Customer Request (Time-Sensitive)

```
URGENT: [Customer name] needs an SBOM in [timeframe] for [reason]. I've never 
created one. Can you help me understand what it is and create one quickly for 
a [technology stack] application running on [platform]?
```

### Use Case 2: Compliance Audit

```
We have a [HIPAA/SOC2/PCI-DSS] audit coming up and need to provide SBOMs for 
our applications. I need to understand what auditors expect to see and how to 
create a compliant SBOM for a [technology] application.
```

### Use Case 3: Vulnerability Response

```
A new CVE ([CVE-ID]) was disclosed for [package name]. I need to quickly 
determine if our applications are affected. Can you help me create SBOMs 
for our [number] applications so I can search for this component?
```

### Use Case 4: Onboarding / Training

```
I'm new to the security team and need to learn about SBOMs. Can you teach me 
what they are, why they matter, and how to create one? I learn best with 
hands-on examples.
```

---

## Measuring Success

You know you've used prompts effectively when:

- ✅ You can explain what an SBOM is to a non-technical stakeholder
- ✅ You understand PURL format and can format packages yourself
- ✅ You know the difference between CycloneDX and SPDX
- ✅ Your next SBOM takes 30 minutes (not 6 hours) because you retained knowledge
- ✅ You can answer auditor questions about your SBOM creation process
- ✅ You can teach a colleague using the same conversation approach

---

## Legacy: Script Generation Prompts (Automation Approach)

**Note**: These prompts are for the **OLD approach** (building PowerShell automation scripts).
Use these only **after** you understand SBOMs through conversation.

For script automation prompts, see `effective-prompts-old.md` or the `solution/` folder README.

---

## Related Resources

- **Full Conversation Example**: `examples/copilot-sbom-conversation.md`
- **Demo Script**: `DEMO-SCRIPT.md` (conversation-based approach)
- **Automation Scripts**: `solution/` folder (legacy reference)

---

**Philosophy**: Learn first, automate later. Understanding SBOMs makes you effective; automation makes you efficient.
Both matter, but knowledge is the foundation.
