# Scenario: TechCorp Solutions - Infrastructure Standardization

## Company Profile

**Name**: TechCorp Solutions  
**Industry**: Software-as-a-Service (SaaS)  
**Size**: 450 employees, 15 development teams  
**Revenue**: Mid-market SaaS company  
**Cloud Maturity**: Intermediate (2 years on Azure)

### Business Context

TechCorp Solutions provides a multi-tenant SaaS platform for project management and collaboration. They operate in a competitive market where time-to-market and reliability are critical success factors.

**Recent Growth**:

- 3x customer growth in 18 months
- Expanded from 5 to 15 development teams
- Added 8 new features/quarter (up from 3)
- Launched in 3 new geographic markets

### Technical Landscape

**Current Azure Footprint**:

- 45 subscriptions (3 per team: dev, staging, prod)
- 600+ virtual machines
- 180+ App Services
- 90+ SQL Databases
- Multi-region deployment (North Europe, West US, Southeast Asia)

**Development Teams**:

- Each team owns 2-3 microservices
- Teams have autonomy to choose tools and patterns
- Mix of Bicep, ARM templates, manual Portal clicks
- Some teams using Terraform, but inconsistent patterns

---

## Current State Analysis

### Pain Points

#### 1. Infrastructure Inconsistency

**Problem**: Each development team deploys infrastructure differently.

**Examples**:

- **Team Alpha**: Uses Bicep with basic modules
- **Team Beta**: Manual Portal deployments with ARM export
- **Team Gamma**: Terraform v0.14 (outdated)
- **Team Delta**: Azure CLI scripts in Bash
- **Team Epsilon**: Mix of PowerShell and Portal

**Impact**:

- Impossible to audit security posture across teams
- No consistent naming or tagging
- Configuration drift between environments
- Difficult to share learnings or best practices

#### 2. Long Deployment Times

**Problem**: New environment provisioning takes 3-5 days per team.

**Breakdown**:

- **Day 1**: Research Azure services and patterns (4-6 hours)
- **Day 2**: Write infrastructure code (6-8 hours)
- **Day 3**: Debug deployment errors (4-8 hours)
- **Day 4**: Security review and remediation (3-6 hours)
- **Day 5**: Documentation and handoff (2-4 hours)

**Impact**:

- Slow time-to-market for new features
- Expensive engineer time (15 teams × 5 days = 75 days/month)
- Product teams frustrated with infrastructure delays

#### 3. High Error Rate

**Problem**: 40% of infrastructure deployments require remediation.

**Common Errors**:

- ❌ Syntax mistakes in HCL/Bicep
- ❌ Missing dependencies (VNet created before subnets fail)
- ❌ Hard-coded values causing conflicts
- ❌ Incorrect SKU tiers (Standard instead of Premium for production)
- ❌ Missing outputs (connection strings not exported)
- ❌ State file conflicts in Terraform

**Impact**:

- Delays cascade to application deployments
- Engineers lose confidence in IaC
- Teams revert to manual Portal deployments

#### 4. Security Vulnerabilities

**Problem**: Security audit discovered 23 critical findings across infrastructure.

**Findings**:

- 🔴 **12 databases** with public endpoints exposed
- 🔴 **8 App Services** without managed identities
- 🔴 **18 NSGs** with overly permissive rules (0.0.0.0/0)
- 🔴 **5 storage accounts** without encryption at rest
- 🟡 **35 resources** missing required tags (CostCenter, Owner)
- 🟡 **20 resources** using outdated TLS 1.0/1.1

**Impact**:

- Compliance risk (SOC 2, ISO 27001 certifications)
- Potential data breach exposure
- Customer trust concerns
- Remediation effort: Significant engineering time investment required

#### 5. Knowledge Silos

**Problem**: Infrastructure expertise concentrated in 3-4 senior engineers.

**Consequences**:

- Bottleneck for code reviews
- Junior engineers copy-paste code without understanding
- No onboarding materials for new hires
- Bus factor risk (what if key person leaves?)

#### 6. No Automated Testing

**Problem**: Infrastructure changes deployed without validation.

**Risk Scenarios**:

- NSG rules accidentally block application traffic
- Database connection strings misconfigured
- Private endpoint DNS not resolving
- SKU changes cause unexpected downtime

**Impact**:

- Production incidents due to infrastructure changes
- Mean Time To Resolution (MTTR) increased 40%
- On-call burden for engineers

---

## Requirements

### Functional Requirements

#### FR1: Terraform Module Library

**Description**: Create reusable Terraform modules for all common infrastructure patterns.

**Modules Needed**:

