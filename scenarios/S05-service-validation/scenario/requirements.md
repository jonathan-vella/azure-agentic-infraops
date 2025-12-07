# S05 Service Validation - Requirements

## Business Context

### Customer Profile

**Company**: Contoso Healthcare Systems  
**Industry**: Healthcare Technology  
**Size**: Mid-market (500-2000 employees)  
**Region**: Europe (GDPR compliance required)  
**Current State**: Migrating legacy applications to Azure

### Business Challenge

Contoso Healthcare is undergoing a digital transformation and migrating their patient management system to Azure.
As part of their Azure Infrastructure Specialization journey, they must demonstrate **Module B Control 4.1: Service
Validation and Testing**.

**Key Pain Points:**

1. **Manual Testing Overhead**: Current validation process takes 40+ hours per release
2. **Inconsistent Testing**: Different testers use different approaches, leading to gaps
3. **Audit Requirements**: Healthcare regulations require documented evidence of testing
4. **Performance Unknown**: No baseline metrics for service performance
5. **Downtime Risk**: Lack of resilience testing leads to unexpected outages

### Business Objectives

1. **Reduce Validation Time**: Cut testing cycle from 40 hours to < 10 hours (75% reduction)
2. **Automate Testing**: Implement automated load testing, API validation, and resilience checks
3. **Audit Compliance**: Generate audit-ready validation reports with evidence
4. **Performance Baseline**: Establish and track performance metrics over time
5. **Quality Assurance**: Ensure 99.9% availability and < 500ms response times

---

## Technical Requirements

### Application Profile

**Application**: SAIF API v2 (Secure AI Framework)  
**Technology Stack**:

- **Backend**: Python 3.11 (FastAPI framework)
- **Database**: Azure SQL Database (Entra ID authentication)
- **Containers**: Azure Container Registry + App Service (Linux)
- **Monitoring**: Application Insights + Log Analytics

**API Endpoints**:

- `GET /` - Health check and application metadata
- `GET /api/version` - Application version information
- `GET /api/whoami` - Managed identity information
- `GET /api/sourceip` - Client IP address
- `GET /api/sqlwhoami` - SQL database identity verification
- `GET /api/sqlsrcip` - SQL connection information

### Infrastructure Requirements

#### Compute

- **App Service Plan**: Premium P1v3 (zone redundancy)
- **App Services**: 2 instances (API + Web frontend)
- **Scaling**: Manual scaling for demo (auto-scale for production)

#### Data

- **SQL Server**: Entra ID-only authentication (no SQL auth)
- **SQL Database**: Basic tier for demo (Standard/Premium for production)
- **Data Residency**: Sweden Central (EU data sovereignty)

#### Security

- **Authentication**: Azure Managed Identity (no connection strings)
- **Network**: HTTPS-only, TLS 1.2 minimum
- **Secrets**: Azure Key Vault for sensitive configuration
- **Access Control**: RBAC for all resources

#### Monitoring

- **Application Insights**: Request tracking, dependency monitoring, exceptions
- **Log Analytics**: Centralized logging and queries
- **Alerts**: Performance degradation, error rate, availability

---

## Validation Requirements

### 1. Load Testing

**Objective**: Validate application can handle expected production load

**Requirements**:

- Test with 10-50 concurrent users
- Duration: 30-120 seconds for quick validation
- Endpoints: All public API endpoints
- Success Criteria:
  - Success rate > 99%
  - Average response time < 500ms
  - Requests per second > 10
  - Error rate < 1%

**Tooling**:

- Simple bash script with curl (quick-load-test.sh)
- No complex infrastructure required
- CI/CD integration ready

### 2. API Endpoint Validation

**Objective**: Verify all endpoints return expected responses

**Requirements**:

- Test each endpoint individually
- Validate HTTP status codes (200 OK)
- Verify JSON response structure
- Check authentication and authorization
- Test error handling (4xx, 5xx)

**Test Coverage**:

