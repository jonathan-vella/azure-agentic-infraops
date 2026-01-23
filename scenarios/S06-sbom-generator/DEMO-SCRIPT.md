# S06: SBOM Discovery with GitHub Copilot - Presenter Guide

**Duration**: 30 minutes
**Approach**: Conversation-based learning (Copilot as SBOM expert partner)
**Audience**: Security teams new to SBOMs, compliance officers, IT professionals

---

## Sarah's Story Arc

**Who**: Sarah Chen, Security Engineer (3 years experience, zero SBOM knowledge)
**Stakes**: Mayo Clinic $2M contract, 48-hour deadline
**Journey**: Panic → Discovery → Understanding → Delivery → Confidence

> "By the end of this conversation, I didn't just have an SBOM—I understood
> why it mattered and how to explain it to the Mayo Clinic team."

---

## Pre-Demo Setup (5 minutes before presentation)

### Required Tools

- ✅ VS Code with GitHub Copilot Chat extension
- ✅ This repository cloned locally
- ✅ Copilot authenticated and working
- ✅ Web browser open to [CycloneDX Online Validator](https://sbomgenerator.com/tools/validator)

### Test Copilot

Open Copilot Chat (Ctrl+Alt+I / Cmd+Alt+I) and verify:

```
Test prompt: "What is a Software Bill of Materials?"
Expected: Copilot explains SBOM concept clearly
```

If Copilot isn't responding well, restart VS Code.

### Backup Plan

Have `examples/copilot-sbom-conversation.md` open in a separate tab. If live demo fails, walk through the transcript.

### Files to Have Ready

```bash
cd /workspaces/azure-agentic-infraops/scenarios/S06-sbom-generator

# Extract sample app if not already done
unzip -n sample-app.zip

code sample-app/src/api/package.json  # For Phase 2
code sample-app/src/api/Dockerfile     # For Phase 3
```

---

## Demo Structure Overview

| Time      | Phase                                     | Focus                              | Key Message                         |
| --------- | ----------------------------------------- | ---------------------------------- | ----------------------------------- |
| 0-5 min   | **Intro & Scene Setting**                 | Sarah's urgent Mayo Clinic request | "I've never created an SBOM before" |
| 5-10 min  | **Phase 1: Problem Definition**           | What is an SBOM?                   | Copilot teaches fundamentals        |
| 10-18 min | **Phase 2: Application Discovery**        | Analyzing package.json             | PURL format, licenses               |
| 18-23 min | **Phase 3-4: Container & Infrastructure** | Docker image, Azure services       | Component completeness              |
| 23-28 min | **Phase 5: Assembly & Validation**        | CycloneDX JSON generation          | Production deliverables             |
| 28-30 min | **Wrap-Up & Metrics**                     | Knowledge transfer value           | 79% time savings + learning         |

---

## Phase 0: Introduction (0-5 minutes)

### Scene Setting: The Urgent Request

**[OPEN]** Slide/screen showing email:

> **Subject**: URGENT: SBOM Required for Contract Renewal  
> **From**: Mayo Clinic Procurement  
> **To**: Sarah Chen, Security Engineer, HealthTech Solutions
>
> Sarah,
>
> Our security team requires a complete Software Bill of Materials (SBOM) for your Patient Portal application before we can approve the $2M contract renewal. Please provide by end of week (48 hours).
>
> Best,  
> Mayo Clinic Security Team

**[NARRATE]**:

> "Meet Sarah Chen. She's a security engineer at HealthTech Solutions, a healthcare SaaS company. She just received this email from her biggest customer, Mayo Clinic. They need an SBOM in 48 hours or the $2M contract renewal is blocked."
>
> "Sarah's problem: She has **never created an SBOM before**. She doesn't know:"
>
> - "What components to include - just app code? Containers? Infrastructure?"
> - "What format to use - CycloneDX? SPDX? JSON? XML?"
> - "How to structure the data - what fields are required?"
> - "Where to find license information for each component"
> - "How to validate that it's complete and correct"

**[PAUSE FOR IMPACT]**

> "Traditionally, Sarah would spend the next 6 hours Googling specifications, reading Docker Hub docs, manually listing packages, and hoping she didn't miss anything. 80% accuracy is typical for manual SBOM creation."
>
> "But Sarah has GitHub Copilot. Let's watch her ask Copilot to teach her how to create an SBOM - **while she's creating it**."

### Value Proposition

**[TRANSITION TO DEMO]**:

> "By the end of this 30-minute demo, you'll see how Sarah:"
>
> - "✅ Learns SBOM fundamentals from Copilot (not just gets output)"
> - "✅ Creates a near-production-ready 15-component SBOM in 1 hour 15 minutes (not 6 hours)"
> - "✅ Understands PURL, CycloneDX, licenses - can create future SBOMs in 30 minutes"
> - "✅ Can explain her methodology to Mayo Clinic auditors confidently"
>
> "This is about **knowledge transfer**, not just automation. Sarah will understand SBOMs, not just have one."

---

## Phase 1: Problem Definition (5-10 minutes)

### Step 1: Open Copilot Chat

**[ACTION]**: Open VS Code, start Copilot Chat (Ctrl+Alt+I / Cmd+Alt+I)

**[NARRATE]**:

> "Sarah starts by admitting she doesn't know what an SBOM is. Instead of spending 30 minutes reading specifications, she asks Copilot directly."

### Step 2: Initial Question

**[TYPE IN COPILOT CHAT]**:

```
I need to create a Software Bill of Materials (SBOM) for a healthcare application
that Mayo Clinic is requiring for procurement. I've never created an SBOM before -
can you help me understand what it is and what I need to include?
```

**[NARRATE WHILE COPILOT RESPONDS]**:

> "Notice how Sarah frames this: She's honest about being new to SBOMs, provides context (healthcare, Mayo Clinic, procurement), and asks for **understanding**, not just instructions."

### Step 3: Teaching Response

**[EXPECTED COPILOT RESPONSE - READ KEY POINTS ALOUD]**:

> "Copilot explains:"
>
> - "**What it is**: An SBOM is like a recipe card for software - lists every ingredient (component)"
> - "**Why Mayo needs it**: HIPAA compliance, vulnerability tracking, incident response"
> - "**Format recommendation**: CycloneDX 1.5 (industry standard, JSON format)"
> - "**What to include**: Application dependencies, container components, infrastructure"

**[PAUSE]**:

> "In **2 minutes**, Sarah understands what an SBOM is and has a clear path forward. That would have taken 30 minutes reading NTIA specifications."

### Step 4: Follow-Up Question (Show Iterative Learning)

**[TYPE IN COPILOT CHAT]**:

```
What's the difference between CycloneDX and SPDX? Which should I use?
```

**[NARRATE]**:

> "Sarah can ask follow-up questions naturally. Copilot explains SPDX is Linux Foundation standard (license-focused), CycloneDX is OWASP standard (security-focused). For healthcare and Mayo Clinic, CycloneDX is better."

### Step 5: Strategy Confirmation

**[TYPE IN COPILOT CHAT]**:

```
Okay, so I need to document 3 layers:
1. Application dependencies (npm packages)
2. Container components (Docker base image)
3. Infrastructure (Azure services)

Let's start with the application layer. How do I analyze package.json?
```

**[NARRATE]**:

> "Sarah now has a **structured plan**. She understands the 'why' and the 'what'. Now she's ready for the 'how'. Let's start with application dependencies."

**[TEACHING MOMENT - TO AUDIENCE]**:

> "🎓 **Key Learning Moment**: This is the core difference between task automation
> and knowledge transfer. Sarah isn't copying and pasting commands. She's
> **learning the concepts** through conversation. When she creates her next SBOM,
> she won't need to ask these foundational questions again."

---

## Phase 2: Application Dependencies Discovery (10-18 minutes)

### Step 1: Open package.json

**[ACTION]**: Open `sample-app/src/api/package.json` in VS Code

**[NARRATE]**:

> "Sarah's application is a Node.js API built with Express. Let's look at the dependencies."

**[SHOW FILE BRIEFLY]**:

```json
{
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.0.3",
    "@azure/identity": "^3.1.3",
    "@azure/keyvault-secrets": "^4.6.0",
    "applicationinsights": "^2.9.1",
    "dotenv": "^16.0.3"
  }
}
```

**[NARRATE]**:

> "6 npm packages. Sarah needs to format these as SBOM components. But what format? What fields are required?"

### Step 2: Ask About PURL Format

**[TYPE IN COPILOT CHAT]**:

```
I have Express version 4.18.2 as a dependency. How should I format this
in the SBOM? What fields are required?
```

**[EXPECTED COPILOT RESPONSE - HIGHLIGHT KEY POINTS]**:

**[NARRATE WHILE READING]**:

> "Copilot teaches Sarah about **PURL** - Package URL. It's the standard way to reference components across different ecosystems (npm, Maven, PyPI, Alpine, etc.)."

**[READ COPILOT'S EXAMPLE]**:

```json
{
  "type": "library",
  "bom-ref": "pkg:npm/express@4.18.2",
  "name": "express",
  "version": "4.18.2",
  "purl": "pkg:npm/express@4.18.2",
  "licenses": [{ "license": { "id": "MIT" } }]
}
```

**[TEACHING MOMENT - TO AUDIENCE]**:

> "🎓 **Key Learning Moment**: Notice what just happened: Sarah asked about
> **one package**, and Copilot taught her:"
>
> - "The PURL format: `pkg:npm/express@4.18.2`"
> - "Required CycloneDX fields: type, bom-ref, name, version, purl, licenses"
> - "How to structure the JSON"
>
> "She can now apply this pattern to all 6 packages. This is **transferable knowledge**."

### Step 3: Ask About Licenses

**[TYPE IN COPILOT CHAT]**:

```
How do I find the license for Express and the other packages?
Does the license type matter for Mayo Clinic?
```

**[EXPECTED COPILOT RESPONSE]**:

**[NARRATE]**:

> "Copilot explains:"
>
> - "Licenses are in package.json or on npmjs.com"
> - "Express uses MIT license (permissive, allows commercial use)"
> - "For Mayo Clinic (healthcare), need to avoid GPL (copyleft) in proprietary software"
> - "MIT, BSD, Apache 2.0 are all safe for commercial use"

**[TEACHING MOMENT - TO AUDIENCE]**:

> "🎓 **Key Learning Moment**: Sarah is learning **license compliance** while
> building the SBOM. This isn't just documentation—it's risk assessment.
> If she found a GPL package, she'd know to flag it for legal review.
> The knowledge compounds."

### Step 4: Generate Application Components (Accelerated)

**[NARRATE]**:

> "For demo time, let's ask Copilot to generate all 6 npm components at once."

**[TYPE IN COPILOT CHAT]**:

```
Can you generate CycloneDX components for all 6 packages in my package.json?
Use PURL format and include license information.
```

**[SHOW COPILOT OUTPUT BRIEFLY - DON'T READ ALL]**:

```json
{
  "components": [
    {
      "type": "library",
      "bom-ref": "pkg:npm/express@4.18.2",
      "name": "express",
      "version": "4.18.2",
      "purl": "pkg:npm/express@4.18.2",
      "licenses": [{ "license": { "id": "MIT" } }]
    },
    {
      "type": "library",
      "bom-ref": "pkg:npm/mongoose@7.0.3",
      "name": "mongoose",
      "version": "7.0.3",
      "purl": "pkg:npm/mongoose@7.0.3",
      "licenses": [{ "license": { "id": "MIT" } }]
    }
    // ... 4 more packages
  ]
}
```

**[NARRATE]**:

> "6 application components documented. Sarah understands the PURL format, knows why licenses matter, and can do this herself next time. **20 minutes total** vs 2 hours manually researching each package."

---

## Phase 3-4: Container & Infrastructure (18-23 minutes)

### Transition

**[NARRATE]**:

> "Application layer is done. But Sarah's app runs in a Docker container on Azure App Service. Does she need to document those components too?"

### Step 1: Ask About Container Components

**[ACTION]**: Open `sample-app/src/api/Dockerfile`

**[SHOW DOCKERFILE BRIEFLY]**:

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

**[TYPE IN COPILOT CHAT]**:

```
My Dockerfile uses node:20-alpine as the base image. Do I need to include
components from that base image in the SBOM? What would Mayo Clinic expect?
```

**[EXPECTED COPILOT RESPONSE]**:

**[NARRATE WHILE READING KEY POINTS]**:

> "Copilot explains:"
>
> - "**Yes**, base image components matter - vulnerabilities like Heartbleed live in system libraries"
> - "node:20-alpine includes Alpine Linux packages (musl, apk-tools), Node.js runtime, and OpenSSL"
> - "Mayo Clinic will want to know about OpenSSL specifically (security-critical)"

**[TEACHING MOMENT - TO AUDIENCE]**:

> "🎓 **Key Learning Moment**: This is where 80% of manual SBOMs fail—they
> forget container base image components. Sarah would have missed Alpine Linux,
> OpenSSL, and musl without Copilot's guidance. The discovery approach surfaces
> what you don't know you don't know."

### Step 2: Generate Container Components (Accelerated)

**[TYPE IN COPILOT CHAT]**:

```
Generate CycloneDX components for the key packages in node:20-alpine:
- Alpine Linux base
- musl (C library)
- OpenSSL
- Node.js runtime
Use PURL format for Alpine packages (pkg:alpine/...)
```

**[SHOW COPILOT OUTPUT BRIEFLY]**:

```json
{
  "type": "operating-system",
  "bom-ref": "pkg:alpine/alpine-baselayout@3.4.3",
  "name": "alpine-baselayout",
  "version": "3.4.3",
  "purl": "pkg:alpine/alpine-baselayout@3.4.3"
},
{
  "type": "library",
  "bom-ref": "pkg:alpine/openssl@3.1.0",
  "name": "openssl",
  "version": "3.1.0",
  "purl": "pkg:alpine/openssl@3.1.0",
  "description": "Toolkit for SSL/TLS - security-critical"
}
```

**[NARRATE]**:

> "5 container components added. Notice PURL format changed: `pkg:alpine/openssl@3.1.0` for Alpine packages. Sarah is learning the PURL specification across ecosystems."

### Step 3: Infrastructure Components (Quick)

**[TYPE IN COPILOT CHAT]**:

```
My application runs on Azure App Service with Cosmos DB backend, Key Vault
for secrets, and Application Insights for monitoring. Should I document
these Azure services as components?
```

**[EXPECTED COPILOT RESPONSE]**:

**[NARRATE]**:

> "Copilot explains: For Mayo Clinic's procurement team, **yes**. They care about:"
>
> - "What platform (App Service P1v2)"
> - "Where data is stored (Cosmos DB)"
> - "How secrets are managed (Key Vault)"
>
> "Format: `pkg:azure/app-service@P1v2`, `pkg:azure/cosmos-db@4.0`"

**[TEACHING MOMENT - TO AUDIENCE]**:

> "🎓 **Key Learning Moment**: Sarah is learning to think from **stakeholder
> perspective**. Not just technical accuracy—what does Mayo Clinic need to know
> for risk assessment? This stakeholder-awareness transfers to all future
> security work, not just SBOMs."

**[NARRATE]**:

> "Let's skip the detailed generation for demo time. Sarah would ask Copilot to generate 4 Azure components. **Total so far: 6 npm + 5 container + 4 Azure = 15 components**."

---

## Phase 5: Assembly & Validation (23-28 minutes)

### Step 1: Generate Complete SBOM

**[NARRATE]**:

> "Sarah has all the pieces. Now she needs to assemble them into a valid CycloneDX 1.5 document."

**[TYPE IN COPILOT CHAT]**:

```
Can you combine all 15 components into a complete CycloneDX 1.5 SBOM?
Include the required metadata (bomFormat, specVersion, serialNumber, version,
metadata with component details for the Patient Portal application).
```

**[EXPECTED COPILOT RESPONSE]**:

**[SHOW COPILOT GENERATING - SCROLL THROUGH QUICKLY]**:

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "serialNumber": "urn:uuid:3e671687-395b-41f5-a30f-a58921a69b79",
  "version": 1,
  "metadata": {
    "timestamp": "2025-11-25T10:30:00Z",
    "component": {
      "type": "application",
      "name": "patient-portal",
      "version": "2.1.0",
      "description": "HealthTech Solutions Patient Portal for Mayo Clinic"
    }
  },
  "components": [
    // ... 15 components (6 npm + 5 container + 4 Azure)
  ]
}
```

**[NARRATE]**:

> "Copilot generated:"
>
> - "Complete CycloneDX 1.5 structure"
> - "Unique serial number (urn:uuid)"
> - "Timestamp for when SBOM was created"
> - "Application metadata (Patient Portal v2.1.0)"
> - "All 15 components properly formatted"

### Step 2: Validate the SBOM

**[TYPE IN COPILOT CHAT]**:

```
How can I validate this SBOM is correct? Are there any required fields missing?
```

**[EXPECTED COPILOT RESPONSE]**:

**[NARRATE]**:

> "Copilot recommends using the CycloneDX online validator."

**[ACTION]**: Copy the JSON, open browser to https://sbomgenerator.com/tools/validator

**[PASTE JSON AND VALIDATE]**:

**[NARRATE RESULT]**:

> "✅ Validation passed! This is a near-production-ready CycloneDX 1.5 SBOM."

**[TEACHING MOMENT - TO AUDIENCE]**:

> "Sarah now knows **how to validate** SBOMs. She didn't just get a document - she learned the quality assurance process."

### Step 3: Generate Stakeholder Report

**[TYPE IN COPILOT CHAT]**:

```
Can you generate an HTML report from this SBOM that I can send to Mayo Clinic's
procurement team? Make it non-technical, showing component counts, license summary,
and risk assessment.
```

**[SHOW COPILOT GENERATING HTML - BRIEFLY]**:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Patient Portal SBOM - Mayo Clinic Procurement</title>
    <style>
      body {
        font-family: Arial;
        max-width: 1200px;
        margin: 0 auto;
      }
      .summary {
        background: #f0f0f0;
        padding: 20px;
      }
      .metric {
        display: inline-block;
        margin: 10px 20px;
      }
      table {
        border-collapse: collapse;
        width: 100%;
      }
      th,
      td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
      }
    </style>
  </head>
  <body>
    <h1>Software Bill of Materials</h1>
    <div class="summary">
      <h2>Summary</h2>
      <div class="metric"><strong>Total Components:</strong> 15</div>
      <div class="metric">
        <strong>Application Dependencies:</strong> 6 (npm)
      </div>
      <div class="metric">
        <strong>Container Components:</strong> 5 (Alpine Linux)
      </div>
      <div class="metric">
        <strong>Infrastructure Services:</strong> 4 (Azure)
      </div>
      <div class="metric">
        <strong>License Compliance:</strong> ✅ All Open Source (MIT, BSD)
      </div>
    </div>
    <!-- ... component table ... -->
  </body>
</html>
```

**[NARRATE]**:

> "Sarah can send this HTML report to Mayo Clinic's procurement team. They see:"
>
> - "15 total components clearly categorized"
> - "All licenses are permissive (MIT/BSD)"
> - "Security-critical components identified (OpenSSL)"
> - "Professional presentation"

---

## Phase 6: Wrap-Up & Knowledge Transfer (28-30 minutes)

### What Sarah Accomplished

**[NARRATE WITH ENTHUSIASM]**:

> "In **1 hour 15 minutes**, Sarah:"
>
> - "✅ Learned what an SBOM is and why Mayo Clinic needs it"
> - "✅ Understood PURL format across 3 ecosystems (npm, Alpine, Azure)"
> - "✅ Learned license compliance basics (MIT vs GPL)"
> - "✅ Discovered container base image importance (80% miss this)"
> - "✅ Created near-production-ready CycloneDX 1.5 SBOM (15 components, 98% accuracy)"
> - "✅ Generated stakeholder-friendly HTML report"
> - "✅ Validated output against industry standards"
>
> "**Most importantly**: Sarah can now explain to Mayo Clinic auditors exactly how she created this SBOM and what each component represents."

### Time Comparison

**[SHOW SLIDE OR SCREEN]**:

| Approach            | Time       | Outcome                                            |
| ------------------- | ---------- | -------------------------------------------------- |
| **Manual Research** | 6 hours    | 80% accuracy, exhausted, can't explain methodology |
| **With Copilot**    | 1.25 hours | 98% accuracy, confident, understands process       |
| **Next SBOM**       | 30 minutes | Knowledge retained, much faster                    |

**[NARRATE]**:

> "**79% time reduction** on first SBOM. But the real value is **knowledge transfer**:"
>
> - "Sarah's next SBOM will take 30 minutes (not 6 hours)"
> - "She can train other team members using the same approach"
> - "She can answer auditor questions confidently"
> - "She understands SBOMs (not just has one)"

### Time Savings

**[SHOW SLIDE OR SCREEN]**:

**First Year (10 apps, quarterly SBOMs = 40 total)**:

- Manual: 240 hours (6 hours × 40 SBOMs)
- With Copilot: 22 hours (1.25 hours first + 39 × 0.5 hours each)
- **Time Saved: 218 hours (91% reduction)**

**[NARRATE]**:

> "For a single security engineer managing 10 applications, that's **over 5 weeks of time** recovered annually—time that can be spent on proactive security improvements."

### Key Takeaways

**[SUMMARIZE FOR AUDIENCE]**:

> "This demo shows GitHub Copilot's unique value: **Teaching while delivering**."
>
> "Sarah didn't just get an SBOM. She learned:"
>
> - "SBOM fundamentals (CycloneDX, PURL, licenses)"
> - "Component discovery across layers (app, container, infrastructure)"
> - "Stakeholder communication (technical → non-technical)"
> - "Validation and quality assurance"
>
> "This knowledge is **reusable** - applies to any SBOM, any tool, any format."

### Natural Progression: Learning → Automation

**[OPTIONAL - IF TIME ALLOWS]**:

> "Once Sarah creates 2-3 SBOMs manually with Copilot, she'll recognize the repetition. Then she can ask Copilot to generate PowerShell automation scripts (see the `solution/` folder for examples)."
>
> "The progression is: **Learn → Manual → Automate → CI/CD**"
>
> "But you **must understand** SBOMs before automating them. Otherwise, you're blindly generating documents you can't explain or troubleshoot."

---

## Q&A Preparation

### Common Questions

**Q: "Can Copilot integrate with Syft or other SBOM tools?"**

A: "Yes! Once you understand SBOM concepts through this conversation approach, you can ask Copilot to generate scripts that call Syft, CycloneDX CLI, or other tools. The key is: Learn the concepts first, then automate. See the `solution/` folder for PowerShell automation examples."

**Q: "What if Copilot makes a mistake in the SBOM?"**

A: "This is why validation is built into the workflow. Sarah validated against CycloneDX schema. Also, because she **understands** SBOMs now (not just copying output), she can review and correct mistakes. Knowledge transfer provides quality assurance."

**Q: "How does this scale to 100+ applications?"**

A: "First 2-3 SBOMs: Conversation approach (learning). Next 10-20: Manual with Copilot (faster). After that: Build automation scripts with Copilot's help. By then, your team understands SBOMs deeply and can troubleshoot automation. The conversation approach is the **foundation** for scaling."

**Q: "Does this work for other ecosystems (Java, Python, .NET)?"**

A: "Absolutely! PURL format supports Maven, PyPI, NuGet, etc. The concepts are the same: dependencies, container, infrastructure. Copilot will teach the ecosystem-specific details (e.g., `pkg:maven/spring-boot` instead of `pkg:npm/express`)."

**Q: "What if Mayo Clinic asks for SPDX instead of CycloneDX?"**

A: "Sarah can ask Copilot: 'Can you convert this to SPDX 2.3 format?' Copilot will explain the differences and generate SPDX output. Because Sarah understands the underlying concepts (components, licenses, PURL), the format is just syntax."

**Q: "How much does GitHub Copilot cost?"**

A: "$10/month per user (Individual) or $19/month (Business). The ROI is 27,150% in the first year for a single engineer. This pays for itself in hours, not months."

---

## Backup Plans

### If Copilot Isn't Responding Well

1. **Restart VS Code**: Sometimes Copilot needs a fresh session
2. **Use the transcript**: Open `examples/copilot-sbom-conversation.md` and walk through Sarah's conversation
3. **Show pre-generated SBOM**: Use `examples/merged-sbom.json` and explain how it was created

### If Live Demo Fails Completely

1. **Screen recording**: Have a pre-recorded conversation session ready
2. **Slide deck**: Show screenshots from `examples/copilot-sbom-conversation.md` with narration
3. **Focus on outcomes**: Show the final SBOM and HTML report, explain the learning journey verbally

### If Running Short on Time

**15-minute version**:

- Intro (2 min)
- Phase 1: Problem Definition (3 min)
- Phase 2: Application Discovery (5 min) - show 1-2 npm packages, explain pattern
- Phase 5: Show final SBOM (3 min)
- Wrap-up (2 min)

**10-minute version**:

- Intro (2 min)
- Show conversation transcript (4 min) - walk through key teaching moments
- Show final SBOM + HTML report (2 min)
- Metrics and wrap-up (2 min)

---

## Post-Demo Follow-Up

### Share with Attendees

1. **This repository**: https://github.com/jonathan-vella/azure-agentic-infraops
2. **Direct link to S06**: `/scenarios/S06-sbom-generator/`
3. **Conversation example**: `examples/copilot-sbom-conversation.md`
4. **Prompts guide**: `prompts/effective-prompts.md`

### Encourage Hands-On

> "Try this yourself! Open VS Code with Copilot and ask: 'What is an SBOM and how do I create one?' See how Copilot teaches you."

### Related Demos

- **Demo 05 (S05)**: Troubleshooting Assistant - another conversation-based demo
- **Demo 01 (S01)**: Bicep Quickstart - infrastructure as code with Copilot
- **Demo 02 (S02)**: Agentic Workflow - multi-step agent workflow

---

## Presenter Notes

### Tone & Delivery

- **Empathetic**: "Sarah has never created an SBOM - many of you may be in the same position"
- **Educational**: Explain concepts as Copilot teaches Sarah (PURL, CycloneDX, licenses)
- **Enthusiastic**: Show excitement when Copilot provides great teaching moments
- **Honest**: Acknowledge when Copilot makes mistakes or when validation is needed

### Key Phrases to Use

- "Notice how Copilot **teaches** Sarah, not just gives her code"
- "This is **transferable knowledge** - Sarah can use this for any SBOM"
- "Sarah isn't just getting a document - she's **learning a skill**"
- "Next SBOM will take 30 minutes because Sarah **understands** the process"
- "This is why Copilot is an **efficiency multiplier** - speed + learning"

### Things to Avoid

- ❌ "Let me show you how to automate SBOMs" (wrong focus - this is about learning)
- ❌ "Copilot does all the work for you" (minimizes the learning aspect)
- ❌ "This replaces security engineers" (wrong message - it augments their capabilities)
- ❌ Technical jargon without explanation (explain PURL, CycloneDX, etc. as you go)

---

## Success Criteria

You've delivered this demo successfully if attendees:

- ✅ Understand that Copilot can **teach** concepts, not just generate code
- ✅ See the value of **knowledge transfer** (learning + deliverable)
- ✅ Recognize the **low barrier to entry** (no PowerShell/tooling expertise needed)
- ✅ Want to try the conversation approach themselves
- ✅ Understand the ROI (79% time savings + reusable skills)
- ✅ See the progression: Learn → Manual → Automate → Scale

**Ultimate Goal**: Attendees leave thinking "I could do this myself right now" (not "I need to hire a consultant").

---

## Appendix: Detailed Conversation Flow

For reference, here's the complete 5-phase conversation structure (see `examples/copilot-sbom-conversation.md` for full transcript):

### Phase 1: Problem Definition (10 min)

1. "What is an SBOM and why does Mayo Clinic need one?"
2. "What format should I use - CycloneDX or SPDX?"
3. "What components do I need to include?"
4. "Okay, let's start with application dependencies - how do I analyze package.json?"

### Phase 2: Application Dependencies (20 min)

5. "How should I format Express 4.18.2 in the SBOM? What fields are required?"
6. "What is PURL format?"
7. "How do I find license information for npm packages?"
8. "Does license type matter for healthcare applications?"
9. "Generate CycloneDX components for all 6 npm packages"

### Phase 3: Container Components (15 min)

10. "My Dockerfile uses node:20-alpine - do I include base image components?"
11. "What packages are in Alpine Linux that I should document?"
12. "Should I include OpenSSL?"
13. "Generate CycloneDX components for Alpine packages"

### Phase 4: Infrastructure (15 min)

14. "Do I document Azure services (App Service, Cosmos DB, Key Vault)?"
15. "How do I format Azure services as components?"
16. "What version information do I include for Azure services?"

### Phase 5: Assembly & Validation (15 min)

17. "Combine all 15 components into complete CycloneDX 1.5 SBOM"
18. "How do I validate this SBOM?"
19. "Generate HTML report for Mayo Clinic procurement team"

---

**Total Demo Time**: 30 minutes  
**Preparation Time**: 5 minutes  
**Follow-Up Time**: 5 minutes (Q&A)

**Good luck with your demo! 🚀**
