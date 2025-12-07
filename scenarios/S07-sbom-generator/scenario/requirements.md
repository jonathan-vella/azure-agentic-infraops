# Scenario: HealthTech Solutions SBOM Compliance Requirements

## Company Background

**Company**: HealthTech Solutions Inc.  
**Industry**: Healthcare SaaS Provider  
**Headquarters**: Seattle, WA  
**Employees**: 250  
**Annual Revenue**: $45M  
**Customers**: 150+ healthcare organizations (hospitals, clinics, physician groups)

## Current Situation

HealthTech Solutions develops a patient engagement platform that includes appointment scheduling, secure messaging,
prescription management, and health record access.
The platform is built on modern cloud technologies and deployed on Microsoft Azure.

### Application Stack

**Frontend**:

- React-based web application
- TypeScript/JavaScript
- Modern UI framework dependencies

**Backend**:

- Node.js API (Express framework)
- TypeScript for type safety
- 20+ npm package dependencies

**Data Layer**:

- Azure Cosmos DB (MongoDB API)
- Structured and unstructured patient data
- HIPAA-compliant encryption at rest

**Infrastructure**:

- Azure App Service (PaaS)
- Azure Key Vault (secrets management)
- Azure Monitor (logging and monitoring)
- Private networking with VNet integration

**Container**:

- Docker containerization
- Node.js 20 Alpine Linux base image
- Deployed via Azure Container Registry

## The Compliance Challenge

### Regulatory Requirements

HealthTech Solutions must comply with multiple regulations:

1. **HIPAA (Health Insurance Portability and Accountability Act)**
   - Quarterly security audits required
   - Must document all software components handling PHI (Protected Health Information)
   - Demonstrate supply chain security controls

2. **SOC 2 Type II Certification**
   - Annual audit by third-party assessor
   - Requires comprehensive asset inventory
   - Must track software components and versions

3. **HITRUST CSF (Common Security Framework)**
   - Pursuing certification for enterprise customers
   - Requires software bill of materials for all systems
   - Regular updates to component inventory

4. **Executive Order 14028 (Federal Customers)**
   - Federal healthcare agencies require SBOMs
   - Must use industry-standard formats (CycloneDX or SPDX)
   - Updated SBOMs required with each release

### Customer Requirements

**Enterprise Security Questionnaires**:

- Large hospital systems require detailed SBOM as part of procurement
- Questions include:
  - "Provide a complete list of third-party software components"
  - "What open-source licenses are used in your application?"
  - "How do you track vulnerabilities in dependencies?"
  - "Can you identify affected systems within 24 hours of CVE disclosure?"

**Security Incident Response**:

- When Log4Shell was disclosed (Dec 2021), took 3 days to verify they weren't affected
- Customers demanded faster response times
- Manual component tracking was too slow

### Current Process (Manual)

**Quarterly SBOM Generation** (led by Security Team):

1. **Application Dependencies** (90 minutes)
   - Open package.json files manually
   - Copy each dependency name and version to Excel
   - Research licenses on npmjs.com
   - Cross-reference with security vulnerability databases
   - Often miss devDependencies or nested dependencies

2. **Container Components** (120 minutes)
   - Review Dockerfile line by line
   - Research base image (node:20-alpine) components
   - Query Alpine Linux package database for OS packages
   - Document Node.js version and system libraries
   - Manual work, prone to errors

3. **Azure Infrastructure** (60 minutes)
   - Login to Azure Portal
   - Navigate to each resource manually
   - Record resource type, SKU, region, version
   - Screenshot configurations for documentation
   - Excel spreadsheet for tracking

4. **Format to SBOM Standard** (90 minutes)
   - Research CycloneDX or SPDX schema
   - Manually create JSON document
   - Ensure all required fields present
   - Validate against schema (often fails first try)
   - Debug JSON syntax errors

5. **Generate Reports** (60 minutes)
   - Create PowerPoint slides for stakeholders
   - Generate CSV for security tools
   - Write summary document for auditors
   - Email to compliance team for review

**Total Time**: **6 hours per SBOM**  
**Frequency**: **Quarterly** (4 times per year = 24 hours annually)  
**Accuracy**: **~80%** (typically miss 20% of components)  
**Format**: **Inconsistent** (varies by person creating it)

### Pain Points

1. **Time-Consuming**: Senior security engineer spends full day on each SBOM
2. **Error-Prone**: Manual process leads to missing components
3. **Outdated**: Quarterly updates mean SBOM is stale within weeks
4. **Inefficient**: Can't reuse work, starts from scratch each time
5. **Unscalable**: Adding new applications multiplies effort
6. **Slow Response**: When vulnerabilities disclosed, takes days to assess impact
7. **Customer Pressure**: Enterprise customers want SBOMs within 48 hours of request
8. **Audit Findings**: Recent SOC2 audit cited "incomplete component documentation"

## Desired Outcome

### Goals

