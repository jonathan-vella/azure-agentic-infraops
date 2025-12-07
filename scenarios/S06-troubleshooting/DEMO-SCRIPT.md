# S06: Troubleshooting Assistant - Presenter Guide

## Demo Overview

**Duration**: 30 minutes
**Complexity**: Intermediate
**Audience**: IT Pros, SREs, DevOps Engineers, Cloud Operations Teams
**Approach**: **Conversation with Copilot** (discovery-first, not script building)

### The Story: Sarah's 2 AM Alert

**Who**: Sarah Chen, On-Call SRE at RetailMax Online
**Challenge**: 15% checkout failures, $22K/hour revenue impact, Black Friday in 3 days
**Discovery**: AI isn't about faster queries—it's about better questions

> "I thought I needed faster KQL skills. Turns out I needed a diagnostic
> partner who helped me think through the problem systematically."

### Demo Objectives

By the end of this demo, participants will understand:

1. How to use GitHub Copilot Chat as a **diagnostic partner** (not just a query generator)
2. The 5-phase workflow: Problem → Discovery → Extraction → Analysis → RCA
3. How **discovery questions** prevent wrong-direction investigation
4. Why hypothesis-driven troubleshooting beats exploratory log diving
5. The 83% time reduction (30 hours → 5 hours) through better thinking, not just faster tools

### Value Proposition

> "GitHub Copilot transforms Azure troubleshooting from a 30-hour documentation-heavy
> process into a 5-hour AI-assisted conversation. You describe symptoms in plain English,
> Copilot asks discovery questions, generates diagnostic queries, interprets results,
> and guides you to root cause—like having a senior SRE as your on-call partner."

---

## Pre-Demo Checklist

### 48 Hours Before

- [ ] **Azure Environment Setup**
  - Log Analytics workspace with sample data (Application Insights)
  - Azure Portal access for running KQL queries
  - Test access to query interfaces

- [ ] **Local Development Setup**
  - VS Code with **GitHub Copilot Chat** enabled
  - Test Copilot Chat responsiveness
  - Familiarize with split-screen layout (Chat + Query window)

