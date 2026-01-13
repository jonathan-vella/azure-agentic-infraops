# Simple Web API - Phase 2 Template Validation

**Purpose**: Validate Wave 1 artifact templates with a minimal greenfield project.

**Status**: 🔄 In Progress

## Project Overview

A simple web API demonstrating Azure Static Web Apps, Functions, and Cosmos DB integration.

**Budget**: $100/month  
**Region**: swedencentral  
**Compliance**: None (simplifies testing)

## Artifacts

| Artifact                      | Status         | Notes                         |
| ----------------------------- | -------------- | ----------------------------- |
| 01-requirements.md            | 🔄 Pending     | Generated via @plan           |
| 02-architecture-assessment.md | ⏸️ Not started | Via azure-principal-architect |
| 04-implementation-plan.md     | ⏸️ Not started | Via bicep-plan                |
| 06-deployment-summary.md      | ⏸️ Not started | Manual/simulated              |

## Validation Results

Run after each artifact is generated:

```bash
npm run lint:wave1-artifacts
npm run lint:md -- agent-output/simple-web-api/*.md
```

**Expected**: ✅ No drift warnings, all invariant H2 sections present

---

_Phase 2 validation for Wave 1 templatization system_