1. **Automate SBOM Generation**: Reduce 6 hours to <1 hour
2. **Increase Accuracy**: Capture 98%+ of components automatically
3. **Enable Continuous Compliance**: Generate SBOM on every deployment
4. **Multi-Format Support**: Output CycloneDX, SPDX, HTML, CSV
5. **Integrate into CI/CD**: Make SBOM part of build pipeline
6. **Faster Response**: Query SBOMs immediately when CVE disclosed
7. **Customer Ready**: Provide professional SBOM within hours of request

### Success Criteria

| Metric | Current (Manual) | Target (Automated) |
|--------|------------------|-------------------|
| **Time to Generate** | 6 hours | <1 hour |
| **Components Identified** | ~45 (80% coverage) | ~60 (98% coverage) |
| **Update Frequency** | Quarterly | Every deployment |
| **Formats Supported** | 1-2 | 5+ (CycloneDX, SPDX, HTML, CSV, Markdown) |
| **Response Time (CVE)** | 3 days | 4 hours |
| **Customer Delivery** | 5 business days | Same day |
| **Accuracy** | 80% | 98% |
| **Cost per SBOM** | $900 (6 hrs × $150) | $150 (1 hr × $150) |

### Requirements

**Functional Requirements**:

1. Scan npm dependencies from package.json (both dependencies and devDependencies)
2. Analyze Docker container for base image components
3. Query Azure infrastructure for deployed resource inventory
4. Generate CycloneDX 1.5 format (primary)
5. Support SPDX 2.3 format (secondary)
6. Export HTML report for non-technical stakeholders
7. Export CSV for vulnerability scanning tools
8. Validate SBOM against industry schemas
9. Include metadata: timestamp, version, organization
10. Merge multiple SBOMs into unified document

**Non-Functional Requirements**:

1. Run entirely in PowerShell (compatible with Windows + Azure DevOps)
2. Use Azure CLI for infrastructure queries (already deployed)
3. No additional licensing costs (leverage existing tools)
4. Integrate with GitHub Copilot for script generation
5. Version control friendly (JSON output, no binary formats)
6. Idempotent (can run multiple times safely)
7. Secure (no secrets in SBOM output)
8. Fast (<15 minutes end-to-end execution)

### Stakeholders

| Role | Need | Success Metric |
|------|------|----------------|
| **CISO** | Demonstrate supply chain security controls | Pass SOC2/HITRUST audits |
| **Security Engineer** | Automate tedious SBOM creation | Save 20+ hours per year |
| **Compliance Officer** | Always-current component inventory | No audit findings |
| **DevOps Engineer** | Integrate into CI/CD pipeline | Zero manual steps |
| **Sales Team** | Respond to customer questionnaires faster | Provide SBOM same-day |
| **Executive Team** | Reduce compliance costs | $3,000/year savings per app |

## Technology Constraints

**Existing Tools** (already deployed):

- Azure CLI (authenticated)
- PowerShell 7.0+
- Node.js 18+ (for sample app)
- Docker Desktop (for container scanning)
- VS Code with GitHub Copilot

**Approved for Use**:

- Open-source SBOM scanners (Syft, CycloneDX CLI)
- Azure Resource Graph queries
- GitHub Copilot for script generation
- Industry-standard SBOM formats (CycloneDX, SPDX)

**Not Allowed**:

- SaaS SBOM platforms (budget constraints)
- Commercial vulnerability scanners (separate procurement)
- Third-party data egress (HIPAA concerns)

## Timeline

**Pilot Phase** (Week 1-2):

- Generate SBOM for patient portal application
- Validate output with security team
- Present to compliance officer

**Production Rollout** (Week 3-4):

- Integrate into Azure DevOps pipeline
- Train 3 security engineers on process
- Document runbooks and procedures

**Scale** (Month 2-3):

- Extend to all 5 production applications
- Quarterly audit with automated SBOMs
- Customer delivery process for SBOMs

**Success Milestone**: Pass Q2 SOC2 audit with automated SBOM process

## Time Investment

**Current Annual Effort** (manual process):

- Security engineer time: 24 hours/year
- Audit findings remediation: ~10 hours/year
- **Total: 34 hours per year**

**Target Annual Effort** (automated):

- Security engineer time: 4 hours/year
- Setup and maintenance: ~2 hours/year
- **Total: 6 hours per year**

**Annual Time Savings**: **28 hours** (82% reduction)

## Risk Mitigation

**Risk**: SBOM automation misses critical components  
**Mitigation**: Validate first 3 SBOMs manually, compare to baseline

**Risk**: False positives in SBOM (components not actually used)  
**Mitigation**: Focus on production dependencies, filter devDependencies optionally

**Risk**: Integration with CI/CD delays deployments  
**Mitigation**: Run SBOM generation async, don't block deployment

**Risk**: Resistance from security team (prefer manual control)  
**Mitigation**: Pilot with one application, demonstrate time savings

**Risk**: SBOM format changes (CycloneDX/SPDX updates)  
**Mitigation**: Version control scripts, monitor spec updates quarterly

---

**Document Owner**: Sarah Chen, CISO  
**Contributors**: Security Team, Compliance Office, DevOps  
**Last Updated**: November 18, 2025  
**Review Cycle**: Quarterly
