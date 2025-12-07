# S05: Service Validation - Learning AI-Assisted Testing with Copilot

---

## Meet Marcus Chen

> **Role**: QA Engineer at HealthTech Systems  
> **Experience**: 6 years manual testing (functional testing, test case design, bug tracking)  
> **Today's Challenge**: Validate HIPAA-compliant API deployment with UAT and load testing  
> **The Twist**: Manual validation takes 25+ hours, delaying every release

_"I know how to write test cases and find bugs. But I spend more time setting up tests than
actually testing. I want to understand what makes GOOD testing, not just pass the checkbox."_

**What Marcus will discover**: How to use AI agents as testing partners that help him understand
WHY certain patterns work, reducing 25+ hours of validation to 75 minutes.

---

## Overview

This scenario teaches **service validation patterns** through discovery-based dialogue with
GitHub Copilot agents. Instead of just running test scripts, you'll learn WHY certain testing
approaches work for UAT and load testing of deployed Azure applications.

**Learning Focus:** Understanding what makes good acceptance criteria, how to interpret
performance metrics, and when to use different testing patterns—not just executing tests.

## Scenario

**Application:** SAIF (Secure AI Framework) API v2  
**Stack:** Python FastAPI + Azure SQL Database + Managed Identity  
**Compliance:** HIPAA-sensitive healthcare data  
**Validation Required:**

- User Acceptance Testing (functional correctness)
- Load Testing (performance under pressure)
- Audit-ready documentation

## Learning Objectives

By working through this scenario, you'll understand:

1. **UAT vs. Load Testing** - What each validates and when to use them
2. **Acceptance Criteria** - What makes criteria SMART and testable
3. **Performance Metrics** - Why p95 matters more than average
4. **Load Patterns** - When to use ramp-up vs. spike vs. sustained
5. **Bottleneck Analysis** - How to identify and resolve performance issues
6. **Agent Workflow** - How discovery questions lead to better testing

## Time Investment

| Phase                  | Duration      | Focus                               |
| ---------------------- | ------------- | ----------------------------------- |
| Understanding Patterns | 15 min        | UAT vs. Load, acceptance criteria   |
| UAT Testing            | 15-20 min     | Functional validation with agent    |
| Load Testing           | 20-30 min     | Performance validation with agent   |
| Analysis & Reporting   | 10 min        | Interpret results, generate reports |
| **Total**              | **60-75 min** | **vs. 25+ hours manual**            |

## Quick Start

### Option 1: Learn Through Conversation (Recommended)

Follow the conversation transcript to understand validation patterns:

```bash
# Open the learning conversation
code examples/copilot-validation-conversation.md
```

Work through each phase, understanding WHY before running the agents.

### Option 2: Run the Demo

If you need quick results for a presentation:

```powershell
# 1. Verify service is deployed
curl https://app-saifv2-api-ss4xs2.azurewebsites.net/

# 2. Run UAT with agent
# In Copilot Chat:
@uat-assistant I need to test my SAIF API

# 3. Run Load Test with agent
@loadtest-assistant I need to load test my API
```

## Learning Path

### Phase 1: Understanding Service Validation (15 min)

**Key Discovery Questions:**

```
Ask Copilot:
- What's the difference between UAT and load testing?
- What makes good acceptance criteria? (SMART pattern)
- Why do issues only appear under load?
```

**Key Insight:** UAT validates correctness; load testing validates correctness UNDER PRESSURE.

### Phase 2: UAT Testing with Agent (15-20 min)

**The UAT Workflow:**

```
Discovery → Test Planning → Execution → Analysis → Documentation
    │            │             │           │            │
 You provide   Agent      You run     Agent       Agent
 domain      generates   tests or   analyzes    generates
 knowledge    plan       scripts    results     report
```

**Key Discovery Questions:**

```
Ask the UAT Assistant:
- Why is this endpoint critical to test?
- What failure modes should I look for?
- How do I know I've tested enough?
```

### Phase 3: Load Testing with Agent (20-30 min)

**Understanding Performance Metrics:**

| Metric     | What It Means           | Why It Matters       |
| ---------- | ----------------------- | -------------------- |
| RPS        | Requests per second     | Throughput capacity  |
| p95        | 95th percentile latency | Real user experience |
| Error Rate | Failed requests         | Reliability          |

**Key Discovery Questions:**

```
Ask the Load Test Assistant:
- Why p95 instead of average response time?
- What load pattern should I use for my scenario?
- How do I identify bottlenecks from metrics?
```

### Phase 4: Analysis and Reporting (10 min)

**Understanding Results:**

- Green metrics ≠ production ready (understand the WHY)
- Bottleneck analysis reveals root causes
- Recommendations should include cost impact

## Directory Structure

```
S06-service-validation/
├── README.md                      # This file
├── DEMO-SCRIPT.md                 # 30-45 minute presenter guide
├── agents/
│   ├── uat-assistant.agent.md     # UAT testing workflow agent
│   └── loadtest-assistant.agent.md # Performance testing agent
├── examples/
│   └── copilot-validation-conversation.md  # Full learning conversation
├── prompts/
│   └── effective-prompts.md       # Agent usage patterns
├── scenario/
│   ├── requirements.md            # Business requirements
│   └── architecture.md            # Technical architecture (Mermaid)
├── solution/                      # SAIF v2 deployment package
│   ├── app/                       # FastAPI application
│   ├── infra/                     # Bicep templates
│   └── scripts/                   # Deployment scripts
├── validation/
│   ├── uat/                       # UAT test scripts & report template
│   └── load-testing/              # Load test scripts & report template
└── templates/                     # Sign-off templates
```

