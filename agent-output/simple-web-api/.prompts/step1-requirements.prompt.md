# Step 1: Requirements for Simple Web API

**Use this prompt with project-planner agent in VS Code Chat**

---

Create requirements for a simple web API project with these specifications:

**Architecture Components:**
- Static web frontend hosted on Azure Static Web Apps (Free tier)
- Backend REST API using Azure Functions (Consumption plan)
- Data persistence with Azure Cosmos DB (Serverless, <100 requests/sec)
- Application monitoring with Application Insights

**Constraints:**
- Region: swedencentral
- Budget: $100/month
- No special compliance requirements
- Expected load: 10 concurrent users, 1000 requests/day
- SLA target: 99.9%
- RTO: 4 hours, RPO: 1 hour

**Output:**
Generate complete requirements following template structure at
`.github/templates/01-requirements.template.md`. After approval, save to
`agent-output/simple-web-api/01-requirements.md`

**Workflow:**
1. Agent researches template structure and constraints
2. Agent generates draft requirements document
3. User reviews and provides feedback (iterate as needed)
4. User approves final version
5. Agent creates `01-requirements.md` file in correct location
