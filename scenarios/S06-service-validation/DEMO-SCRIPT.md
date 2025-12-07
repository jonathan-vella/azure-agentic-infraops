# S05: Service Validation Demo Script

**Duration**: 30-45 minutes
**Audience**: DevOps engineers, SREs, QA engineers, team leads
**Difficulty**: Intermediate to Advanced

---

## The Story: Marcus's Journey

**Who**: Marcus Chen, Senior QA Engineer at ValidationFirst Consulting
**Challenge**: 25 hours manual testing → client needs results in 2 hours
**Discovery**: AI isn't about replacing testing—it's about asking better questions

> "I thought Copilot would just write tests for me. Instead, it taught me
> that good testing starts with understanding what you're actually validating."

---

## Before You Begin

### Prerequisites Verified

- [ ] Azure service deployed and accessible
- [ ] VS Code with GitHub Copilot enabled
- [ ] UAT Assistant agent available (`@uat-assistant`)
- [ ] Load Test Assistant agent available (`@loadtest-assistant`)
- [ ] Terminal access for test execution

### Key Files for Demo

```text
scenarios/S06-service-validation/
├── examples/copilot-validation-conversation.md  ← Learning journey
├── agents/                                       ← Agent definitions
│   ├── uat-assistant.agent.md
│   └── loadtest-assistant.agent.md
├── prompts/effective-prompts.md                  ← Discovery techniques
├── validation/
│   ├── uat/                                      ← UAT scripts
│   │   ├── uat-tests.sh
│   │   ├── uat-tests.ps1
│   │   └── uat-report-template.md
│   └── load-testing/                             ← Load test files
│       ├── load-test.js
│       └── load-test-report-template.md
└── solution/                                     ← Pre-validated outputs
```

---

## Act 1: The Manual Testing Trap (5 minutes)

### Scene Setting

**Presenter says:**

> "Marcus has 25 hours of manual testing ahead. Three environments, 24 test cases
> each, plus load testing across different patterns. His client needs a sign-off
> report by tomorrow. Sound familiar?"

### Show the Traditional Approach

Open `manual-approach/time-tracking.md`:

```text
Traditional Service Validation Timeline:
├── Test planning and documentation    4 hours
├── UAT test development              6 hours
├── UAT execution (3 environments)    8 hours
├── Load test design                  3 hours
├── Load test execution               2 hours
├── Result analysis and reporting     2 hours
└── Total                            25 hours
```

**Key insight to share:**

> "Notice where time is actually spent—not in execution, but in
> figuring out WHAT to test and WHY those tests matter."

---

## Act 2: The First Discovery (10 minutes)

### The "Wrong" Way to Start

**Show what Marcus tried first:**

```text
Marcus: @uat-assistant Write UAT tests for my API

Agent: I can help with UAT testing. Could you tell me:
- What service are you testing?
- What does success look like for your stakeholders?
- What would cause this validation to fail?
```

**Presenter says:**

> "Marcus wanted tests generated. The agent wanted to understand the problem.
> This is where the real value begins."

### The Discovery Conversation

**Walk through these questions:**

```text
Agent: What service are you testing today?

Marcus: It's our SAIF v2 API - patient data access for healthcare.

Agent: Healthcare systems have specific validation needs. Beyond basic
functionality, what compliance or security aspects should we verify?

Marcus: HIPAA compliance - no PHI in logs, secure connections, audit trails.

Agent: Now I understand the stakes. A passing test isn't enough—we need
evidence of compliance. Let me help you build tests that generate
that evidence...
```

**Insight to highlight:**

> "The agent didn't just accept the task. It asked questions that helped
> Marcus realize his test plan was missing compliance validation."

### The Test Plan That Emerges

**Show the generated plan:**

```markdown
# UAT Test Plan - SAIF v2 API

## Functional Validation (16 tests)

- Health and readiness endpoints
- Authentication and authorization
- Data operations (CRUD)
- Error handling and edge cases

## Compliance Validation (4 tests)

- No PHI in response headers or logs
- HTTPS-only enforcement
- Audit trail generation
- Session timeout compliance

## Performance Baseline (4 tests)

- Response time SLAs (< 600ms)
- Concurrent user handling
- Database connection efficiency
- Memory/resource utilization
```

