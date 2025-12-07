# Effective Copilot Prompts for Azure Troubleshooting

## Overview

This guide provides proven prompting patterns for using GitHub Copilot to accelerate Azure troubleshooting.
Each pattern includes context on when to use it, example prompts, and tips for best results.

**Time Savings**: Using these prompts effectively can reduce troubleshooting time from 30 hours to
5 hours (83% reduction).

---

## The Discovery-First Mindset

> "The best troubleshooters don't find answers faster—they ask better questions."

Before diving into prompts and patterns, understand the core principle:
**Discovery questions before diagnostic queries**.

### Why Discovery Matters

| Without Discovery | With Discovery |
|-------------------|----------------|
| "Show me errors" | "What would cause 15% of checkouts to fail?" |
| "Give me a KQL query" | "What hypothesis should this query test?" |
| "What's wrong?" | "What changed around the time this started?" |
| 15 iterations to find the right query | 2-3 targeted queries that answer specific questions |

### The Five Discovery Questions

Before any troubleshooting session, answer these:

1. **What exactly is failing?**
   - Not "checkout is broken" but "15% of POST /api/checkout return 500"
   - Specificity prevents wrong-direction investigation

2. **Who is affected and how?**
   - All users? Specific region? Certain browsers?
   - Pattern reveals root cause faster than logs

3. **When did it start and what changed?**
   - Deployment? Config change? Traffic spike?
   - Timeline correlation is 80% of root cause analysis

4. **What have you already checked?**
   - Prevents duplicate work
   - Reveals assumptions that might be wrong

5. **What would "fixed" look like?**
   - Defines success criteria
   - Helps validate when you've actually resolved it

### Discovery Conversation Pattern

Instead of jumping to queries, start with context:

```text
❌ Task-First (Less Effective):
"Write KQL query to find errors"

✅ Discovery-First (More Effective):
"I have a production incident:
- Symptom: 15% checkout failures, HTTP 500
- Started: 2 hours ago (around 8 PM)
- Architecture: App Service (10 instances) + SQL Database
- What I've checked: App Service is healthy, no recent deployments

Help me identify root cause systematically."
```

The discovery-first approach gives Copilot context to ask the RIGHT follow-up questions.

---

## General Prompting Principles

### 1. Be Specific About Context

- ❌ Bad: "Check database performance"
- ✅ Good: "Check Azure SQL Database P2 tier CPU and DTU usage over last 2 hours"

### 2. Include Symptoms and Impact

- ❌ Bad: "Find errors"
- ✅ Good: "Analyze 5xx errors in checkout API causing 15% failure rate in last 2 hours"

### 3. Specify Desired Output Format

- ❌ Bad: "Create monitoring script"
- ✅ Good: "Create PowerShell function to check Azure resource health with HTML report output"

### 4. Mention Time Ranges

- ❌ Bad: "Show slow queries"
- ✅ Good: "Generate KQL query to find SQL queries slower than 5 seconds in last 4 hours"

### 5. Request Best Practices

- ❌ Bad: "Write connection pool config"
- ✅ Good: "Write App Service connection pool configuration following Azure best practices for high-traffic applications"

## Pattern 1: Health Check Scripts

### When to Use

- Initial incident triage
- Regular health monitoring
- Pre-deployment validation

### Effective Prompts

**Basic Health Check**:

```bicep
Create a PowerShell function to check Azure resource health
Function name: Get-AzureHealthSnapshot
Parameters: ResourceGroupName (mandatory), IncludeMetrics (switch)
Check: Resource health status, recent alerts, availability
Output: Color-coded console summary with green/yellow/red status
Include error handling and logging
```

**Comprehensive Diagnostics**:

```bicep
Create Azure health check script that validates:
- App Service instance health and response time
- SQL Database DTU usage and connection count
- Application Gateway backend pool health
- NSG rule conflicts
- Recent configuration changes
Output structured JSON for automation
```

