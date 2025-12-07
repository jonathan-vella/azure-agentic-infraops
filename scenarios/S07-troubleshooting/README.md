# S07: Azure Troubleshooting Assistant

## Meet Maya Patel

**Role**: On-Call Site Reliability Engineer at RetailMax Online
**Experience**: 4 years in cloud operations, certified Azure Administrator
**Challenge**: 2 AM alert, checkout failures, Black Friday in 3 days

> "I used to spend 30 hours on incidents like this—digging through documentation,
> writing KQL queries from scratch, trial-and-error fixes. Now I have a conversation
> with Copilot and resolve in 5 hours. It's not magic—it's having a senior SRE
> partner who helps me think through the problem systematically."

---

## The Learning Journey

This scenario teaches you how to **troubleshoot with AI as a diagnostic partner**,
not just a query generator.

### What You'll Discover

| Phase              | Traditional Approach          | With Discovery                                               |
| ------------------ | ----------------------------- | ------------------------------------------------------------ |
| Problem Definition | "It's broken"                 | "What exactly is failing, for whom, and why does it matter?" |
| Data Discovery     | "Where do I look?"            | "What questions do the logs need to answer?"                 |
| Log Extraction     | "What's the KQL syntax?"      | "What hypothesis am I testing with this query?"              |
| Analysis           | "What do these numbers mean?" | "What story does this data tell?"                            |
| Root Cause         | "I think I found it"          | "How do I validate this conclusion?"                         |

### Sarah's Key Insight

> "Copilot didn't just give me queries. It asked me questions that made me
> realize I was looking in the wrong place. The breakthrough wasn't faster
> KQL—it was better thinking."

---

## Scenario: RetailMax Checkout Incident

**Company**: RetailMax Online (Fortune 500 e-commerce retailer)
**Platform**: $800M annual revenue on Azure
**Incident**: 15% of checkout transactions failing with HTTP 500 errors

### The Stakes

- **Revenue Impact**: $22,000 per hour of degraded service
- **Timing**: Black Friday in 3 days
- **SLA**: 99.9% uptime commitment (8.7 hours annual budget)
- **Pressure**: Executive visibility, customer complaints mounting

### Architecture Context

```text
┌─────────────────────────────────────────────────────────┐
│                    Azure App Service                     │
│                  (10 instances, P2v3)                    │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐               │
│  │ Instance │  │ Instance │  │ Instance │  ... (×10)    │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘               │
│       │             │             │                      │
│       └─────────────┼─────────────┘                      │
│                     │                                    │
│              Connection Pool                             │
│              (Max Size: 100)                             │
│                     │                                    │
└─────────────────────┼────────────────────────────────────┘
                      │
                      ▼
            ┌─────────────────┐
            │  Azure SQL DB   │
            │  (Premium P2)   │
            │   250 DTU       │
            └─────────────────┘
```

---

## The Five-Phase Learning Journey

### Phase 1: Problem Definition (10 minutes)

**Traditional**: "Checkout is broken, fix it"

**With Discovery**:

```text
Sarah: I have a production incident—15% checkout failures.

Copilot: Before we dive into logs, let me understand:
- What does "failure" look like to users? (Error page? Timeout? Redirect?)
- Is 15% across all users or concentrated in specific segments?
- What changed around the time failures started?
- Who else is investigating? What have they already checked?

Sarah: I didn't think to ask those questions. Let me find out...
```

**Learning**: The right questions prevent hours of wrong-direction investigation.

### Phase 2: Data Discovery (10 minutes)

**Traditional**: Open Log Analytics, stare at blank query window

**With Discovery**:

```text
Sarah: Where should I look for checkout errors?

Copilot: That depends on what you're trying to learn. Let's think through this:

For "Is this application or infrastructure?"
→ Check Application Insights exceptions table

For "Is a dependency slow or failing?"
→ Check dependencies table filtered to checkout operations

For "Is it resource exhaustion?"
→ Check performance counters and App Service metrics

What's your first hypothesis?

Sarah: I think the database might be slow...

Copilot: Good hypothesis. Let's test it with targeted queries.
What would "slow" mean in your context—seconds or milliseconds?
```

**Learning**: Knowing WHERE to look is half the battle.

### Phase 3: Log Extraction (15 minutes)

**Traditional**: Google "KQL syntax", copy-paste from Stack Overflow, iterate 15 times

**With Discovery**:

```text
Sarah: I need a query to find SQL-related errors.

Copilot: I can generate that query, but first:
- What time range matters? (Last 2 hours? Since incident started?)
- What aggregation helps? (Count by operation? Time buckets?)
- What's your threshold for "problem"? (>1 error? >5%?)

Here's a query that tests your database hypothesis:

[Query generated with explanation of each line]

Before you run it: What result would confirm your hypothesis?
What result would disprove it?

Sarah: If I see high duration on checkout SQL calls, that confirms it.
If durations are normal, I need to look elsewhere.

Copilot: Perfect. That's testable. Run it and let's see.
```

**Learning**: Hypothesis-driven queries find answers faster than exploratory ones.

### Phase 4: Analysis (20 minutes)

**Traditional**: Stare at query results, guess what they mean

**With Discovery**:

```text
Sarah: Results show sp_ProcessPayment taking 3.8 seconds average.

Copilot: That's significant. Let me help you interpret:

Normal checkout SQL: 100-200ms
Your checkout SQL: 3,800ms (19x slower)

But before concluding "database is slow," consider:
- Is the stored procedure itself slow? (Query plan issue)
- Is it waiting for something? (Locks, connection pool)
- Is it being called differently? (More data, different parameters)

Your error message mentioned "connection pool timeout."
That suggests operations are HOLDING connections too long,
not that individual queries are slow.

What's your connection pool size?

Sarah: I don't know—let me check... It's 100.

Copilot: Aha. Let's do the math together...
```