- [ ] **Demo Content Preparation**
  - Review RetailMax scenario (scenario/requirements.md)
  - Read full conversation example (examples/copilot-conversation.md)
  - Practice conversation flow (don't memorize, understand the pattern)
  - Prepare 2-3 key questions to ask Copilot

### 30 Minutes Before

- [ ] **Technical Validation**
  - Open Azure Portal → Log Analytics
  - Verify you can run test KQL query
  - Ensure Application Insights data is available

- [ ] **Presentation Setup**
  - VS Code with Copilot Chat panel open (font size 16-18)
  - Azure Portal in separate browser tab (for running queries)
  - Close unnecessary applications
  - Screen share layout: VS Code (left 60%) + Browser (right 40%)

- [ ] **Mindset Preparation**
  - Remember: This is a **conversation**, not a script
  - Pauses are good (shows authentic thinking)
  - Narrate your thought process out loud
  - Be ready to adapt if Copilot's response differs
  - Have backup: Manual KQL query if Copilot struggles

---

## Demo Script (30 Minutes)

### Part 1: Scene Setting (5 minutes)

#### Opening Hook (60 seconds)

> "It's 2 AM. You're on-call. Your phone buzzes: **'E-commerce checkout failing - 15% error rate - revenue impact $22K
> per hour.'** And oh, by the way, Black Friday is in 3 days."
>
> "This is every IT Pro's nightmare. Typically, you're looking at 30 hours of troubleshooting: documentation searches,
> trial-and-error fixes, vendor support tickets."
>
> "Today, I'll show you a different approach: **having a conversation with GitHub Copilot** to troubleshoot together.
> Same incident, 5 hours instead of 30 - that's **83% faster**."

#### Present the Scenario (2 minutes)

**Display**: Open `scenario/requirements.md`

> "Meet RetailMax Online, a Fortune 500 retailer with an $800M e-commerce platform on Azure."

**Key Points to Emphasize**:
- Platform criticality: $22K revenue loss per hour
- Business pressure: Black Friday in 3 days
- SLA at risk: 99.9% uptime commitment
- Team stress: On-call engineer needs fast resolution

**Quick scroll through document**:
> "The incident started 2 hours ago. 15% of checkout transactions failing. Users are angry, management is watching.
> Every minute counts."

#### Manual Approach Pain Points (2 minutes)

**Narrate the Typical Journey** (with visible frustration):

> "In the manual world, here's what happens:"

1. **Documentation Deep-Dive** (4 hours)
   - "You open 47 browser tabs of Azure documentation"
   - "Search Stack Overflow: 'azure sql timeout checkout'"
   - "Read through 200-page troubleshooting guides"

2. **KQL Query Writing** (8 hours)
   - "You stare at blank Log Analytics window"
   - "Try to remember KQL syntax: Is it `where` or `filter`?"
   - "Iterate through 15 queries, most return nothing useful"

3. **Trial & Error** (6 hours)
   - "Change configuration, wait 10 minutes to see effect"
   - "Still broken. Try different hypothesis."
   - "Call vendor support, wait on hold, get generic advice"

4. **Documentation** (2 hours)
   - "Finally fix it at 6 AM after testing 8 different solutions"
   - "Too exhausted to write good post-mortem"
   - "Next person faces same problem in 3 months"

**Pause for Effect**:
> "30 hours total. 3-4 work days. Brutal. **But what if you had a senior SRE sitting next to you,
> guiding you through it?**"

**Transition**:
> "That's what GitHub Copilot does. Let me show you."

---

### Part 2: Live Copilot Conversation (18 minutes)

**Setup Narration**:
> "I'm opening Copilot Chat in VS Code. On the right, I have Azure Portal ready to run queries. 
> I'm going to **talk to Copilot** like I would talk to a senior colleague during an incident."

---

#### Phase 1: Problem Definition (3 minutes)

**Action**: Open Copilot Chat, type (narrate as you type):

```
I have a production incident and need help troubleshooting:

Symptoms:
- 15% of checkout transactions failing with HTTP 500 errors
- Started approximately 2 hours ago (around 8:00 PM EST)
- Intermittent pattern (not all users affected)
- 375 failed transactions so far

Architecture:
- Azure App Service (10 instances, Premium P2v3)
- Azure SQL Database (Premium P2, 250 DTU)
- Application Insights enabled

Business Impact:
- $22K revenue loss per hour
- Black Friday in 3 days

Help me identify the root cause systematically.
```

**Narrate While Typing** (key teaching moment):
> "Notice I'm not just saying 'my app is broken.' I'm giving Copilot:
> - **Specific symptoms**: 15% failure, HTTP 500
> - **Timeline**: Started 2 hours ago
> - **Architecture context**: App Service + SQL
> - **Business impact**: Creates urgency
>
> This context helps Copilot ask the RIGHT discovery questions.
> Watch what happens next—it won't just give me a query."

**Press Enter, Wait for Response** (10-15 seconds)

**Read Copilot's Response Out Loud** (summarize, don't read word-for-word):
> "See how Copilot responds? It's not jumping to queries. It's:
> 1. Structuring the problem for clarity
> 2. Asking what I've already checked
> 3. Suggesting an investigation ORDER based on likelihood
>
> This is the discovery phase. Copilot is helping me THINK, not just TYPE."

**🎓 Teaching Point (Critical Learning Moment)**:
> "Here's the key insight: In the old world, I'd spend 2 hours googling
> 'azure app service 500 error' and trying random solutions.
>
> Copilot is doing something different—it's asking discovery questions
> that help me narrow down BEFORE I touch Log Analytics.
>
> The time savings isn't faster KQL. It's not wasting 8 hours
> investigating the wrong hypothesis."

---

