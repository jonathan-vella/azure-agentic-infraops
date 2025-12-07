# S05: Documentation Generation - Learning Documentation Automation with Copilot

---

## Meet Priya Sharma

> **Role**: Senior Technical Writer at CloudDocs Solutions  
> **Experience**: 8 years technical writing (API docs, user guides, system documentation)  
> **Today's Challenge**: Document 50-server Azure migration in 1 week (normally 3 weeks)  
> **The Twist**: Wants to understand WHY automation works, not just copy-paste scripts

*"I've written documentation for dozens of migrations. But each one takes 20+ hours of manual work—
interviewing engineers, drawing diagrams, formatting runbooks. There has to be a smarter way."*

**What Priya will discover**: How to transform Azure resource data into professional documentation
using conversation patterns, reducing 20+ hours to 90 minutes while understanding the WHY.

---

## Overview

This scenario teaches **documentation automation patterns** through a discovery-based conversation
with GitHub Copilot. Instead of just running scripts, you'll learn WHY certain approaches work
for generating architecture docs, runbooks, troubleshooting guides, and API documentation.

**Learning Focus:** Understanding how to transform Azure resource data into professional
documentation using prompts, not just executing pre-built scripts.

## Scenario

**Client:** TechCorp Solutions (mid-market MSP)  
**Project:** Document 50-server Azure migration for customer handoff  
**Deliverables:**
- Architecture documentation with diagrams
- Day 2 operations guide
- Troubleshooting playbooks
- API documentation

**Timeline:** 1 week (normally 3 weeks manually)

## Learning Objectives

By working through this scenario, you'll understand:

1. **Resource Graph Patterns** - Why KQL queries are better than CLI for documentation
2. **Data-to-Documentation Flow** - How structured data becomes narrative
3. **Mermaid Diagrams** - Why "diagrams as code" enables automation
4. **Prompt Engineering** - How to structure prompts for quality output
5. **The 90/10 Rule** - What to automate vs. what needs human judgment

## Time Investment

| Phase | Duration | Focus |
|-------|----------|-------|
| Understanding Patterns | 15 min | Why automation works |
| Building Queries | 15 min | Resource Graph fundamentals |
| Generating Documentation | 45 min | Prompt-based generation |
| Review & Polish | 15 min | Human quality control |
| **Total** | **90 min** | **vs. 20+ hours manual** |

## Quick Start

### Option 1: Learn Through Conversation (Recommended)

Follow the conversation transcript to understand documentation automation:

```bash
# Open the learning conversation
code examples/copilot-documentation-conversation.md
```

Work through each phase, asking Copilot the discovery questions and understanding
WHY each pattern works before using the scripts.

### Option 2: Run the Demo

If you need quick results for a presentation:

```powershell
# Connect to Azure
Connect-AzAccount
Set-AzContext -Subscription "Your-Subscription"

# Generate architecture documentation prompt
./solution/ArchitectureDoc.ps1 -ResourceGroupName "rg-prod" -OutputPath "./output"

# Copy generated prompt to Copilot Chat
code ./output/architecture-prompt.txt
```

## Learning Path

### Phase 1: Understanding Documentation Automation (15 min)

**Key Discovery Questions:**

```
Ask Copilot:
- Why is Azure Resource Graph better than CLI for documentation?
- How do I discover what properties are available for each resource type?
- Why generate prompts instead of final documentation directly?
```

**Key Insight:** Documentation automation transforms structured data into narrative—it doesn't
write from nothing.

### Phase 2: From Data to Documentation (15 min)

**The Transformation Pattern:**

```
Azure Resources → Resource Graph Query → Structured Data → Copilot Prompt → Documentation
```

**Key Discovery Questions:**

```
Ask Copilot:
- What resource properties are most important for documentation?
- How do I identify security-relevant configurations?
- How do I find resource relationships for diagrams?
```

### Phase 3: Diagram Automation with Mermaid (15 min)

**Why Mermaid Over Visio:**

| Factor | Visio | Mermaid |
|--------|-------|---------|
| Version control | Binary, can't diff | Text, full Git history |
| Automation | Manual only | Generate from data |
| Update time | Re-draw | Edit text |
| Cost | License required | Free |

**Key Discovery Questions:**

```
Ask Copilot:
- What diagram type should I use for architecture vs. network vs. workflows?
- How do I generate Mermaid syntax from Resource Graph data?
- What are common Mermaid syntax errors and how to avoid them?
```

### Phase 4: Building Documentation Types (45 min)

Work through each documentation type:

1. **Architecture Documentation** - What exists and why
2. **Day 2 Operations Guide** - How to keep it running
3. **Troubleshooting Guide** - What to do when things break
4. **API Documentation** - How to integrate

For each type, understand:
- What data sources are needed
- What the prompt structure looks like
- What human review is required

## Directory Structure