**Key message:**

> "Marcus came in thinking he needed 24 generic API tests. He left with
> 24 tests that actually prove compliance to auditors."

---

## Act 3: Intelligent Test Execution (10 minutes)

### Running UAT with Context

**Execute the UAT tests:**

```bash
# Set the environment
export API_BASE_URL="https://your-service.azurewebsites.net"

# Run the intelligent test suite
cd validation/uat
./uat-tests.sh
```

**Show the interactive output:**

```text
=== SAIF API - User Acceptance Tests ===
Target: https://your-service.azurewebsites.net
Testing with: Healthcare compliance mode

[1/24] Root endpoint health check...
       ✓ Status: 200 (43ms) - PASS
       ✓ No PHI in response headers

[2/24] SQL identity verification...
       ✓ Managed identity connected
       ✓ No credentials in response

[15/24] Security: HTTPS enforcement...
       ✓ HTTP redirect to HTTPS
       ✓ HSTS header present

[24/24] Compliance: Audit logging...
       ✓ Request logged with correlation ID
       ✓ No sensitive data in audit trail

=== Results ===
Total: 24 | Passed: 24 | Failed: 0
Compliance: VERIFIED
Ready for sign-off: YES
```

### The Insight Moment

**Presenter explains:**

> "Traditional UAT would have stopped at 'all tests pass.' These tests
> provide EVIDENCE—the difference between 'it works' and 'we can prove
> compliance to an auditor.'"

---

## Act 4: Load Testing That Answers Questions (10 minutes)

### Moving Beyond "How Fast"

**Start the load test conversation:**

```text
Marcus: @loadtest-assistant I need to load test my API

Agent: I can help design load tests. What questions are you trying
to answer?

Marcus: Whether it can handle production traffic.

Agent: That's the outcome. Let's get specific:
- What's "production traffic" in numbers?
- Is it steady traffic or bursts?
- What happens if the system fails under load?
- Who are you proving this to?
```

**Walk through the discovery:**

```text
Agent: What load pattern matches your production reality?

Marcus: Morning spike at 8 AM, steady through day, drops at 6 PM.

Agent: So we need a spike test, not a sustained load test. Most
people test the wrong pattern—they test constant load when their
real traffic is bursty. This changes everything about our approach.
```

### The Intelligent Load Test

**Show the generated k6 script:**

```javascript
// load-test.js - Designed for YOUR traffic pattern
import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  scenarios: {
    // Morning spike simulation
    morning_spike: {
      executor: "ramping-vus",
      startVUs: 10,
      stages: [
        { duration: "30s", target: 200 }, // 8 AM spike
        { duration: "2m", target: 150 }, // Settling
        { duration: "2m", target: 100 }, // Steady state
        { duration: "30s", target: 20 }, // Evening drop
      ],
    },
  },
  thresholds: {
    http_req_duration: ["p(95)<500"], // SLA target
    http_req_failed: ["rate<0.01"], // 99% success
  },
};
```

**Key message:**

> "The agent didn't just generate a load test. It asked about Marcus's
> ACTUAL traffic pattern and built tests that answer the RIGHT questions."

### Analyzing Results with Context

**Show the analysis conversation:**

```text
Agent: Your load test completed. Here's what we learned:

Performance Summary:
- Peak handled: 187 VUs (target: 200) ⚠️
- p95 response: 445ms (target: <500ms) ✅
- Error rate: 0.3% (target: <1%) ✅

Bottleneck Identified:
Database connection pool exhausted at 180 concurrent users.
Not an application problem—infrastructure configuration.

Recommendation:
Increase Azure SQL connection pool from 30 to 100.
Estimated cost impact: +$0/month (within current tier)
Expected improvement: Handle 350+ VUs with same p95

Marcus: I would have blamed the code. It was the connection pool.

Agent: That's why we test before blaming. Should I generate the
configuration change to fix this?
```