#### Phase 2: Data Discovery & First Query (5 minutes)

**Action**: Continue conversation

```
Yes, I have Log Analytics access. 
Application Insights resource is "ai-retailmax-prod". 
What should I check first?
```

**Wait for Copilot** (it should suggest checking exceptions)

**Read Response, Highlight Key Parts**:
> "Copilot is recommending we start with the Application Insights `exceptions` table. 
> And look - it's **generating a KQL query for me**. Let me copy this."

**Copy the KQL Query** (should be similar to):

```kql
exceptions
| where timestamp > ago(2h)
| summarize 
    ExceptionCount = count(),
    UniqueUsers = dcount(user_Id),
    SampleMessage = any(outerMessage)
    by type, operation_Name
| order by ExceptionCount desc
```

**Teaching Point (while copying)**:
> "In the manual approach, I'd spend 30-45 minutes:
> - Looking up KQL syntax
> - Figuring out which table to query
> - Getting the aggregation logic right
>
> Copilot did it in 5 seconds. BUT—and this is important—notice
> Copilot explained WHY it's querying exceptions table first.
> It's teaching me diagnostic methodology, not just giving me code."

**🎓 Learning Moment**:
> "Ask yourself: If I ran this query without understanding WHY,
> would I know what to do with the results?
>
> Copilot doesn't just generate queries—it builds your mental model
> of how Azure troubleshooting works."

**Switch to Azure Portal** (show screen transition):
> "Now I'll run this in Azure Portal. 
> Log Analytics → Queries → [paste query] → Run"

**Show Results** (read table out loud):
> "Wow, look at this data:
> 
> | Exception Type | Operation | Count | Sample Message |
> |----------------|-----------|-------|----------------|
> | InvalidOperationException | POST /api/checkout | 423 | **Timeout expired... obtaining a connection from the pool** |
> | SqlException | POST /api/checkout | 156 | Cannot open database |
> 
> That error message is the smoking gun: '**Timeout obtaining connection from the pool**'"

**Return to Copilot Chat**:
> "Let me share these results with Copilot. Notice I'm not asking
> 'what does this mean?' I'm going to share the data and see
> how Copilot helps me interpret it."

---

#### Phase 3: Log Analysis (5 minutes)

**🎓 Key Learning Moment: Data Interpretation**

> "This is where most troubleshooting goes wrong. People get query results
> and don't know what to do with them. Watch how Copilot helps interpret."

**Action**: Paste results into Copilot Chat

<!-- markdownlint-disable MD013 -->
```
I ran the query and got these results:

| type | operation_Name | ExceptionCount | SampleMessage |
|------|----------------|----------------|---------------|
| InvalidOperationException | POST /api/checkout | 423 | Timeout expired. The timeout period elapsed prior to obtaining a connection from the pool. |
| SqlException | POST /api/checkout | 156 | Cannot open database |

What does this tell us?
```
<!-- markdownlint-enable MD013 -->

**Narrate**:
> "I'm sharing the **actual data** with Copilot. It can't see my screen, so I paste the results."

**Wait for Copilot Response** (should identify connection pool exhaustion)

**Read Response, Get Excited**:
> "Listen to this! Copilot is saying:
> - 'This strongly suggests SQL connection pool exhaustion'
> - 'The timeout message is a classic symptom'
> - 'Long-running transactions are likely holding connections'
>
> And it's asking me to run a follow-up query. But notice—it's not
> just giving me another query. It's explaining the HYPOTHESIS:
> 'Let's verify that checkout operations are holding connections
> longer than other operations.'"

**🎓 Teaching Point: Hypothesis-Driven Investigation**:
> "In the old world, I'd run 15 random queries hoping to find something.
>
> Copilot is teaching me hypothesis-driven troubleshooting:
> 1. Form a hypothesis (connection pool exhaustion)
> 2. Design a query to TEST that hypothesis
> 3. Interpret results to CONFIRM or DISPROVE
>
> This is how senior SREs think. Copilot is transferring that skill."

