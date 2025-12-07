# Issue Option B: Full Demo

> **Use this for:** 10-15 minute demos, comprehensive demonstrations, customer presentations
> **Complexity:** Medium - alerts, action group, email notifications
> **Expected Copilot time:** 5-10 minutes

---

## Issue Title

```
Add comprehensive Azure Monitor alerts with notifications to patient portal
```

## Issue Body

```markdown
## Add Azure Monitor Alerts with Action Group

### Context
The patient portal infrastructure in `infra/bicep/contoso-patient-portal/` was deployed 
but lacks monitoring. Before production go-live, we need comprehensive alerting with 
email notifications for the operations team.

### Requirements

**Alert Rules (4 total):**

1. **CPU Alert**
   - Metric: Percentage CPU
   - Condition: Average > 80% for 5 minutes
   - Severity: 2 (Warning)
   - Action: Notify via action group

2. **Memory Alert**
   - Metric: Memory Percentage
   - Condition: Average > 85% for 5 minutes
   - Severity: 2 (Warning)
   - Action: Notify via action group

3. **HTTP 5xx Errors**
   - Metric: Http5xx
   - Condition: Total > 10 in 5 minutes
   - Severity: 1 (Error)
   - Action: Notify via action group

4. **Response Time Alert**
   - Metric: HttpResponseTime
   - Condition: Average > 3 seconds for 5 minutes
   - Severity: 2 (Warning)
   - Action: Notify via action group

**Action Group:**
- Name: `ag-patient-portal-${environment}`
- Email receiver with configurable address (parameter)
- Short name: `PatientPortal`

### Implementation Requirements

**New files:**
- `modules/monitoring-alerts.bicep` - Alert rules and action group

**Modify:**
- `main.bicep` - Add module reference with parameters
- `README.md` - Add monitoring documentation section

**Parameters to expose:**
- `alertEmailAddress` (string) - Email for alert notifications
- `enableAlerts` (bool, default: true) - Toggle alerts on/off

**Standards:**
- Follow naming pattern: `alert-{metric}-{appName}`
- Use `swedencentral` region (or inherit from main)
- Tags: Environment, ManagedBy, Project, Owner
- Reference existing Log Analytics workspace output

### Acceptance Criteria

- [ ] `bicep build main.bicep` succeeds with no errors
- [ ] `bicep lint main.bicep` passes with no warnings
- [ ] 4 alert rules created with specified thresholds
- [ ] Action group configured with email receiver
- [ ] All alerts linked to action group
- [ ] Module follows existing naming conventions
- [ ] Parameters properly wired through main.bicep
- [ ] README.md updated with monitoring section including:
  - What alerts are configured
  - How to customize thresholds
  - How to add additional alert receivers
```

---

## Copy-Paste Version

Copy everything below the line for quick issue creation:

---

## Add Azure Monitor Alerts with Action Group

### Context
The patient portal infrastructure in `infra/bicep/contoso-patient-portal/` was deployed but lacks monitoring.
Before production go-live, we need comprehensive alerting with email notifications for the operations team.

### Requirements

**Alert Rules (4 total):**

1. **CPU Alert**
   - Metric: Percentage CPU
   - Condition: Average > 80% for 5 minutes
   - Severity: 2 (Warning)
   - Action: Notify via action group

2. **Memory Alert**
   - Metric: Memory Percentage
   - Condition: Average > 85% for 5 minutes
   - Severity: 2 (Warning)
   - Action: Notify via action group

3. **HTTP 5xx Errors**
   - Metric: Http5xx
   - Condition: Total > 10 in 5 minutes
   - Severity: 1 (Error)
   - Action: Notify via action group

4. **Response Time Alert**
   - Metric: HttpResponseTime
   - Condition: Average > 3 seconds for 5 minutes
   - Severity: 2 (Warning)
   - Action: Notify via action group

**Action Group:**
- Name: `ag-patient-portal-${environment}`
- Email receiver with configurable address (parameter)
- Short name: `PatientPortal`

### Implementation Requirements

**New files:**
- `modules/monitoring-alerts.bicep` - Alert rules and action group

**Modify:**
- `main.bicep` - Add module reference with parameters
- `README.md` - Add monitoring documentation section

**Parameters to expose:**
- `alertEmailAddress` (string) - Email for alert notifications
- `enableAlerts` (bool, default: true) - Toggle alerts on/off

**Standards:**
- Follow naming pattern: `alert-{metric}-{appName}`
- Use `swedencentral` region (or inherit from main)
- Tags: Environment, ManagedBy, Project, Owner
- Reference existing Log Analytics workspace output

### Acceptance Criteria

- [ ] `bicep build main.bicep` succeeds with no errors
- [ ] `bicep lint main.bicep` passes with no warnings
- [ ] 4 alert rules created with specified thresholds
- [ ] Action group configured with email receiver
- [ ] All alerts linked to action group
- [ ] Module follows existing naming conventions
- [ ] Parameters properly wired through main.bicep
- [ ] README.md updated with monitoring section including:
  - What alerts are configured
  - How to customize thresholds
  - How to add additional alert receivers