**Network Connectivity**:

```bicep
Create PowerShell function to test Azure networking
Check: VNet connectivity, NSG rules, route tables, DNS resolution
Parameters: ResourceGroupName, TestEndpoint
Include ping tests, port checks, and traceroute equivalent
Output detailed connection report
```

### Tips for Health Checks

- Specify exact metrics to check (CPU %, DTU, connection count)
- Request color-coded output for quick visual scanning
- Include progress indicators for long-running checks
- Ask for export options (CSV, JSON, HTML)

## Pattern 2: KQL Query Generation

### When to Use

- Analyzing logs in Log Analytics
- Investigating Application Insights data
- Correlating events across services

### Understanding Before Querying

Before asking for a KQL query, clarify your hypothesis:

```text
❌ "Give me a query to find errors"

✅ "I hypothesis that SQL connection timeouts are causing checkout failures.
    I need a query to:
    - Show SQL-related exceptions in the last 2 hours
    - Group by operation to see which endpoints are affected
    - Include sample error messages for context
    
    What result would confirm my hypothesis?"
```

The second approach gets you a targeted query AND helps you interpret results.

### Effective Prompts

**Performance Analysis**:

```text
Generate KQL query to analyze API performance
Workspace: Application Insights
Show: P50, P95, P99 latency by operation in last 2 hours
Include: Request count, failure rate, unique users
Order by P95 latency descending
Limit to top 20 operations
```

**Error Investigation**:

```text
Create KQL query for 5xx error analysis
Show: Error count by operation, result code, and time (5-min bins)
Calculate: Error rate as percentage of total requests
Include: Sample error messages (3 per error type)
Time range: Last 4 hours
```

**Dependency Analysis**:

```text
Generate KQL query to find slow database dependencies
Filter: Type = SQL, duration > 5000ms
Show: Avg/max duration, query count, sample query text
Group by: Target database, operation name
Time range: Last 6 hours
Order by: Average duration descending
```

**Timeline Correlation**:

```text
Create KQL query to correlate requests with exceptions
Join: requests table with exceptions on operation_Id
Show: Request duration, exception type, exception message
Filter: Last 2 hours, only failed requests
Render: Time chart showing correlation
```

**Resource Usage**:

```text
Generate KQL query for CPU usage analysis
Source: performanceCounters
Metric: % Processor Time
Filter: Values > 80% (high CPU threshold)
Show: Avg/max CPU by instance over 5-minute bins
Identify: Instances with sustained high CPU (>30 minutes)
```

### Tips for KQL Queries

- Specify exact table names (requests, exceptions, dependencies, traces)
- Include time filters explicitly (ago(2h), between(start..end))
- Request aggregations (avg, max, percentile, count)
- Ask for render type (timechart, barchart, table)
- Mention column names if known (operation_Name, resultCode, duration)

## Pattern 3: Diagnostic Scripts

### When to Use

- Automating repetitive diagnostic tasks
- Creating reusable troubleshooting tools
- Building runbooks for common issues

### Effective Prompts

**Natural Language to KQL**:

```yaml
Create PowerShell function: Invoke-DiagnosticQuery
Input: Natural language symptom description
Output: Appropriate KQL query based on symptom
Support patterns:
- High latency → Performance analysis query
- 5xx errors → Server error analysis
- Timeouts → Timeout pattern detection
- Database slow → SQL dependency analysis
Execute query against Log Analytics workspace
Return results with suggested next steps
```

**Automated Issue Detection**:

```text
Create PowerShell script to detect common Azure issues
Checks:
- App Service CPU/memory over threshold (80%)
- SQL Database DTU exhaustion (>90%)
- Connection pool near limit (>90%)
- Recent deployment causing errors
- NSG blocking required traffic
For each issue found: Provide description, severity, remediation steps
Output: JSON report with findings
```

**Log Analyzer**:

```powershell
Create function to parse Azure App Service logs
Input: Log file path or stream from Azure
Detect patterns:
- Exception frequency and types
- HTTP error codes distribution
- Slow request patterns (>3s)
- Memory leak indicators
Output: Summary report with actionable insights
Include: Charts of error trends over time
```

### Tips for Diagnostic Scripts

- Request pattern matching (switch statements for symptoms)
- Ask for error handling and retries
- Include progress indicators for user feedback
- Request structured output (PSCustomObject, JSON)
- Mention logging best practices

## Pattern 4: Remediation Scripts

### When to Use

- Applying fixes to identified issues
- Automating common solutions
- Implementing self-healing logic

### Effective Prompts

**Configuration Fixes**:

```powershell
Create PowerShell function to fix connection pool issues
Actions:
- Update App Service connection string with MaxPoolSize=200
- Add Connection Timeout=30, Command Timeout=60
- Restart app to apply changes
Parameters: AppServiceName, ResourceGroupName, WhatIf support
Include: Validation before and after changes
Output: Success/failure with before/after metrics
```

**Scaling Operations**:

```text
Create script to scale Azure resources based on metrics
If CPU > 85% for 10 minutes: Scale up App Service plan
If DTU > 90% for 5 minutes: Scale up SQL Database tier
Parameters: ResourceGroupName, AutoApprove (default false)
Include: Cost impact warning before scaling
Validation: Check if scaling is already in progress
```

**Network Troubleshooting**:

```powershell
Create function to resolve connectivity issues
Checks and fixes:
- NSG rules: Add missing allow rules
- Route table: Verify default routes
- DNS: Clear cache and test resolution
- Firewall: Check and update IP whitelist
Parameters: SourceResource, TargetResource, WhatIf
Output: Detailed report of checks and fixes applied
```

### Tips for Remediation Scripts

- Always request WhatIf parameter for safety
- Ask for validation before applying changes
- Include rollback procedures
- Request confirmation prompts for destructive actions
- Mention cost implications if relevant

## Pattern 5: Documentation Generation

### When to Use

- Creating post-incident reports
- Generating runbooks from troubleshooting sessions
- Documenting architecture and decisions

### Understanding the Audience

Before generating documentation, ask:

```text
"Who will read this document?"
- Executive summary → Business impact, resolution timeline, cost
- Technical post-mortem → Root cause, queries used, lessons learned
- Runbook → Step-by-step procedures for future incidents
- Team update → What happened, what we learned, action items

"What decision will they make from reading this?"
- Executives → Approve budget for fix? Change priorities?
- Engineers → Follow runbook? Avoid same mistake?
- Stakeholders → Trust the team? Understand impact?
```

### Effective Prompts

**Incident Post-Mortem**:

```bicep
Generate incident post-mortem report in Markdown
Input parameters:
- Incident title, start/end time, severity
- Timeline of events (array of timestamped actions)
- Root cause explanation
- Resolution steps taken
- Prevention recommendations
Output sections:
- Executive summary
- Impact analysis (users affected, revenue loss)
- Timeline with detailed narrative
- Root cause analysis with diagrams
- Lessons learned and action items
Format: Professional markdown suitable for management
```

**Troubleshooting Runbook**:

```text
Create troubleshooting runbook for [specific issue]
Include:
- Symptom description and detection methods
- Diagnostic steps with KQL queries and PowerShell commands
- Common causes ranked by likelihood
- Resolution procedures with step-by-step instructions
- Validation tests to confirm resolution
- Escalation path if steps don't resolve
Format: Markdown with code blocks and decision tree
```

**Architecture Documentation**:

```bicep
Document Azure architecture from resource inspection
Input: Resource group name or subscription
Generate:
- Component diagram (Mermaid syntax)
- Resource inventory with purposes
- Network topology
- Data flow description
- Security configuration (NSGs, firewall rules)
- Cost breakdown by service
Output: Comprehensive markdown documentation
```