## Key Patterns Learned

### Pattern 1: SMART Acceptance Criteria

```markdown
Bad: "The API should be fast"
Good: "All endpoints return HTTP 200 within 500ms"

S - Specific: "HTTP 200"
M - Measurable: "within 500ms"
A - Achievable: Realistic threshold
R - Relevant: Matches user experience
T - Time-bound: Per-request, not "eventually"
```

### Pattern 2: Testing Pyramid for APIs

```
                    ┌─────────────────┐
                    │   Load Tests    │  ← "Can it handle traffic?"
                    ├─────────────────┤
                    │   UAT Tests     │  ← "Does it meet criteria?"
                    ├─────────────────┤
                    │   Unit Tests    │  ← "Does the code work?"
                    └─────────────────┘
```

### Pattern 3: Load Pattern Selection

| Pattern   | Question Answered                | When to Use           |
| --------- | -------------------------------- | --------------------- |
| Ramp-up   | "At what point does it degrade?" | Capacity planning     |
| Spike     | "Can it handle sudden bursts?"   | Auto-scale testing    |
| Sustained | "Does it degrade over time?"     | Memory leak detection |
| Step      | "What's the breaking point?"     | Stress testing        |

### Pattern 4: Agent Discovery Workflow

```
Agent asks → You provide domain knowledge → Agent adds testing patterns
     ↓              ↓                              ↓
"What URL?"    "Our healthcare API"         + Security tests
"What criteria?"  "HIPAA compliance"        + Compliance checks
"What load?"   "500 users peak"             + Appropriate pattern
```

## Discovery Questions Reference

### Understanding Testing Types

| Question                                   | Why Ask It                   |
| ------------------------------------------ | ---------------------------- |
| When is UAT enough vs. needing load tests? | Know what to skip/prioritize |
| What failure modes only appear under load? | Understand load test value   |
| How do I handle flaky tests?               | Realistic expectations       |

### Understanding Metrics

| Question                                                 | Why Ask It                    |
| -------------------------------------------------------- | ----------------------------- |
| Why p95 instead of average?                              | Focus on real user experience |
| What's the relationship between VUs, RPS, response time? | Interpret results correctly   |
| What grade is acceptable for production?                 | Set realistic thresholds      |

### Understanding the Agents

| Question                                 | Why Ask It                   |
| ---------------------------------------- | ---------------------------- |
| How does the agent know what to test?    | Understand agent limitations |
| What if I disagree with recommendations? | Know you have control        |
| How do I customize for my domain?        | Apply to your projects       |

## Success Metrics

### Learning Success

- [ ] Can explain when to use UAT vs. load testing
- [ ] Can write SMART acceptance criteria
- [ ] Understand p95 vs. average and why it matters
- [ ] Know which load pattern to use for different scenarios
- [ ] Can interpret bottleneck analysis and act on recommendations

### Efficiency Success

| Metric                     | Manual       | With Agents | Target            |
| -------------------------- | ------------ | ----------- | ----------------- |
| UAT Planning + Execution   | 5 hours      | 20 min      | 93% reduction     |
| Load Test Setup + Analysis | 7 hours      | 25 min      | 94% reduction     |
| Report Generation          | 4 hours      | 5 min       | 98% reduction     |
| **Total**                  | **16 hours** | **50 min**  | **95% reduction** |

## Common Questions

**Q: Why use agents instead of just running test scripts?**

A: Scripts execute tests; agents guide the entire workflow. The agent:

- Asks discovery questions to ensure coverage
- Generates appropriate test plans
- Interprets results and identifies root causes
- Creates professional reports automatically

**Q: What if the agent's test plan misses something important?**

A: You're the domain expert! Review the generated plan and add your knowledge.
The agent combines testing patterns with YOUR requirements—it doesn't replace
your expertise.

**Q: How accurate are the performance recommendations?**

A: Recommendations are based on observed metrics and Azure pricing. Always
validate cost estimates with Azure Pricing Calculator for your specific
configuration.

**Q: Can I use these agents for any API, not just SAIF?**

A: Yes! The agents are generic. Just provide your service URL and requirements.
They adapt to any REST API with HTTP endpoints.

## Next Steps

1. **Start Learning:** Open `examples/copilot-validation-conversation.md`
2. **Deploy SAIF:** Run `solution/scripts/deploy.ps1` (if not deployed)
3. **Try UAT Agent:** `@uat-assistant I need to test my API`
4. **Try Load Agent:** `@loadtest-assistant I need to load test my API`
5. **Review Reports:** Check generated reports in `validation/` folder
6. **Apply to Your APIs:** Use the same workflow for your services

## Related Scenarios

- **S01-bicep-baseline:** Deploy infrastructure to test
- **S03-five-agent-workflow:** Multi-agent architecture planning
- **S05-documentation-generation:** Generate testing documentation
- **S07-troubleshooting:** Debug issues found in testing

---

**Scenario Mission:** Transform service validation from a 25-hour manual process into a
60-minute AI-assisted workflow while understanding WHY testing patterns work—not just
running scripts.
