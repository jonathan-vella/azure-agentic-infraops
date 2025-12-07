# Time Tracking: With GitHub Copilot

**Engineer**: Demo User  
**Date**: January 2025  
**Scenario**: Deploy three-tier network infrastructure with secure storage  
**Approach**: Using GitHub Copilot for code generation

---

## Summary

| Metric                     | Time           | Notes                               |
| -------------------------- | -------------- | ----------------------------------- |
| **Total Development Time** | **10 minutes** | Complete infrastructure deployment  |
| **Lines of Code**          | 450+           | Generated from ~50 lines of prompts |
| **Errors Encountered**     | 0              | Zero deployment errors              |
| **Documentation Time**     | 2 minutes      | Auto-generated from code            |
| **Deployment Time**        | 3 minutes      | Azure deployment                    |
| **Total End-to-End**       | **15 minutes** | From start to verified deployment   |

---

## Detailed Timeline

### Phase 1: Network Infrastructure (4 minutes)

**00:00-00:30** - Create `network.bicep` file

- Open VS Code
- Create new file with `.bicep` extension
- Enable GitHub Copilot (verify status bar)

**00:30-02:00** - Generate VNet and Subnets (1.5 min)

- Type prompt: "Create an Azure Virtual Network named 'vnet-demo' with address space 10.0.0.0/16"
- Accept Copilot suggestion (Tab)
- Type prompt: "Include three subnets: web-tier (10.0.1.0/24), app-tier (10.0.2.0/24), data-tier (10.0.3.0/24)"
- Accept Copilot suggestion
- Add parameters for location and environment
- **Result**: Complete VNet with 3 subnets

**02:00-04:00** - Generate Network Security Groups (2 min)

- Type prompt: "Add a Network Security Group for the web tier subnet"
- Accept Copilot suggestion
- Type prompt: "Allow inbound HTTP (80) and HTTPS (443) from Internet"
- Accept Copilot suggestion
- Type prompt: "Allow outbound to app-tier subnet on port 8080"
- Accept Copilot suggestion
- Repeat for App tier NSG (allow from web, to data)
- Repeat for Data tier NSG (allow from app only)
- **Result**: 3 NSGs with complete rule sets

**Time Saved**: Copilot generated 200+ lines of code in 4 minutes (vs. 20+ minutes manually)

---

### Phase 2: Storage Infrastructure (3 minutes)

**04:00-04:30** - Create `storage.bicep` file (30 sec)

- Create new file
- Add header comments

**04:30-06:30** - Generate Storage Account (2 min)

- Type prompt: "Create a secure storage account for the application"
- Type prompt: "Requirements: Blob storage with hot tier, HTTPS only, TLS 1.2 minimum"
- Accept Copilot suggestion
- Type prompt: "Disable public blob access"
- Accept Copilot suggestion
- Type prompt: "Enable blob soft delete (7 days)"
- Accept Copilot suggestion
- **Result**: Fully secured storage account with all configurations

**06:30-07:00** - Add Blob Service Configuration (30 sec)

- Type prompt: "Configure blob services with container delete retention"
- Accept Copilot suggestion
- Add default container with `publicAccess: 'None'`
- **Result**: Blob services and default container

**Time Saved**: Copilot generated 180+ lines of secure storage code in 3 minutes (vs. 15+ minutes manually)

---

### Phase 3: Main Orchestration (2 minutes)

**07:00-07:30** - Create `main.bicep` file (30 sec)

- Create new file
- Add header comments and description

**07:30-09:00** - Generate Module References (1.5 min)

- Type prompt: "Main orchestration template"
- Type prompt: "Deploy the network and storage modules"
- Accept Copilot suggestion
- Type prompt: "Use parameters for location, environment (dev/prod), and tags"
- Accept Copilot suggestion
- Add aggregated outputs
- **Result**: Clean orchestration with module references

**Time Saved**: Copilot generated module structure in 2 minutes (vs. 5-7 minutes manually)

---

### Phase 4: Validation (1 minute)

**09:00-10:00** - Validate Bicep Code (1 min)

```powershell
# Build/compile
az bicep build --file main.bicep
# ✅ Success - no errors

# Validate against Azure
az deployment group validate `
  --resource-group rg-agentic-baseline-dev `
  --template-file main.bicep `
  --parameters environment=demo