**Copy Second Query**:

```kql
dependencies
| where timestamp > ago(2h)
| where type == "SQL"
| summarize 
    TotalCalls = count(),
    FailedCalls = countif(success == false),
    AvgDuration = avg(duration),
    P95Duration = percentile(duration, 95)
    by operation_Name, name
| where FailedCalls > 0
| order by FailedCalls desc
```

**Switch to Portal, Run Query**:
> "Running this second query..."

**Show Results**:
> "Aha! Here's the problem:
> - Checkout operations: **3,800 milliseconds average** (3.8 seconds!)
> - Normal product queries: 124 milliseconds
> 
> Checkout operations are **30 times slower** than they should be. 
> Those long-running transactions are holding SQL connections, exhausting the pool!"

**Teaching Point**:
> "In 10 minutes, we've gone from '15% of checkouts are broken' to
> 'checkout SQL operations take 3.8 seconds and are exhausting
> the connection pool.'
>
> That's the power of guided investigation. But here's the key:
> I didn't just get an answer—I understand WHY it's the answer.
> I could explain this to my manager, my team, an auditor."

**🎓 Learning Moment: Understanding vs. Answers**:
> "Ask yourself: Do you understand why 3.8 seconds matters?
> Why connection pools have limits? What happens when they exhaust?
>
> If you followed along with Copilot's reasoning, you now have
> KNOWLEDGE, not just a fix. That knowledge applies to every
> future incident involving database connections."

---

#### Phase 4: Root Cause Identification (3 minutes)

**Action**: Ask Copilot to validate the hypothesis

```
The SQL dependency query shows:
- Checkout operations: 3.8 seconds average (up to 12.5 seconds at P99)
- Normal queries: 124ms average

This confirms connection pool exhaustion, right? 
How do I check the current pool size configuration?
```

**Wait for Copilot Response**

**Read and React**:
> "Copilot is doing the **math** for me! It says:
>
> 'If you have 10 App Service instances, each with default pool size of 100,
> and checkout operations take 3.8 seconds, here's what happens...'
>
> [Walk through the calculation on screen]
>
> And it's telling me to check the connection string for 'Max Pool Size'."

**🎓 Critical Teaching Point: Math Validates Hypotheses**:
> "This is where troubleshooting becomes SCIENCE instead of guessing.
>
> Copilot didn't just say 'increase pool size.' It showed me the MATH
> that proves why the current configuration fails under load.
>
> Now I can:
> - Explain to management exactly why this happened
> - Calculate the right pool size (not just guess)
> - Predict when it would happen again without the fix
>
> Math beats intuition. Every time."

**Switch to Portal** (quickly):
> "Let me check... App Service → Configuration → Connection Strings..."

**Show Connection String** (mock or real):
> "There it is: `Max Pool Size=100`
> 
> Copilot's hypothesis is **confirmed**! The default pool size of 100 isn't enough for peak load."

**Return to Copilot**:

```
Confirmed: Max Pool Size is 100. 
What's the recommended fix?
```

**Read Response**:
> "Copilot is giving me a **three-tier approach**:
> 
> **Immediate (5 minutes)**: Increase Max Pool Size to 200
> - Stops the bleeding right now
> - Handles current traffic pattern
> 
> **Short-term (30 minutes)**: Add retry logic and timeout handling
> - More resilient to future spikes
> 
> **Long-term (post-Black Friday)**: Optimize payment processing
> - Move to async queue (Service Bus)
> - Don't hold connections during external API calls
> 
> For now, let's do the immediate fix."

**Teaching Point**:
> "Notice Copilot isn't just saying 'increase the pool size.' It's explaining:
> - Why this works (math)
> - How to do it safely (step-by-step)
> - What to do long-term (architectural improvement)
>
> It's **teaching** while troubleshooting. That's the difference between
> a tool that gives answers and a partner that builds your skills."

