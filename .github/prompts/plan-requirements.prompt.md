---
description: "Gather Azure workload requirements through structured interview"
agent: "Requirements"
model: "Claude Opus 4.5"
tools:
  - edit/createFile
  - edit/editFiles
---

# Plan Requirements

Conduct a structured requirements gathering session for a new Azure workload.
Guide the user through all necessary NFR categories and produce a complete
`01-requirements.md` artifact.

## Mission

Interview the user to capture comprehensive Azure workload requirements,
ensuring all critical non-functional requirements (NFRs) are addressed before
proceeding to architecture assessment.

## Scope & Preconditions

- User has a project concept but may not have documented requirements
- Output will be saved to `agent-output/${input:projectName}/01-requirements.md`
- Follow the template structure from `.github/templates/01-requirements.template.md`

## Inputs

| Variable               | Description                             | Default  |
| ---------------------- | --------------------------------------- | -------- |
| `${input:projectName}` | Project name (kebab-case)               | Required |
| `${input:projectType}` | Web App, API, Data Platform, IoT, AI/ML | Web App  |

## Workflow

### Step 1: Project Context

Ask the user to describe:

1. **Project name** (lowercase, alphanumeric, hyphens only)
2. **Business problem** this workload solves
3. **Target environment** (dev, staging, prod, or all)
4. **Timeline** (target go-live date)

### Step 2: Functional Requirements

Gather information about:

1. **Core capabilities** - What must this workload do?
2. **User types and load** - Who uses it and how many?
3. **Integration requirements** - What systems must it connect to?
4. **Data requirements** - Volume, retention, sensitivity

### Step 3: Non-Functional Requirements (NFRs)

For each category, prompt the user if not provided:

| Category         | Key Questions                                                  |
| ---------------- | -------------------------------------------------------------- |
| **Availability** | SLA target? RTO? RPO? Maintenance window?                      |
| **Performance**  | Response time target? Throughput? Concurrent users?            |
| **Scalability**  | Current vs. 12-month projection for users, data, transactions? |

### Step 4: Compliance & Security

Identify applicable requirements:

- **Regulatory**: HIPAA, PCI-DSS, GDPR, SOC 2, ISO 27001, FedRAMP, NIST
- **Data residency**: Primary region, sovereignty requirements
- **Security controls**: Authentication, encryption, network isolation

### Step 5: Budget

Capture the user's budget (approximate is fine):

- Monthly budget (e.g., ~$50/month)
- Annual budget (optional)
- One-time setup budget (optional)

> The Azure Pricing MCP server will generate detailed cost estimates during
> architecture assessment (Step 2).

### Step 6: Operational Requirements

Document operational needs:

- Monitoring and observability approach
- Support model (24/7, business hours, best effort)
- Backup and DR strategy

### Step 7: Regional Preferences

Confirm deployment regions:

- **Primary**: `swedencentral` (default - sustainable, GDPR-compliant)
- **Secondary**: `germanywestcentral` (for quota or DR)
- Override reasons if not using defaults

## Output Expectations

Generate `agent-output/{projectName}/01-requirements.md` with:

1. All sections from the template populated
2. Clear ✅/⚠️/❌ indicators for requirement completeness
3. Summary section ready for architecture assessment handoff

### File Structure

```text
agent-output/{projectName}/
├── 01-requirements.md    # Generated requirements document
└── README.md             # Project folder README
```

## Quality Assurance

Before completing, verify:

- [ ] Project name follows naming convention
- [ ] At least one functional requirement defined
- [ ] SLA/RTO/RPO specified (or explicitly marked N/A)
- [ ] Compliance requirements identified
- [ ] Budget provided (approximate OK - MCP generates estimates)
- [ ] Primary region confirmed

## Next Steps

After requirements are captured and approved:

1. User invokes `@architect` for architecture assessment
2. Architecture agent validates requirements and produces WAF assessment
3. Workflow continues through remaining 5 steps
---