1. **Networking**
   - Virtual Network with subnet delegation
   - Network Security Groups with least-privilege rules
   - Private DNS zones
   - Application Gateway with WAF v2

2. **Compute**
   - App Service with zone redundancy
   - App Service Plan (P1v3 SKU)
   - Managed Identity configuration
   - Private endpoint integration

3. **Data**
   - Azure SQL Database with private endpoint
   - SQL Server with Azure AD admin only
   - Advanced Threat Protection
   - Geo-redundant backup configuration

4. **Security & Monitoring**
   - Key Vault with RBAC
   - Log Analytics workspace
   - Application Insights
   - Diagnostic settings for all resources

**Acceptance Criteria**:

- [x] Modules follow DRY principles
- [x] All variables have validation rules
- [x] Comprehensive outputs for resource IDs
- [x] README with usage examples
- [x] Compatible with Terraform v1.5+

#### FR2: Multi-Environment Support

**Description**: Support deployment to dev, staging, and prod with environment-specific configurations.

**Requirements**:

- Separate `terraform.tfvars` per environment
- Environment-specific resource sizing (S0 for dev, S3 for prod)
- Resource naming includes environment suffix
- Different backup retention (7 days dev, 35 days prod)
- Cost-optimized SKUs for non-production

**Acceptance Criteria**:

- [x] Infrastructure works in all 3 environments
- [x] No code duplication (DRY principle)
- [x] Clear separation of concerns
- [x] Variables enforce environment constraints

#### FR3: Remote State Management

**Description**: Centralized Terraform state in Azure Storage with locking.

**Requirements**:

- Azure Storage Account for state (LRS in dev, GRS in prod)
- Blob container with versioning enabled
- State locking using Azure Storage lease
- State encrypted at rest
- RBAC for state access (engineers can read, only CI/CD can write)

**Acceptance Criteria**:

- [x] No local state files committed to Git
- [x] State conflicts prevented by locking
- [x] Audit log of state changes
- [x] Disaster recovery plan documented

#### FR4: Security Hardening

**Description**: All infrastructure must follow security best practices by default.

**Security Requirements**:

- ✅ All data services use private endpoints (no public access)
- ✅ Managed Identity for service-to-service authentication
- ✅ NSGs with deny-by-default rules
- ✅ TLS 1.2 minimum for all endpoints
- ✅ Encryption at rest enabled
- ✅ Advanced Threat Protection for databases
- ✅ Key Vault for secrets (no hard-coded credentials)
- ✅ RBAC assignments follow least-privilege principle

**Acceptance Criteria**:

- [x] Zero critical findings from Checkov/tfsec
- [x] Microsoft Defender for Cloud score >90%
- [x] Passes SOC 2 audit requirements
- [x] All Azure Security Benchmark controls met

#### FR5: Automated Testing

**Description**: Infrastructure code must be tested before deployment.

**Test Types**:

1. **Static Analysis**
   - Terraform validate
   - Terraform fmt check
   - tfsec security scanning
   - Checkov policy validation

2. **Unit Tests**
   - Terratest for each module
   - Verify outputs are correct
   - Test variable validation

3. **Integration Tests**
   - Deploy to test subscription
   - Verify connectivity between tiers
   - Test application deployment

**Acceptance Criteria**:

- [x] All tests automated in CI/CD
- [x] Tests run on every PR
- [x] 95%+ test pass rate
- [x] Test results visible in dashboard

### Non-Functional Requirements

#### NFR1: Performance

- **Deployment time**: < 15 minutes for full stack
- **Plan execution**: < 2 minutes
- **Module reusability**: Modules work across teams without modification

#### NFR2: Maintainability

- **Code clarity**: Self-documenting with clear variable names
- **Documentation**: Auto-generated README files
- **Version control**: Semantic versioning for modules
- **Change tracking**: Git history with meaningful commits

#### NFR3: Cost Optimization

- **Dev environment**: Low monthly cost per team (optimized SKUs)
- **Staging environment**: Moderate monthly cost per team (production-like)
- **Production environment**: Higher monthly cost per team (based on scale and redundancy)
- **Cost visibility**: Tags for chargeback (CostCenter, Owner)

#### NFR4: Compliance

- **Audit trail**: All changes logged and reviewable
- **Policy enforcement**: Azure Policy integration
- **Secret management**: No secrets in code or state
- **Data sovereignty**: Resources deployed in compliant regions

---

## Success Metrics

### Quantitative Metrics