**🎓 Learning Moment: Symptom vs. Root Cause**:
> "Important distinction: Increasing pool size treats the SYMPTOM.
> The ROOT CAUSE is that payment processing holds connections too long.
>
> Copilot surfaced both. A less experienced engineer might stop at
> 'increase pool size.' Copilot is teaching that good troubleshooting
> identifies the underlying issue even when applying a quick fix."

---

#### Phase 5: Documentation (2 minutes)

**Action**: Skip the fix implementation (mention it), jump to documentation

> "I won't actually make the change live, but Copilot would walk me through:
> 1. Update connection string
> 2. Restart App Service (rolling restart to avoid downtime)
> 3. Monitor for 30 minutes to validate
> 
> Let's say the fix worked. Now I need to document this incident. 
> In the old world, this takes 2 hours. Let's ask Copilot..."

**Type in Chat**:

```
The fix worked! Exception rate dropped from 89 to 4 per 30 minutes.
Can you generate a post-mortem report for this incident?
```

**Wait for Copilot** (it will start generating)

**Scroll Through Response**:
> "In 30 seconds, Copilot has generated:
> - Executive summary
> - Complete timeline with timestamps
> - Root cause analysis with technical details
> - Resolution steps
> - Prevention recommendations
> - Even action items with owners and due dates!
> 
> This is audit-ready documentation generated automatically."

**Show Full Example** (open examples/copilot-conversation.md):
> "Here's what a complete troubleshooting conversation looks like - 
> 2 hours 45 minutes from incident to resolution to documentation.
> 
> Normally? 30 hours."

---

### Part 3: Validation & Wrap-Up (7 minutes)

#### Demonstrate Key Queries (2 minutes)

**Open Azure Portal** (if time permits):

> "Let me show you these queries actually work..."

**Run 1-2 queries live**:
- Show exceptions table query
- Show results are real data

**Or Show Screenshots**:
- "Here's what the actual results look like in a real incident"

#### Summary of Time Savings (2 minutes)

**Display Slide or Talk Through**:

| Phase | Manual | With Copilot | Savings |
|-------|--------|--------------|---------|
| Problem Definition | 30 min | 5 min | 83% |
| Finding Right Queries | 8 hours | 10 min | 98% |
| Interpreting Results | 4 hours | 15 min | 94% |
| Identifying Root Cause | 8 hours | 20 min | 96% |
| Generating Documentation | 2 hours | 5 min | 96% |
| **TOTAL** | **30 hours** | **5 hours** | **83%** |

> "That's the difference between spending **3-4 work days** on an incident versus **half a work day**."

**Time Impact**:
- Time saved per incident: 25 hours
- Annual savings (12 incidents): **300 hours (7.5 work weeks)**
- Faster resolution = reduced business impact

#### Key Takeaways (2 minutes)