**Learning**: Data interpretation requires context, not just numbers.

### Phase 5: Root Cause & Resolution (15 minutes)

**Traditional**: Try random fixes until something works

**With Discovery**:

```text
Copilot: Here's the connection pool math:

- Pool size: 100 connections
- Checkout duration: 3.8 seconds average
- Peak traffic: 2 requests/second
- Connections held: 2 × 3.8 = 7.6 at any moment
- Plus background operations: ~20 connections
- Available headroom: 100 - 28 = 72 connections

At 5x traffic spike:
- Connections needed: 10 × 3.8 + 20 = 58 connections
- Still within limit, but getting close

What's causing the 15% failure rate then?

Sarah: Maybe the P99 duration matters more than average?

Copilot: Excellent thinking! Your P99 was 12.5 seconds.
At P99: 10 × 12.5 + 20 = 145 connections needed
Pool limit: 100
Gap: 45 connections can't be served → ~15% failures

Root cause confirmed: Connection pool exhaustion during
P99 latency spikes, not average load.

Sarah: So increasing pool size fixes it?

Copilot: Yes, but that's treating the symptom.
The REAL question: Why is payment processing taking 12 seconds?
```

**Learning**: Math validates hypotheses better than intuition.

---

## Time Savings

| Phase              | Manual Approach       | With AI Partner      | Savings |
| ------------------ | --------------------- | -------------------- | ------- |
| Problem Definition | 30 min (vague)        | 10 min (precise)     | 67%     |
| Data Discovery     | 4 hours (docs)        | 10 min (guided)      | 96%     |
| Log Extraction     | 8 hours (KQL)         | 15 min (generated)   | 97%     |
| Analysis           | 4 hours (guessing)    | 20 min (interpreted) | 92%     |
| Root Cause         | 8 hours (trial/error) | 15 min (validated)   | 97%     |
| Documentation      | 2 hours (manual)      | 5 min (auto)         | 96%     |
| **Total**          | **30 hours**          | **5 hours**          | **83%** |

### Business Impact

**Per Incident:**

- Time saved: 25 hours (83% reduction)
- Faster resolution = reduced business impact
- Knowledge captured for future incidents

**Annual (12 Major Incidents):**

- Time saved: 300 hours (7.5 work weeks)
- Consistent diagnostic approach across team
- Reduced escalations and faster onboarding

---

## Quick Start

### Prerequisites

- VS Code with GitHub Copilot Chat
- Azure subscription with Log Analytics access
- Application Insights data (or use sample queries)

### Try It Yourself

**Step 1**: Open Copilot Chat and describe an incident:

```text
I have an Azure incident: [Your symptoms here]
Help me troubleshoot systematically.
```

**Step 2**: Answer Copilot's discovery questions honestly

**Step 3**: Let Copilot generate diagnostic queries

**Step 4**: Share results and iterate on analysis

**Step 5**: Validate the root cause with math/evidence

### Files in This Scenario

```text
S07-troubleshooting/
├── README.md                      ← You are here
├── DEMO-SCRIPT.md                 ← 30-min presenter guide
├── examples/
│   └── copilot-conversation.md    ← Sarah's full 5-hour conversation
├── prompts/
│   └── effective-prompts.md       ← Discovery patterns and techniques
├── scenario/
│   ├── requirements.md            ← RetailMax incident details
│   └── incident-timeline.md       ← Problem progression
├── solution/
│   ├── Get-AzureHealthSnapshot.ps1
│   └── Invoke-DiagnosticQuery.ps1
└── validation/
    └── validate.ps1
```

---

## Key Takeaways

### For IT Professionals

- **Troubleshooting is thinking**, not just querying
- **Discovery questions** prevent wrong-direction investigation
- **Hypothesis testing** beats exploratory log diving
- **Math validates** what intuition suggests

### For Teams

- **Knowledge transfer**: Every incident teaches the team
- **Consistent process**: 5-phase workflow works for any incident
- **Better documentation**: Auto-generated post-mortems
- **Reduced burnout**: 25 hours of stress → 5 hours of guided work

### For Organizations

- **83% faster MTTR**: Competitive advantage in uptime SLAs
- **300 hours annual savings**: 7.5 work weeks recovered per team
- **Reduced business impact**: Faster resolution = less downtime
- **Scalable expertise**: Junior engineers troubleshoot like seniors

---

## Sarah's Closing Reflection

> "The first time I used Copilot for troubleshooting, I expected it to
> write queries for me. Instead, it asked me what I was trying to learn.
> That question changed everything.
>
> Now I approach incidents differently. Before I open Log Analytics,
> I ask myself: What hypothesis am I testing? What would confirm it?
> What would disprove it?
>
> Copilot taught me to think like a diagnostician, not a query writer.
> The 83% time savings is real, but the skill improvement is even more valuable."

---

## Next Steps

1. **Run the Demo**: Follow [DEMO-SCRIPT.md](./DEMO-SCRIPT.md)
2. **Read Sarah's Conversation**: [examples/copilot-conversation.md](./examples/copilot-conversation.md)
3. **Learn Prompt Patterns**: [prompts/effective-prompts.md](./prompts/effective-prompts.md)
4. **Try Your Own Incident**: Apply the 5-phase workflow to your next alert

---

_"The goal isn't faster queries. It's better questions."_ — Maya Patel
