# Step 2: Architecture Assessment for Simple Web API

**Use this prompt with azure-principal-architect agent**

---

Review the requirements in `agent-output/simple-web-api/01-requirements.md` and create a comprehensive WAF assessment.

Generate architecture assessment content following the template at `.github/templates/02-architecture-assessment.template.md`

Note: After review, the content will be saved to `agent-output/simple-web-api/02-architecture-assessment.md`

Requirements:

1. Include all invariant H2 sections in the exact order specified in the template
2. Provide WAF scores for all 5 pillars (Security, Reliability, Performance, Cost, Operations)
3. Include cost estimates using Azure Pricing MCP tools
4. Recommend appropriate SKUs for each service
5. Document any trade-offs made

Template structure to follow:

- ## Requirements Validation ✅
- ## Executive Summary
- ## WAF Pillar Assessment
- ## Resource SKU Recommendations
- ## Architecture Decision Summary
- ## Implementation Handoff
- ## Approval Gate
