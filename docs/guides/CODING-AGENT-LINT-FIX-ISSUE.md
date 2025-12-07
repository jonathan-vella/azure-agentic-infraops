# GitHub Issue: Fix Remaining Markdown Lint Errors (MD013)

> **For GitHub Copilot Coding Agent** - Use this as the issue body
> when delegating to `#github-pull-request_copilot-coding-agent`

---

## Issue Title

Fix 301 MD013 line-length errors across 55 markdown files

## Issue Body

### Summary

Fix all remaining MD013 (line-length) violations in markdown files.
The line length limit is **120 characters** as configured in `.markdownlint.json`.

### Files to Fix (55 files, 301 errors)

Priority order (highest error count first):

| #   | File                                                                                   | Errors |
| --- | -------------------------------------------------------------------------------------- | ------ |
| 1   | `docs/audit-checklists/infradb-audit-checklist.md`                                     | 91     |
| 2   | `scenarios/S07-sbom-generator/DEMO-SCRIPT.md`                                          | 25     |
| 3   | `docs/presenter-toolkit/github-copilot-for-itpros.md`                                  | 25     |
| 4   | `scenarios/S07-sbom-generator/sample-app/README.md`                                    | 18     |
| 5   | `scenarios/S03-five-agent-workflow/solution/outputs/stage2-implementation-plan.md`     | 17     |
| 6   | `scenarios/S03-five-agent-workflow/DEMO-SCRIPT.md`                                     | 17     |
| 7   | `scenarios/S07-sbom-generator/examples/copilot-sbom-conversation.md`                   | 8      |
| 8   | `scenarios/S06-troubleshooting/DEMO-SCRIPT.md`                                         | 8      |
| 9   | `scenarios/S01-bicep-baseline/examples/copilot-bicep-conversation.md`                  | 7      |
| 10  | `scenarios/S07-sbom-generator/README.md`                                               | 5      |
| 11  | `scenarios/S04-ecommerce-platform/DEMO-SCRIPT.md`                                      | 5      |
| 12  | `scenarios/S04-documentation-generation/prompts/effective-prompts.md`                  | 4      |
| 13  | `scenarios/S03-five-agent-workflow/solution/outputs/stage1-architecture-assessment.md` | 4      |
| 14  | `scenarios/S07-sbom-generator/sample-app/src/web/README.md`                            | 3      |
| 15  | `scenarios/S07-sbom-generator/prompts/effective-prompts.md`                            | 3      |
| 16  | `scenarios/S06-troubleshooting/prompts/effective-prompts.md`                           | 3      |
| 17  | `scenarios/S05-service-validation/templates/deployment-sign-off.md`                    | 3      |
| 18  | `scenarios/S05-service-validation/templates/audit-evidence-package.md`                 | 3      |
| 19  | `.bicep-planning-files/INFRA.ecommerce-phase1-foundation.md`                           | 3      |
| 20  | `scenarios/S10-quick-demos/README.md`                                                  | 2      |
| 21  | `scenarios/S07-sbom-generator/solution/README.md`                                      | 2      |
| 22  | `scenarios/S05-service-validation/solution/scripts/DEPLOYMENT-NOTES.md`                | 2      |
| 23  | `scenarios/S05-service-validation/agents/loadtest-assistant.agent.md`                  | 2      |
| 24  | `scenarios/S04-documentation-generation/scenario/requirements.md`                      | 2      |
| 25  | `scenarios/S01-bicep-baseline/solution/time-tracking.md`                               | 2      |
| 26  | `scenarios/S01-bicep-baseline/scenario/requirements.md`                                | 2      |
| 27  | `infra/bicep/contoso-patient-portal/README.md`                                         | 2      |
| 28  | `docs/getting-started/README.md`                                                       | 2      |
| 29  | `docs/getting-started/model-selection.md`                                              | 2      |
| 30  | `docs/cost-estimates/README.md`                                                        | 2      |
| 31  | `.bicep-planning-files/INFRA.ecommerce-phase3-application.md`                          | 2      |
| 32  | `.bicep-planning-files/INFRA.ecommerce-phase2-platform.md`                             | 2      |
| 33  | `scenarios/scenario-output/ecommerce/ecommerce-cost-estimate.md`                       | 1      |
| 34  | `scenarios/scenario-output/ecommerce/00-plan.md`                                       | 1      |
| 35  | `scenarios/scenario-output/contoso-patient-portal/contoso-cost-estimate.md`            | 1      |
| 36  | `scenarios/scenario-output/contoso-patient-portal/01-azure-architect.md`               | 1      |
| 37  | `scenarios/S09-coding-agent/examples/issue-option-b-full.md`                           | 1      |
| 38  | `scenarios/S09-coding-agent/examples/issue-option-a-simple.md`                         | 1      |
| 39  | `scenarios/S07-sbom-generator/scenario/requirements.md`                                | 1      |
| 40  | `scenarios/S07-sbom-generator/scenario/architecture.md`                                | 1      |
| 41  | `scenarios/S06-troubleshooting/scenario/requirements.md`                               | 1      |
| 42  | `scenarios/S06-troubleshooting/scenario/incident-timeline.md`                          | 1      |
| 43  | `scenarios/S05-service-validation/validation/uat/README.md`                            | 1      |
| 44  | `scenarios/S05-service-validation/scenario/requirements.md`                            | 1      |
| 45  | `scenarios/S05-service-validation/examples/ci-cd-integration.md`                       | 1      |
| 46  | `scenarios/S04-ecommerce-platform/scenario/business-requirements.md`                   | 1      |
| 47  | `scenarios/S03-five-agent-workflow/solution/templates/README.md`                       | 1      |
| 48  | `scenarios/S03-five-agent-workflow/prompts/workflow-prompts.md`                        | 1      |
| 49  | `scenarios/S02-terraform-baseline/scenario/requirements.md`                            | 1      |
| 50  | `scenarios/S02-terraform-baseline/scenario/architecture.md`                            | 1      |
| 51  | `scenarios/S01-bicep-baseline/scenario/architecture.md`                                | 1      |
| 52  | `scenarios/S01-bicep-baseline/scenario/architecture-as-code.md`                        | 1      |
| 53  | `docs/audit-checklists/README.md`                                                      | 1      |
| 54  | `docs/adr/README.md`                                                                   | 1      |
| 55  | `.bicep-planning-files/INFRA.ecommerce-phase4-edge-monitoring.md`                      | 1      |

