# Plan: Project-Wide Improvements

**TL;DR**: Improve the GitHub Copilot demo repository beyond the MCP server - add CI/CD validation, more demo scenarios, and better documentation.

> **Note**: The empty `infra/bicep/` folder will be addressed separately after this plan is complete.

## Steps

### 1. Add GitHub Actions CI workflow

**File**: `.github/workflows/validate.yml`

Jobs to include:

- **validate-bicep**: Run `bicep build` on all `.bicep` files
- **lint-markdown**: Run `markdownlint-cli2` on all `.md` files
- **validate-agents**: Check YAML frontmatter in `*.agent.md` files
- **test-mcp-server**: Run `pytest` on `mcp/azure-pricing-mcp/tests/`
- **check-links**: Validate internal markdown links aren't broken

### 2. Centralize agent shared configuration

**File**: `.github/agents/_shared/defaults.md`

Extract duplicated content from agents:

- Default region: `swedencentral`
- Alternative region: `germanywestcentral`
- Required tags: Environment, ManagedBy, Project, Owner
- AVM registry reference: `br/public:avm/res/*`
- CAF naming patterns
- WAF pillar definitions

Update agents to reference shared config instead of duplicating.

### 3. Add more demo scenarios

**File**: `scenarios/scenario-prompts.md` (add sections)

| Scenario                 | Complexity | Key Services                                  | New File                    |
| ------------------------ | ---------- | --------------------------------------------- | --------------------------- |
| Healthcare HIPAA Portal  | High       | App Service, SQL, FHIR API, Private Endpoints | `scenarios/healthcare-demo.md`  |
| Data Analytics Platform  | Medium     | Synapse, Data Lake Gen2, Databricks           | `scenarios/analytics-demo.md`   |
| Static Marketing Website | Low        | Static Web App, CDN, Storage                  | `scenarios/static-site-demo.md` |

### 4. Create project ADRs

**Location**: `docs/adr/`

| ADR                                  | Title                          | Purpose                                      |
| ------------------------------------ | ------------------------------ | -------------------------------------------- |
| `ADR-001-agent-workflow-design.md`   | Agent Workflow Architecture    | Why 4-step workflow with approval gates      |
| `ADR-002-mcp-pricing-integration.md` | Azure Pricing MCP Server       | Why custom MCP server vs built-in tools      |
| `ADR-003-avm-first-approach.md`      | Azure Verified Modules Mandate | Why AVM modules are preferred over raw Bicep |
| `ADR-004-region-defaults.md`         | Default Region Selection       | Why swedencentral as default                 |

### 5. Add CHANGELOG.md

**File**: `CHANGELOG.md`

Track changes by version (complement VERSION.md):

- Breaking changes
- New features
- Bug fixes
- Documentation updates

### 6. Add demo regeneration script

**File**: `scripts/regenerate-demos.ps1`

Script to:

- Clear `scenario-output/` folder
- Run each demo prompt through agents
- Capture outputs to markdown files
- Validate generated Bicep compiles

### 7. Update AVM versions in agent instructions

**Files**: `.github/agents/bicep-*.agent.md`

- Query latest AVM versions from GitHub API
- Update version references in agent instructions
- Add note about checking for updates

### 8. Add animated demo to README

**File**: `README.md`

- Record terminal session with `asciinema` or screen recording
- Convert to GIF or embed video
- Show complete workflow from `@plan` to Bicep output

### 9. Create quick-start guide

**File**: `docs/QUICKSTART.md`

Simplified guide for first-time users:

- 5-minute setup
- Single simple prompt example
- Link to full WORKFLOW.md for details

---

## Further Considerations

1. **How many demo scenarios?** Start with 3-4 diverse scenarios covering different complexity levels → **Add 3 new scenarios**

2. **CI on every PR or just main?** → **Both**: lint on PRs, full validation on main

3. **ADR format?** Use standard MADR template → **Yes, use MADR**

---

## Files to Create/Modify

| File                                          | Action                | Priority |
| --------------------------------------------- | --------------------- | -------- |
| `.github/workflows/validate.yml`              | Create                | High     |
| `docs/adr/ADR-001-agent-workflow-design.md`   | Create                | Medium   |
| `docs/adr/ADR-002-mcp-pricing-integration.md` | Create                | Medium   |
| `scenarios/healthcare-demo.md`                    | Create                | Medium   |
| `scenarios/analytics-demo.md`                     | Create                | Medium   |
| `CHANGELOG.md`                                | Create                | Medium   |
| `.github/agents/_shared/defaults.md`          | Create                | Low      |
| `docs/QUICKSTART.md`                          | Create                | Low      |
| `scripts/regenerate-demos.ps1`                | Create                | Low      |
| `README.md`                                   | Update (add demo GIF) | Low      |

---

## Estimated Effort

| Priority | Steps      | Effort   |
| -------- | ---------- | -------- |
| High     | 1          | ~2 hours |
| Medium   | 2, 3, 4, 5 | ~4 hours |
| Low      | 6, 7, 8, 9 | ~3 hours |

**Total**: ~9 hours