### Tips for Documentation

- Specify exact sections needed
- Request specific formats (Markdown, HTML, PDF)
- Ask for diagrams in Mermaid syntax
- Include code blocks for commands/queries
- Mention audience (technical, management, executive)

## Pattern 6: Learning & Explanation

### When to Use

- Understanding unfamiliar concepts
- Getting best practices guidance
- Learning Azure service internals

### Effective Prompts

**Concept Explanation**:

```text
Explain Azure SQL connection pooling
Include:
- How connection pools work in Azure App Service
- MaxPoolSize parameter and how to set it
- Symptoms of connection pool exhaustion
- Best practices for sizing connection pools
- Monitoring techniques to track pool usage
Format: Clear explanation with examples
Target audience: Intermediate Azure developers
```

**Best Practices**:

```text
Provide Azure App Service best practices for high-traffic applications
Cover:
- Connection pooling configuration
- Timeout settings (connection, command, request)
- Retry logic and circuit breaker patterns
- Caching strategies
- Auto-scaling configuration
Include: Example configurations and code snippets
```

**Troubleshooting Guidance**:

```text
Explain how to troubleshoot Azure [specific issue]
Provide:
- Step-by-step diagnostic process
- Tools to use at each step (Portal, KQL, PowerShell)
- Common root causes ranked by frequency
- Diagnostic queries and scripts
- Decision tree for narrowing down cause
Format: Beginner-friendly tutorial
```

### Tips for Learning Prompts

- Specify your experience level
- Ask for examples and code snippets
- Request step-by-step explanations
- Mention specific Azure services
- Ask for common pitfalls to avoid

## Advanced Techniques

### Iterative Refinement

Start broad, then narrow:

**Step 1**: "Create PowerShell function to check App Service health"

- Review initial suggestion

**Step 2**: "Add parameter for checking last 4 hours of metrics"

- Copilot adds time range parameter

**Step 3**: "Include CPU, memory, and HTTP error rate metrics"

- Copilot enhances with specific metrics

**Step 4**: "Export results to HTML report with charts"

- Copilot adds export functionality

### Context Building

Provide context in comments before prompting:

```powershell
# Scenario: E-commerce platform experiencing intermittent checkout failures
# Environment: Azure App Service (10 instances, P2v3), SQL Database (P2 tier)
# Symptom: 15% of checkout attempts fail with HTTP 500
# Duration: Started 2 hours ago during traffic spike
# Business impact: $22K revenue loss per hour

# Create diagnostic script to identify root cause
```

Then Copilot has full context for generating relevant solutions.

### Multi-Step Workflows

Break complex tasks into steps:

**Step 1 - Detect**:

```

Create function to detect Azure App Service issues
Check: CPU, memory, response time, error rate
Return: List of detected issues with severity

```

**Step 2 - Analyze**:

```

For each detected issue, generate KQL query to analyze root cause
Return: Query results with insights

```

**Step 3 - Remediate**:

```

For each root cause, suggest and optionally apply remediation
Include: WhatIf mode for safety

```

**Step 4 - Document**:

```

Generate incident report from detection, analysis, and remediation steps
Format: Markdown with timeline and lessons learned

```

## Real-World Examples

### Example 1: RetailMax Incident

**Initial Prompt**:

```

Create PowerShell function to diagnose intermittent 5xx errors in Azure App Service checkout API
Check: Request success rate, response time percentiles, dependency health
Include: Automatic KQL query generation for Log Analytics
Output: Suspected root cause with confidence level

```

**Result**: Generated script that identified connection pool exhaustion in 10 minutes vs. 8 hours manual KQL iteration.

### Example 2: Database Performance

**Initial Prompt**:

```

Generate KQL query to find slow SQL queries causing API timeouts
Show: Query duration (avg, P95, P99), execution count, sample query text
Filter: Duration > 5 seconds in last 4 hours
Correlate with: Application Insights request failures

```