# ✅ Validation passed
```

**Time Saved**: Zero errors on first try (vs. 3-5 iterations manually = 15+ minutes debugging)

---

## Comparison: Manual vs. Copilot

| Task                       | Manual Time | With Copilot | Time Saved | Improvement |
| -------------------------- | ----------- | ------------ | ---------- | ----------- |
| **Research Bicep Syntax**  | 10 min      | 0 min        | 10 min     | N/A         |
| **Write VNet Template**    | 15 min      | 4 min        | 11 min     | 73%         |
| **Write Storage Template** | 10 min      | 3 min        | 7 min      | 70%         |
| **Create Orchestration**   | 5 min       | 2 min        | 3 min      | 60%         |
| **Debug Errors**           | 10 min      | 0 min        | 10 min     | 100%        |
| **Documentation**          | 5 min       | 1 min        | 4 min      | 80%         |
| **Total**                  | **55 min**  | **10 min**   | **45 min** | **82%**     |

---

## Key Copilot Benefits Observed

### 1. Instant Code Generation

- **Observation**: Typed natural language prompts, got production code in seconds
- **Example**: "Create a secure storage account with TLS 1.2" → 50+ lines of code
- **Value**: No need to memorize Bicep syntax or look up documentation

### 2. Latest API Versions

- **Observation**: Copilot always suggested current API versions (2023-05-01, 2023-01-01)
- **Example**: `Microsoft.Network/virtualNetworks@2023-05-01`
- **Value**: No need to check documentation for version compatibility

### 3. Built-In Best Practices

- **Observation**: Security configurations included automatically
- **Examples**:
  - `supportsHttpsTrafficOnly: true`
  - `minimumTlsVersion: 'TLS1_2'`
  - `allowBlobPublicAccess: false`
  - Deny rules at priority 4096
- **Value**: near-production-ready security without research

### 4. Context Awareness

- **Observation**: Copilot understood relationships between resources
- **Examples**:
  - NSG automatically associated with subnets
  - Module outputs used correctly in main.bicep
  - Consistent naming conventions across files
- **Value**: Reduced cognitive load, fewer mistakes

### 5. Comprehensive Outputs

- **Observation**: Copilot added useful outputs without being asked
- **Examples**:
  - VNet ID, subnet IDs
  - Storage endpoints
  - Portal URLs
- **Value**: Easier to connect resources later

### 6. Zero Errors

- **Observation**: Code validated on first try
- **Impact**: No debugging cycles, no frustration
- **Value**: 10+ minutes saved, better developer experience

---

## What Copilot Didn't Do (Manual Work)

Even with Copilot, some tasks still required manual effort:

1. **Strategic Decisions** (human judgment):

   - Subnet sizing (/24 for each tier)
   - Port numbers (80, 443, 8080, 1433)
   - Soft delete retention (7 days)
   - Storage SKU selection (Standard_LRS)

2. **Project Organization** (structure):

   - Decision to use separate modules
   - File naming conventions
   - Repository structure

3. **Testing Strategy** (validation):
   - Deciding what to test
   - Writing deployment scripts
   - Verifying in Azure Portal

**Time for Manual Work**: ~5 minutes (included in 10-minute total)

---

## Learnings and Tips

### What Worked Well

✅ **Descriptive prompts**: "Create a secure storage account with..." worked better than "storage account"  
✅ **Iterative refinement**: Adding requirements one at a time let Copilot understand context  
✅ **Accepting suggestions**: Trusting Copilot's defaults (API versions, security) saved time  
✅ **Natural language**: Writing comments in plain English felt intuitive

### What Could Be Improved

⚠️ **Multi-file context**: Copilot doesn't always see other files (had to specify module paths)  
⚠️ **Complex logic**: For advanced scenarios (loops, conditionals), needed more guidance  
⚠️ **Custom requirements**: Very specific business rules still require manual coding

### Recommended Workflow

1. Start with natural language comment describing what you need
2. Let Copilot generate the basic structure
3. Refine with additional prompts for specific requirements
4. Review and adjust security settings
5. Validate before deploying

---

## ROI Calculation

### Time Savings

- **Manual approach**: 55 minutes
- **With Copilot**: 10 minutes
- **Time saved**: 45 minutes (82% reduction)

### Time Savings (for a team)

Assuming:

- Team of 5 engineers
- Deploying infrastructure 3x per week

**Monthly Time Savings**:

- Time saved per deployment: 45 min
- Deployments per month: 3 × 4 = 12
- Total time saved per engineer: 12 × 45 min = 9 hours
- Team time saved: 9 × 5 = **45 hours/month**

**Annual Time Savings**: **540 hours** for a team of 5 (~0.26 FTE freed up)

### Productivity Gains

- **Faster delivery**: Infrastructure ready in 10 min instead of 1 hour
- **Reduced errors**: Zero bugs on first deployment
- **Learning acceleration**: No training required, learn by doing
- **Better quality**: near-production-ready code with security best practices

---

## Conclusion

GitHub Copilot transformed a 55-minute task into a 10-minute task, saving 82% of development time.
The code quality was excellent, with zero errors on first deployment,
and all security best practices were included automatically.

**Key Takeaway**: Copilot isn't just about typing less—it's about thinking at a higher level.
Instead of worrying about Bicep syntax and API versions, I focused on architecture and business requirements.
That's the real value.

---

[🏠 Back to Demo README](../README.md)