| Metric | Current State | Target State | Timeline |
|--------|--------------|--------------|----------|
| **Environment Provisioning** | 3-5 days | 1 hour | 3 months |
| **Deployment Error Rate** | 40% | < 5% | 3 months |
| **Security Findings** | 23 critical | 0 critical | 6 months |
| **Engineer Productivity** | 60 hours/project | 6 hours/project | 3 months |
| **Code Reusability** | 20% | 90% | 6 months |
| **Team Standardization** | 15 different patterns | 1 standard | 6 months |

### Qualitative Success Factors

- ✅ Engineers feel confident deploying infrastructure
- ✅ Security team approves modules for production use
- ✅ Product managers see faster feature delivery
- ✅ New hires productive within 1 week (vs. 1 month)
- ✅ C-level leadership confident in cloud security posture

---

## Stakeholders

### Primary Stakeholders

**CTO - Michelle Chen**

- **Concern**: "We're scaling fast but infrastructure is a bottleneck"
- **Success Criteria**: 50% faster time-to-market for new features

**VP Engineering - Marcus Rodriguez**

- **Concern**: "Every team does infrastructure differently - it's chaos"
- **Success Criteria**: Standardized patterns across all 15 teams

**Director of Security - Priya Patel**

- **Concern**: "Latest audit found 23 critical issues - we can't scale this way"
- **Success Criteria**: Zero critical security findings in next audit

**Director of Cloud Operations - James O'Connor**

- **Concern**: "We have significant Azure spending, but can't track who's spending what"
- **Success Criteria**: Full cost visibility with chargeback per team

### Secondary Stakeholders

**Development Team Leads** (15 people)

- Want autonomy but need guardrails
- Frustrated with deployment delays
- Looking for best practices guidance

**Junior Engineers** (40 people)

- Overwhelmed by Terraform complexity
- Copy-pasting code without understanding
- Need onboarding materials

**Finance Team**

- Need cost allocation per department
- Require accurate forecasting
- Want showback/chargeback

---

## Constraints

### Technical Constraints

- **Azure-only**: Multi-cloud not required (but Terraform chosen for future optionality)
- **Existing subscriptions**: Must work with current subscription structure
- **Network topology**: Existing hub-spoke network must be preserved
- **Compliance**: Must meet SOC 2 and ISO 27001 requirements

### Business Constraints

- **Budget**: Limited implementation budget (consulting + tools)
- **Timeline**: 3 months to pilot with 3 teams, 6 months full rollout
- **Training**: Max 2 days per team for training
- **Change management**: Can't disrupt current production deployments

### Organizational Constraints

- **Skill levels**: Mix of junior and senior engineers
- **Resistance to change**: Some teams prefer current tools
- **Time allocation**: Engineers only have 20% time for this initiative
- **Leadership support**: CTO committed, but VP Engineering skeptical

---

## Out of Scope (Phase 1)

The following are **not** part of this initial project:

- ❌ Kubernetes/AKS deployments (separate initiative)
- ❌ Multi-cloud (AWS/GCP) support
- ❌ Migration of existing infrastructure (Phase 2)
- ❌ Application code deployment (handled by CI/CD)
- ❌ Data migration or database schema management
- ❌ Custom Azure Policy definitions (use built-in policies)

These may be addressed in future phases after initial success.

---

## Implementation Approach

### Phase 1: Pilot (Weeks 1-4)

- Select 3 teams for pilot
- Build core modules (networking, app-service, database)
- Deploy to dev environments only
- Gather feedback and iterate

### Phase 2: Expand (Weeks 5-8)

- Refine modules based on pilot feedback
- Add staging and prod support
- Implement CI/CD pipelines
- Train additional 5 teams

### Phase 3: Rollout (Weeks 9-12)

- Onboard remaining 7 teams
- Migrate 1-2 production workloads
- Document lessons learned
- Plan Phase 2 (migration of existing infra)

---

## GitHub Copilot Role

### How Copilot Accelerates This Project

1. **Module Development** (90% time reduction)
   - Generates HCL syntax correctly
   - Suggests Azure best practices
   - Creates variable validation automatically

2. **Security Hardening** (Automatic suggestions)
   - Private endpoints by default
   - Managed Identity patterns
   - NSG rules with least privilege

3. **Testing Code** (85% time reduction)
   - Generates Terratest unit tests
   - Creates validation scripts
   - Suggests test scenarios

4. **Documentation** (95% time reduction)
   - Auto-generates README files
   - Creates usage examples
   - Documents variable descriptions

### Expected Outcomes with Copilot

- **60 hours → 6 hours** per infrastructure project
- **40% error rate → 5%** due to syntax correctness
- **23 critical findings → 0** with security suggestions
- **3-5 days → 1 hour** for environment provisioning

---

**Next Steps**: Review `architecture.md` for the target infrastructure design.