**Result**: Identified 3 missing indexes causing 12-second query times vs. 2 hours manual investigation.

### Example 3: Auto-Remediation

**Initial Prompt**:

```

Create PowerShell function to automatically scale Azure resources based on metrics
If App Service CPU > 85% for 10 min: Scale from P2v3 to P3v3
If SQL DTU > 90% for 5 min: Scale from P2 to P4
Include: Cost estimation, approval workflow, rollback capability

```

**Result**: Implemented self-healing that prevented 3 outages in first month.

## Troubleshooting Copilot

### If Suggestions Aren't Helpful

1. **Add More Context**:
   - Include Azure service names and tiers
   - Specify error messages or symptoms
   - Mention constraints (cost, time, compliance)

2. **Be More Specific**:
   - Use exact parameter names
   - Specify output format precisely
   - Include examples of desired output

3. **Break It Down**:
   - Split complex request into smaller steps
   - Get basic version working first
   - Iteratively add features

4. **Use Comments to Guide**:
   - Write comments describing each section needed
   - Let Copilot fill in implementation
   - Review and refine each section

### If Syntax Errors Occur

1. **Specify Language/Version**:
   - "PowerShell 7.2 compatible"
   - "KQL query for Azure Log Analytics"
   - "Bicep syntax (not ARM JSON)"

2. **Request Validation**:
   - "Include parameter validation"
   - "Add error handling for common failures"
   - "Validate input before executing"

3. **Ask for Corrections**:
   - "Fix syntax error in KQL query"
   - "Correct PowerShell parameter binding"
   - "Update to latest Azure PowerShell module syntax"

## Measuring Success

### Time Savings Metrics

Track these before/after metrics:

- **Query Creation Time**: 45 min → 2 min (96% faster)
- **Diagnostic Script Development**: 2 hours → 15 min (88% faster)
- **Root Cause Identification**: 8 hours → 1 hour (88% faster)
- **Documentation Time**: 2 hours → 20 min (83% faster)

### Quality Improvements

- **First-Time Success Rate**: 40% → 75% (fewer iterations)
- **Documentation Completeness**: 60% → 95% (auto-generated)
- **Best Practices Adoption**: 50% → 90% (Copilot suggests)
- **Knowledge Retention**: 30% → 70% (learn while coding)

## Conclusion

Effective prompting is a skill that improves with practice. Key principles:

1. **Start with discovery** — Ask the five discovery questions before any query
2. **Be specific** about context, symptoms, and desired outcomes
3. **State your hypothesis** — What are you trying to prove or disprove?
4. **Iterate** from basic to advanced functionality
5. **Validate** Copilot suggestions before applying in production
6. **Learn** from each interaction (Copilot teaches while helping)
7. **Share** effective prompts with your team

### The Discovery Checklist

Before every troubleshooting session:

- [ ] What exactly is failing? (Specific symptoms, error codes)
- [ ] Who is affected? (All users, specific segments, regions)
- [ ] When did it start? (Timeline, correlation with changes)
- [ ] What's the hypothesis? (What do you think is wrong?)
- [ ] What would confirm/disprove it? (Expected query results)
- [ ] What does "fixed" look like? (Success criteria)

With these patterns, you can achieve the 83% time reduction demonstrated in this scenario,
transforming Azure troubleshooting from a 30-hour ordeal into a 5-hour guided workflow.

**Remember**: You're still the expert. Copilot is your AI diagnostic partner, not an autopilot.
Review, validate, and apply your judgment to every suggestion.

---

**Additional Resources**:

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Azure Monitor KQL Reference](https://learn.microsoft.com/azure/azure-monitor/logs/kql-quick-reference)
- [PowerShell Best
Practices](https://learn.microsoft.com/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Azure Troubleshooting Guides](https://learn.microsoft.com/azure/well-architected/operational-excellence/)