**For IT Professionals**:
> "You just saw how to use Copilot as your **diagnostic partner**:
> 1. Describe symptoms with context (not just 'it's broken')
> 2. Let Copilot ask discovery questions (don't skip this!)
> 3. Form hypotheses before running queries
> 4. Validate with math, not intuition
> 5. Understand the WHY, not just the fix
>
> The skill transfer is the real value. Every incident makes you better."

**For Management**:
> "The business value is clear:
> - 83% faster resolution (30h → 5h)
> - 300 hours annual time savings (7.5 work weeks)
> - Significantly reduced downtime impact
> - Knowledge captured automatically
> - Junior engineers troubleshoot like seniors
>
> But the hidden value: Your team is LEARNING while troubleshooting.
> Copilot builds organizational capability, not just individual speed."

**🎓 Final Learning Moment**:
> "The real transformation isn't '83% faster troubleshooting.'
>
> It's that your team develops diagnostic instincts over time.
> Every Copilot conversation teaches hypothesis formation,
> data interpretation, and systematic thinking.
>
> In 6 months, your team troubleshoots differently—with or without AI."

#### Q&A Preparation (1 minute)

**Common Questions**:

**Q**: "What if Copilot gives wrong queries?"
**A**: "You validate everything. Run the query, check if results make sense. Copilot is a partner, not autopilot.
You're still the expert."

**Q**: "Does this work for services besides App Service and SQL?"
**A**: "Yes! Same conversation pattern works for AKS, Functions, Storage,
anything with Application Insights or Log Analytics."

**Q**: "What if I don't have Application Insights?"
**A**: "Copilot can help with any log source - Azure Monitor, custom logs, even on-premises logs.
The conversation pattern is the same."

**Q**: "How do I get started?"
**A**: "Just open Copilot Chat and describe your next incident. Start with 'I have an issue with [service].
Symptoms are [X]. Help me troubleshoot.' The AI will guide you."

---

## Troubleshooting the Demo

### If Copilot Doesn't Respond as Expected

**Scenario**: Copilot gives generic response or wrong query

**Recovery**:
> "Hmm, that's not quite what I need. Let me be more specific..."

**Rephrase with more context**:
```
I need a KQL query for Application Insights exceptions table.
Show me exceptions in the last 2 hours, grouped by exception type and operation name.
Include count of exceptions and sample error message.
```

**Teaching Point**: "This shows you need to iterate sometimes. Just like with a human colleague."

### If Azure Portal Query Fails

**Scenario**: KQL syntax error or no data

**Recovery**:
> "This happens sometimes - let me check the syntax... 
> [Fix obvious error like missing pipe or typo]
> 
> In a real incident, I'd also have Copilot help debug the query error."

### If Demo Environment Lacks Data

**Scenario**: Application Insights has no recent data

**Recovery**:
> "In my demo environment, there's no live data right now. 
> But I have screenshots from a real incident - let me show you..."

**Show examples/copilot-conversation.md or screenshots**

---

## Post-Demo Resources

### Share With Attendees

1. **Scenario file**: scenario/requirements.md (RetailMax incident details)
2. **Full conversation**: examples/copilot-conversation.md (complete 5-hour troubleshooting session)
3. **Prompt patterns**: prompts/effective-prompts.md (how to structure questions for Copilot)
4. **Getting started**: README.md (try it yourself guide)

### Follow-Up Actions

- [ ] Share demo recording (if recorded)
- [ ] Distribute conversation examples
- [ ] Schedule hands-on workshop (optional)
- [ ] Collect feedback on what scenarios to add

---

## Demo Success Criteria

### You'll Know It Went Well If...

✅ Audience understands this is **discovery-first**, not query-first
✅ They see Copilot as a **thinking partner**, not a KQL generator
✅ They grasp the 5-phase workflow (Problem → Discovery → Extraction → Analysis → RCA)
✅ They feel confident they could start a troubleshooting conversation tomorrow
✅ They understand the 83% time savings comes from **better questions**, not faster typing
✅ They recognize the **skill transfer** value, not just speed improvement

### Red Flags to Watch For

❌ Audience confused about "where is the automation?"
→ Clarify: Copilot assists THINKING, not replaces it

❌ Audience thinks "this is just ChatGPT for Azure"
→ Emphasize: Discovery questions, hypothesis validation, math-based confirmation

❌ Audience skeptical of time savings
→ Show the math: 8 hours finding right queries → 10 minutes with guided investigation

❌ Audience focuses only on queries, not methodology
→ Redirect: "The queries are outputs. The thinking process is the value."

---

**Demo Philosophy**:
> "Show, don't tell. Let the conversation unfold naturally.
> Embrace pauses. React authentically to Copilot's responses.
> Highlight learning moments—the 'aha' when math confirms a hypothesis.
> Make it feel like discovery, not demonstration."

**Remember**: The power isn't in faster queries—it's in having an AI partner
who helps you **think through** complex problems systematically.

---

*"I came for faster KQL. I stayed for better diagnostic thinking."* — Sarah Chen