- Health check endpoint (/)
- Version endpoint (/api/version)
- Identity endpoints (/api/whoami)
- Database connectivity (/api/sqlwhoami)
- Error scenarios (invalid routes, malformed requests)

### 3. Performance Baseline

**Objective**: Establish performance benchmarks for ongoing monitoring

**Requirements**:

- Measure cold start time (< 2 seconds acceptable)
- Measure warm response times (< 500ms target)
- Calculate percentiles (P50, P95, P99)
- Test under various load conditions
- Document baseline in version control

**Baseline Metrics**:

- Minimum response time
- Average response time
- Median (P50)
- 95th percentile (P95)
- 99th percentile (P99)
- Maximum response time
- Requests per second (RPS)

### 4. Database Connectivity

**Objective**: Validate managed identity authentication to SQL Database

**Requirements**:

- Verify Entra ID authentication works
- Test database read/write operations
- Validate connection pooling
- Check failover behavior (if applicable)
- No hardcoded credentials or connection strings

**Test Scenarios**:

- Managed identity token acquisition
- SQL query execution
- Connection timeout handling
- Database unavailability scenarios

### 5. Security Validation

**Objective**: Ensure security best practices are implemented

**Requirements**:

- HTTPS enforcement (HTTP redirects to HTTPS)
- TLS 1.2+ only
- No public blob access
- Managed identities configured
- No secrets in code or configuration
- Security headers present (X-Frame-Options, etc.)

**Compliance**:

- GDPR (data residency in EU)
- Healthcare data handling (HIPAA-aligned practices)
- Azure Security Benchmark alignment

---

## Acceptance Criteria

### Deployment Success

- [ ] Infrastructure deploys without errors in < 10 minutes
- [ ] Application is accessible via HTTPS
- [ ] All containers pull successfully from ACR
- [ ] Database connection works with managed identity
- [ ] Application Insights receives telemetry
- [ ] No secrets in plaintext anywhere

### Testing Success

- [ ] Load test passes with > 99% success rate
- [ ] All API endpoints return 200 OK
- [ ] Response times meet < 500ms target
- [ ] Baseline performance documented
- [ ] SQL connectivity validated
- [ ] Test results exportable for audit

### Documentation Success

- [ ] README covers deployment and testing steps
- [ ] Architecture diagram shows all components
- [ ] Test reports include metrics and pass/fail status
- [ ] Troubleshooting guide addresses common issues
- [ ] Demo script is executable in 30-45 minutes

### Audit Readiness

- [ ] Test execution logs with timestamps
- [ ] Performance metrics with thresholds
- [ ] Evidence of automated testing
- [ ] Customer sign-off template available
- [ ] Reports exportable as PDF or markdown

---

## Constraints and Assumptions

### Constraints

1. **Budget**: Demo environment should be low-cost (< $100/month)
2. **Time**: Full deployment + validation in < 1 hour
3. **Complexity**: Simple enough for IT Pros to understand and replicate
4. **Tooling**: Use native Azure services where possible

### Assumptions

1. **Azure Subscription**: User has Contributor access to subscription
2. **Azure CLI**: Pre-installed and authenticated
3. **PowerShell 7+**: Available for deployment scripts
4. **curl/bash**: Available for load testing (Linux/WSL/macOS)
5. **GitHub Copilot**: User has Copilot access for prompt examples

### Out of Scope

1. **Chaos Engineering**: Future enhancement (not in MVP)
2. **Multi-region**: Single region deployment for demo
3. **Custom Domains**: Using default \*.azurewebsites.net domains
4. **Advanced Monitoring**: Basic Application Insights only
5. **Production Scale**: Demo-scale infrastructure (not near-production-ready)

---

## Success Metrics

### Time Savings

| Activity             | Manual (Before) | With Copilot (After)  | Savings |
| -------------------- | --------------- | --------------------- | ------- |
| Infrastructure Setup | 6 hours         | 1 hour                | 83%     |
| Load Test Script     | 4 hours         | 20 minutes            | 92%     |
| API Validation       | 3 hours         | 15 minutes            | 92%     |
| Documentation        | 8 hours         | 2 hours               | 75%     |
| Test Reporting       | 4 hours         | 30 minutes            | 88%     |
| **TOTAL**            | **25 hours**    | **4 hours 5 minutes** | **84%** |

