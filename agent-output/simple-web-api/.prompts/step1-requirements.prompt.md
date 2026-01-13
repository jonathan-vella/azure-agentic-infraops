# Step 1: Requirements for Simple Web API

**Use this prompt with @plan agent in VS Code Chat**

---

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
- RTO: 4 hours
- RPO: 1 hour

Generate requirements content following the template structure at `.github/templates/01-requirements.template.md`

Note: @plan will provide the content. After review, I'll save it to `agent-output/simple-web-api/01-requirements.md`

Ensure all invariant H2 sections are included in the correct order:

- ## Project Overview
- ## Functional Requirements
- ## Non-Functional Requirements (NFRs)
- ## Compliance & Security Requirements
- ## Cost Constraints
- ## Operational Requirements
- ## Regional Preferences