```
S04-documentation-generation/
├── README.md                      # This file
├── DEMO-SCRIPT.md                 # 30-minute presenter guide
├── examples/
│   └── copilot-documentation-conversation.md  # Full learning conversation
├── prompts/
│   └── effective-prompts.md       # Prompt patterns by documentation type
├── scenario/
│   ├── requirements.md            # TechCorp documentation requirements
│   └── sample-infrastructure.bicep # Example infrastructure to document
├── solution/
│   ├── README.md                  # Script usage guide
│   ├── ArchitectureDoc.ps1        # Architecture documentation generator
│   ├── Day2OperationsGuide.ps1    # Operations guide generator
│   ├── TroubleshootingGuide.ps1   # Troubleshooting guide generator
│   ├── APIDocumentation.ps1       # API documentation generator
│   └── output/                    # Generated prompt examples
└── validation/
    └── verify-documentation.ps1   # Validation script
```

## Key Patterns Learned

### Pattern 1: Resource Discovery → Documentation

```powershell
# Query Azure for documentation data
$resources = Search-AzGraph -Query @"
Resources
| where resourceGroup == 'rg-prod'
| project name, type, location, sku = sku.name, properties
"@

# Transform to documentation prompt
$prompt = Build-DocumentationPrompt -Resources $resources -Template "architecture"

# Generate with Copilot (human step)
# Paste prompt → Copilot generates → Human reviews
```

### Pattern 2: Mermaid Diagram Generation

```powershell
# Query network topology
$networks = Search-AzGraph -Query @"
Resources
| where type == 'microsoft.network/virtualnetworks'
| mv-expand subnet = properties.subnets
| project vnetName = name, subnetName = subnet.name, prefix = subnet.properties.addressPrefix
"@

# Generate Mermaid syntax
$mermaid = @"
graph TB
    subgraph VNet[$($networks[0].vnetName)]
        $(foreach ($subnet in $networks) { "        $($subnet.subnetName)[$($subnet.prefix)]" })
    end
"@
```

### Pattern 3: The Prompt Template

```
# Documentation Request

Generate [documentation type] for the following Azure environment.

## Environment Data
[Structured data from Resource Graph]

## Documentation Requirements
[Specific sections and format requirements]

## Output Format
- Use Markdown with proper headings
- Include Mermaid diagrams
- Add status indicators (✅ ❌ ⚠️)
```

## Discovery Questions Reference

### Understanding Tools

| Question | Why Ask It |
|----------|------------|
| Why Resource Graph over CLI? | Understand data collection patterns |
| Why prompts instead of direct generation? | Understand quality control workflow |
| Why Mermaid over Visio? | Understand diagram automation |

### Understanding Data

| Question | Why Ask It |
|----------|------------|
| What properties matter for documentation? | Focus data collection |
| How to find resource relationships? | Enable diagram generation |
| What indicates security configuration? | Include compliance information |

### Understanding Output

| Question | Why Ask It |
|----------|------------|
| Who is the audience? | Tailor detail level |
| How will docs be maintained? | Design for updates |
| What needs human review? | Know automation limits |

## Success Metrics

### Learning Success

- [ ] Can explain why Resource Graph is preferred for documentation
- [ ] Can write basic KQL queries for resource inventory
- [ ] Understand the prompt → generate → review workflow
- [ ] Can generate Mermaid diagrams from resource data
- [ ] Know what requires human judgment vs. automation

### Efficiency Success

| Metric | Manual | With Copilot | Target |
|--------|--------|--------------|--------|
| Architecture doc | 6 hours | 45 min | 87% reduction |
| Operations guide | 8 hours | 55 min | 88% reduction |
| Troubleshooting guide | 5 hours | 45 min | 85% reduction |
| API documentation | 4 hours | 40 min | 83% reduction |

## Common Questions

**Q: Why don't the scripts generate final documentation directly?**

A: The scripts generate prompts because:
1. You can customize before generation
2. You see exactly what Copilot receives
3. You learn prompt engineering
4. Quality is higher with human-in-the-loop

**Q: How accurate is the generated documentation?**

A: Data from Azure is 100% accurate. Copilot's interpretation is ~95% accurate.
The 30-minute review phase catches the remaining issues.

**Q: Can I use this for compliance documentation?**

A: Yes, with appropriate review. The scripts can include compliance-relevant
properties (encryption, access controls). Add compliance-specific requirements
to the prompt template for your organization.

**Q: What if I don't have Azure resources to document?**

A: Use the sample infrastructure in `scenario/sample-infrastructure.bicep` to deploy
test resources, or work through the conversation transcript without live Azure access.

## Next Steps

1. **Start Learning:** Open `examples/copilot-documentation-conversation.md`
2. **Try the Scripts:** Run against your Azure environment
3. **Customize Templates:** Adapt prompts to your organization's standards
4. **Build Automation:** Integrate into CI/CD for automatic doc updates
5. **Share Knowledge:** Train your team on the patterns

## Related Scenarios

- **S01-bicep-baseline:** Infrastructure to document
- **S02-terraform-baseline:** Alternative IaC to document
- **S03-five-agent-workflow:** Multi-agent approach for complex projects
- **S06-troubleshooting:** Generate troubleshooting docs from real issues

---

**Scenario Mission:** Transform documentation from a 20-hour manual chore into a 90-minute
automated workflow while understanding WHY each pattern works—not just copying scripts.
