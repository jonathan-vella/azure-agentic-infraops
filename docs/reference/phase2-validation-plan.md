# Plan: Phase 2 Template Validation via New Minimal Scenario

**Goal**: Validate Wave 1 templates by generating a complete set of artifacts (01, 02, 04, 06)
for a simple, greenfield Azure project. This proves template stability without the complexity of
regenerating an existing demo.

## Project Scope: "Simple Web API"

**Minimalist requirements to test template conformance:**

- Static web frontend (Azure Static Web Apps - Free tier)
- Backend API (Azure Functions - Consumption)
- Data store (Azure Cosmos DB - Serverless)
- Monitoring (Application Insights)
- Region: swedencentral
- Budget: $100/month
- No compliance requirements (simplifies assessment)

**Why this scope:**

- Touches all 4 Wave 1 artifacts
- Simple enough to complete in 30-45 minutes
- Tests template structure without excessive content complexity
- Creates golden example in `agent-output/simple-web-api/`

## Execution Steps

### Step 1: Use @plan to Generate 01-requirements.md (10 min)

**Prompt for @plan:**

```
Create requirements for a simple web API project:
- Static web frontend hosted on Azure Static Web Apps (Free tier)
- Backend REST API using Azure Functions (Consumption plan)
- Data persistence with Azure Cosmos DB (Serverless, <100 requests/sec)
- Application monitoring with Application Insights
- Region: swedencentral
- Budget constraint: $100/month
- No special compliance requirements
- Expected load: 10 concurrent users, 1000 requests/day
- SLA target: 99.9%

Save the requirements to agent-output/simple-web-api/01-requirements.md following the template at .github/templates/01-requirements.template.md
```

**Validation:**

- Check 01-requirements.md has all invariant H2 sections
- Run `npm run lint:wave1-artifacts`
- Verify no drift warnings

### Step 2: Use azure-principal-architect for 02-architecture-assessment.md (15 min)

**Prompt:**

```
Review the requirements in agent-output/simple-web-api/01-requirements.md and create a WAF assessment.
Generate 02-architecture-assessment.md following the template structure.
Include cost estimates using Azure Pricing MCP.
Also save 01-requirements.md to the project folder if not already present.
```

**Validation:**

- Check 02-architecture-assessment.md has all invariant H2 sections in order
- Verify WAF pillar assessment present
- Run `npm run lint:wave1-artifacts`
- Verify no drift warnings

### Step 3: Use bicep-plan for 04-implementation-plan.md (15 min)

**Prompt:**

```
Based on agent-output/simple-web-api/02-architecture-assessment.md,
create a Bicep implementation plan.
Generate 04-implementation-plan.md following the template structure.
Include resource inventory, module structure, and implementation tasks.
```

**Validation:**

- Check 04-implementation-plan.md has all invariant H2 sections in order
- Verify resource inventory and tasks present
- Run `npm run lint:wave1-artifacts`
- Verify no drift warnings

### Step 4: Simulate 06-deployment-summary.md (5 min)

**Manual creation or prompt:**

```
Create a simulated deployment summary at agent-output/simple-web-api/06-deployment-summary.md
following the template structure. Mark status as "SIMULATED" since we're not actually deploying.
```

**Validation:**

- Check 06-deployment-summary.md has all invariant H2 sections in order
- Run `npm run lint:wave1-artifacts`
- Verify no drift warnings

### Step 5: Final Validation (5 min)

**Commands:**

```bash
npm run lint:wave1-artifacts
npm run lint:md -- agent-output/simple-web-api/*.md
```

**Success Criteria:**

- ✅ All 4 Wave 1 artifacts present
- ✅ No drift warnings from validator
- ✅ No markdown lint errors
- ✅ All invariant H2 sections in correct order

## Outcome

If all validations pass:

- ✅ Phase 2 complete
- Ready for Phase 3 (repeat with second scenario or regenerate S03)
- Can consider ratcheting to `standard` strictness after Phase 3

If any warnings/failures:

- Document issues
- Fix templates or validator as needed
- Re-validate

## Estimated Time

- Setup + Step 1: 10 min
- Step 2: 15 min
- Step 3: 15 min
- Step 4: 5 min
- Step 5: 5 min
- **Total: ~50 minutes**

## Alternative: Skip to S03 Regeneration?

If you prefer to test with full complexity immediately:

- Use S03 prompts in `scenarios/S03-agentic-workflow/prompts/`
- Regenerate all artifacts to new folder `agent-output/contoso-patient-portal-v2/`
- Compare against existing implementation
- Estimate: 2-3 hours full workflow

**Recommendation: Start with minimal validation (this plan), then tackle S03 for Phase 3.**