### Quality Metrics

- **Test Coverage**: 100% of API endpoints
- **Automation**: 90% of validation automated
- **Repeatability**: 100% repeatable via scripts
- **Documentation**: Complete and audit-ready

### Business Value

- **Faster Releases**: 84% reduction in validation time enables faster delivery
- **Audit Compliance**: Automated evidence generation for Module B Control 4.1
- **Quality Assurance**: Consistent testing reduces production incidents
- **Cost Efficiency**: Reusable scripts reduce ongoing validation costs

---

## User Stories

### Story 1: IT Pro Deploying Application

**As an** IT Professional at Contoso Healthcare  
**I want to** deploy a containerized application to Azure with automated validation  
**So that** I can prove it meets performance and reliability requirements

**Acceptance Criteria**:

- Deploy infrastructure with one command
- Application accessible within 5 minutes
- Validation tests run automatically
- Results documented for audit

### Story 2: DevOps Engineer Running Validation

**As a** DevOps Engineer  
**I want to** run automated load tests against my application  
**So that** I can validate performance before production release

**Acceptance Criteria**:

- Execute load test with single command
- Results show success rate and response times
- Test exits with code 0 (pass) or 1 (fail)
- Results saved for historical comparison

### Story 3: Security Auditor Reviewing Evidence

**As a** Security Auditor  
**I want to** review documented evidence of service validation  
**So that** I can verify Module B Control 4.1 compliance

**Acceptance Criteria**:

- Test execution logs with timestamps
- Performance metrics with pass/fail thresholds
- Infrastructure as code (auditable)
- Evidence of automated testing

### Story 4: System Integrator Replicating for Customer

**As a** System Integrator partner  
**I want to** replicate this validation scenario for my customer  
**So that** I can demonstrate Module B Control 4.1 capability

**Acceptance Criteria**:

- Complete documentation for replication
- All scripts and templates provided
- Clear architecture diagrams
- 30-minute demo script included

---

## Dependencies

### External Dependencies

1. **Azure Subscription**: Active subscription with credit
2. **Azure CLI**: Version 2.50.0 or newer
3. **GitHub Account**: For accessing repository
4. **GitHub Copilot**: For prompt examples (optional but recommended)

### Internal Dependencies

1. **SAIF Application**: Source code in repository
2. **Bicep Templates**: Infrastructure as code
3. **Container Images**: Built and pushed to ACR
4. **SQL Database**: Initialized with schema

---

## Risks and Mitigations

| Risk                                 | Impact | Probability | Mitigation                             |
| ------------------------------------ | ------ | ----------- | -------------------------------------- |
| SQL auth policy blocks deployment    | High   | Medium      | Add `SecurityControl: 'Ignore'` tag    |
| Container pull failures              | High   | Low         | Use managed identity with AcrPull role |
| Load test fails due to rate limiting | Medium | Medium      | Document 429 errors as expected        |
| Performance below baseline           | Medium | Low         | Right-size App Service Plan (P1v3)     |
| Cost overruns in demo environment    | Low    | Low         | Use Basic SQL tier, cleanup scripts    |

---

## References

- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)
- [Azure SQL Managed
Identity](https://learn.microsoft.com/azure/azure-sql/database/authentication-azure-ad-only-authentication)
- [Azure App Service Best Practices](https://learn.microsoft.com/azure/app-service/deploy-best-practices)
- [Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Azure Infrastructure Specialization - Module
B](https://partner.microsoft.com/en-us/training/assets/collection/azure-infrastructure-and-database-migration-specializa
tion)

---

**Document Version**: 1.0  
**Last Updated**: November 24, 2025  
**Owner**: DevOps Team  
**Status**: ✅ Approved