### Fix Instructions

#### Standard Line Breaking

For regular prose text exceeding 120 characters:

1. Break at natural clause boundaries (after commas, semicolons, conjunctions)
2. Break after prepositions when logical
3. Keep related phrases together
4. Maintain markdown formatting

**Example:**

```markdown
<!-- BEFORE (too long) -->

This is a very long line that exceeds the 120 character limit and needs to be broken into multiple lines for better readability.

<!-- AFTER -->

This is a very long line that exceeds the 120 character limit
and needs to be broken into multiple lines for better readability.
```

#### Special Cases - Use Disable Comments

For content that **cannot** be broken without breaking functionality:

**1. Mermaid Diagrams:**

````markdown
<!-- markdownlint-disable MD013 -->

```mermaid
graph LR
    A[Very Long Node Name That Describes Something Important] --> B[Another Very Long Node Name]
```
````

<!-- markdownlint-enable MD013 -->

````

**2. Badge Images:**

```markdown
<!-- markdownlint-disable MD013 -->
[![Build Status](https://github.com/org/repo/actions/workflows/ci.yml/badge.svg)](https://github.com/org/repo/actions)
<!-- markdownlint-enable MD013 -->
````

**3. Long URLs in text:**

```markdown
For more information, see the
[Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/).
```

**4. Code blocks with long lines:**
Code blocks are typically excluded by the linter configuration,
but if flagged, use disable comments around the block.

**5. Tables with long content:**
Tables often have long lines - wrap disable comments around them if needed:

```markdown
<!-- markdownlint-disable MD013 -->

| Column 1 | Very Long Column Header That Describes Something    | Another Long Header |
| -------- | --------------------------------------------------- | ------------------- |
| data     | This cell has very long content that exceeds limits | more data here      |

<!-- markdownlint-enable MD013 -->
```

### Validation Command

After fixing, run:

```bash
npx markdownlint-cli2
```

Expected result: `Summary: 0 error(s)`

### Configuration Reference

The line length is configured in `.markdownlint.json`:

```json
{
  "MD013": {
    "line_length": 120,
    "code_blocks": false,
    "tables": false
  }
}
```

### Acceptance Criteria

- [ ] All 55 files pass markdownlint with 0 errors
- [ ] No broken markdown formatting (links, tables, lists intact)
- [ ] Mermaid diagrams render correctly
- [ ] All badge images display correctly
- [ ] No content meaning is lost in line breaks

---

## Quick Start Prompt for Coding Agent

```
Fix all MD013 line-length (>120 chars) errors in the 55 markdown files listed in
docs/guides/CODING-AGENT-LINT-FIX-ISSUE.md

For each file:
1. Run: npx markdownlint-cli2 <filepath>
2. Fix lines exceeding 120 characters by breaking at natural clause boundaries
3. Use <!-- markdownlint-disable MD013 --> for Mermaid diagrams, badge images, and tables that can't be broken
4. Verify fix: npx markdownlint-cli2 <filepath> shows 0 errors

Start with the highest error-count files first.
Validate with: npx markdownlint-cli2 (should show 0 errors at the end)
```
