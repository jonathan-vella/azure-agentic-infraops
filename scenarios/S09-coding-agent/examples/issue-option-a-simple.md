# Issue Option A: Simple (Quick Demo)

> **Use this for:** 5-minute demos, proof of concept, time-constrained presentations
> **Complexity:** Low - 3 basic alert rules
> **Expected Copilot time:** 2-5 minutes

---

## Issue Title

```
Add basic Azure Monitor alerts to patient portal
```

## Issue Body

```markdown
## Add Basic Monitoring Alerts

### Context
The patient portal infrastructure in `infra/bicep/contoso-patient-portal/` needs basic 
monitoring before production deployment. Currently there are no alert rules configured.

### Requirements

**Create 3 alert rules:**

1. **CPU Alert**
   - Metric: Percentage CPU
   - Condition: Greater than 80%
   - Window: 5 minutes
   - Severity: 2 (Warning)

2. **Memory Alert**
   - Metric: Memory Percentage  
   - Condition: Greater than 85%
   - Window: 5 minutes
   - Severity: 2 (Warning)

3. **HTTP Server Errors**
   - Metric: Http5xx
   - Condition: Greater than 10
   - Window: 5 minutes
   - Severity: 1 (Error)

### Implementation

- Create new module: `modules/alerts.bicep`
- Reference existing App Service from `modules/app-service.bicep`
- Use existing Log Analytics workspace
- Default region: `swedencentral`
- Include tags: Environment, ManagedBy, Project

### Acceptance Criteria

- [ ] `bicep build main.bicep` succeeds
- [ ] 3 alert rules created
- [ ] Module wired into main.bicep
- [ ] Follows existing code patterns
```

---

## Copy-Paste Version

Copy everything below the line for quick issue creation:

---

## Add Basic Monitoring Alerts

### Context
The patient portal infrastructure in `infra/bicep/contoso-patient-portal/` needs basic monitoring before production
deployment. Currently there are no alert rules configured.

### Requirements

**Create 3 alert rules:**

1. **CPU Alert**
   - Metric: Percentage CPU
   - Condition: Greater than 80%
   - Window: 5 minutes
   - Severity: 2 (Warning)

2. **Memory Alert**
   - Metric: Memory Percentage  
   - Condition: Greater than 85%
   - Window: 5 minutes
   - Severity: 2 (Warning)

3. **HTTP Server Errors**
   - Metric: Http5xx
   - Condition: Greater than 10
   - Window: 5 minutes
   - Severity: 1 (Error)

### Implementation

- Create new module: `modules/alerts.bicep`
- Reference existing App Service from `modules/app-service.bicep`
- Use existing Log Analytics workspace
- Default region: `swedencentral`
- Include tags: Environment, ManagedBy, Project

### Acceptance Criteria

- [ ] `bicep build main.bicep` succeeds
- [ ] 3 alert rules created
- [ ] Module wired into main.bicep
- [ ] Follows existing code patterns