---

## Act 5: The Transformation (5 minutes)

### Reports That Tell a Story

**Show the generated reports:**

```text
validation/
├── uat/uat-report-template.md          ← Compliance evidence
└── load-testing/load-test-report-template.md  ← Performance evidence
```

**Open the UAT report:**

```markdown
# UAT Validation Report - SAIF v2 API

## Executive Summary

All 24 acceptance criteria validated. System ready for production
deployment with HIPAA compliance evidence documented.

## Compliance Evidence

| Requirement           | Test  | Evidence                       |
| --------------------- | ----- | ------------------------------ |
| No PHI exposure       | TC-15 | Headers verified, logs checked |
| Encryption in transit | TC-16 | TLS 1.2+ confirmed             |
| Audit trail           | TC-24 | Correlation IDs logged         |

## Sign-Off

- [ ] QA Lead: **\*\***\_**\*\*** Date: **\_**
- [ ] Security: \***\*\_\_\_\_\*\*** Date: **\_**
- [ ] Compliance: \***\*\_\_\*\*** Date: **\_**
```

### The Time Transformation

**Show the final comparison:**

```text
Before (Manual):                 After (With AI):
├── Planning        4 hrs       ├── Discovery       15 min
├── Development     6 hrs       ├── UAT Suite       20 min
├── Execution       8 hrs       ├── Execution       10 min
├── Load Design     3 hrs       ├── Load Testing    15 min
├── Load Execution  2 hrs       ├── Analysis        5 min
├── Reporting       2 hrs       ├── Reporting       0 min (auto)
└── Total          25 hrs       └── Total          65 min

Reduction: 96% | Hours Saved: 23.9
```

---

## Key Presenter Talking Points

### On Discovery vs. Generation

> "The agents didn't just write tests—they asked questions that made
> Marcus realize what he SHOULD have been testing all along."

### On Validation Philosophy

> "Passing tests aren't the goal. Evidence is the goal. These tests
> generate proof that satisfies auditors, not just developers."

### On the Real Bottleneck

> "Most testing time isn't spent running tests. It's spent figuring
> out what to test. AI accelerates that thinking process."

### On Skill Evolution

> "Marcus isn't faster at his old job. He's better at a new job—
> validation strategy instead of test execution."

---

## Demo Variations

### Quick Demo (15 minutes)

Focus on UAT discovery only:

1. Show manual approach (2 min)
2. Discovery conversation (5 min)
3. Test execution (5 min)
4. Report generation (3 min)

### Extended Workshop (90 minutes)

Add hands-on components:

1. Participants bring their own APIs
2. Guided discovery sessions
3. Custom test generation
4. Report creation and review

### CI/CD Integration Focus (45 minutes)

Extend Act 4 to show:

1. Pipeline integration patterns
2. Automated regression testing
3. Performance gate implementation
4. Alert configuration

---

## Troubleshooting

| Issue                   | Solution                                    |
| ----------------------- | ------------------------------------------- |
| Agents not responding   | Verify Copilot subscription active          |
| Tests fail unexpectedly | Check `API_BASE_URL` environment variable   |
| k6 not available        | Use Azure Load Testing or simulate results  |
| Reports not generating  | Ensure test output captured in conversation |

---

## Success Metrics

**This demo succeeds when attendees:**

- [ ] Understand discovery > generation
- [ ] Can articulate WHY questions matter
- [ ] See validation as evidence collection
- [ ] Know how to start their own validation journey
- [ ] Recognize the 96% time savings potential

---

## Follow-Up Resources

- **Full Conversation**: `examples/copilot-validation-conversation.md`
- **Prompt Techniques**: `prompts/effective-prompts.md`
- **Agent Definitions**: `agents/uat-assistant.agent.md`, `agents/loadtest-assistant.agent.md`
- **Report Templates**: `validation/uat/uat-report-template.md`, `validation/load-testing/load-test-report-template.md`

---

_"The best tests don't prove your code works. They prove your
system delivers what stakeholders actually need."_ — Marcus Chen
