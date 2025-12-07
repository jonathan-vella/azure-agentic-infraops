# API Validation Checklist - S05 Service Validation

**Project**: SAIF API v2 Service Validation  
**Environment**: Production  
**Deployment Date**: [Date]  
**Validated By**: [Name]  
**Review Date**: [Date]  

---

## Pre-Deployment Validation

### Infrastructure Readiness

- [ ] **Resource Group Created**: `rg-s05-validation-swc01`
- [ ] **Azure Container Registry**: ACR accessible and images built
- [ ] **App Service Plan**: P1v3 tier (or higher) deployed
- [ ] **App Services**: Both API and Web apps created
- [ ] **SQL Server**: Entra ID-only authentication configured
- [ ] **SQL Database**: Database created and accessible
- [ ] **Key Vault**: Deployed with appropriate access policies
- [ ] **Managed Identities**: System-assigned identities enabled
- [ ] **RBAC Assignments**: AcrPull and SQL roles granted
- [ ] **Networking**: VNet, subnets, and NSGs configured (if applicable)

### Security Configuration

- [ ] **HTTPS Only**: App Services enforce HTTPS
- [ ] **TLS Version**: Minimum TLS 1.2 configured
- [ ] **Public Access**: Blob public access disabled
- [ ] **Managed Identity**: No connection strings with passwords
- [ ] **Entra Auth**: SQL Server using Entra ID-only mode
- [ ] **Firewall Rules**: Only required ports open
- [ ] **Secrets Management**: All secrets in Key Vault
- [ ] **CORS**: Properly configured (if needed)

### Application Configuration

- [ ] **Container Images**: Latest images tagged and pushed
  - `saifv2/api:latest`
  - `saifv2/web:latest`
- [ ] **Environment Variables**: All app settings configured
- [ ] **Connection Strings**: Using managed identity
- [ ] **Health Check**: Health check endpoint configured
- [ ] **Logging**: Application Insights connected
- [ ] **Diagnostics**: Diagnostic settings enabled

---

## Post-Deployment Validation

### Service Availability

- [ ] **App Service Running**: Check app state is "Running"

  ```bash
  az webapp list -g rg-s05-validation-swc01 --query "[].{name:name, state:state}"
  ```

- [ ] **Container Started**: No "ImagePullBackOff" or crash loops

  ```bash
  az webapp log tail -g rg-s05-validation-swc01 -n app-saifv2-api-ss4xs2
  ```

- [ ] **DNS Resolution**: App URLs resolve correctly

  ```bash
  nslookup app-saifv2-api-ss4xs2.azurewebsites.net
  ```

### API Endpoint Testing

#### Root Endpoint (`/`)

- [ ] **HTTP 200 Status**: Returns success

  ```bash
  curl -I https://app-saifv2-api-ss4xs2.azurewebsites.net/
  ```

- [ ] **Valid JSON Response**: Returns application metadata

  ```bash
  curl -s https://app-saifv2-api-ss4xs2.azurewebsites.net/ | jq
  ```

- [ ] **Response Time**: < 2 seconds (cold start acceptable)

**Expected Response:**

```json
{
  "name": "SAIF API v2",
  "version": "2.0.0",
  "description": "Secure AI Framework API"
}
```

#### Version Endpoint (`/api/version`)

- [ ] **HTTP 200 Status**: Returns success

  ```bash
  curl -I https://app-saifv2-api-ss4xs2.azurewebsites.net/api/version
  ```

- [ ] **Version Info**: Returns current version

  ```bash
  curl -s https://app-saifv2-api-ss4xs2.azurewebsites.net/api/version | jq
  ```

**Expected Response:**

```json
{
  "version": "2.0.0",
  "build": "2025.11.24"
}
```

#### Identity Endpoint (`/api/whoami`)

- [ ] **HTTP 200 Status**: Returns success
- [ ] **Managed Identity Name**: Shows correct identity

  ```bash
  curl -s https://app-saifv2-api-ss4xs2.azurewebsites.net/api/whoami | jq
  ```

**Expected Response:**

```json
{
  "identity": "app-saifv2-api-ss4xs2",
  "type": "SystemAssigned"
}
```

#### Source IP Endpoint (`/api/sourceip`)

- [ ] **HTTP 200 Status**: Returns success
- [ ] **Client IP**: Shows your public IP

  ```bash
  curl -s https://app-saifv2-api-ss4xs2.azurewebsites.net/api/sourceip | jq
  ```

#### SQL Endpoints (Database Connectivity)

- [ ] **SQL WhoAmI** (`/api/sqlwhoami`): Returns SQL identity

  ```bash
  curl -s https://app-saifv2-api-ss4xs2.azurewebsites.net/api/sqlwhoami | jq
  ```

- [ ] **SQL Source IP** (`/api/sqlsrcip`): Returns database connection info

**Expected Response:**

```json
{
  "status": "OK",
  "sql_user": "<managed-identity-guid>",
  "database": "sqldb-saif"
}
```

---

## Load Testing Validation

### Quick Load Test

- [ ] **Test Script Exists**: `validation/load-testing/quick-load-test.sh`
- [ ] **Script is Executable**: `chmod +x quick-load-test.sh`
- [ ] **Test Execution**: Run 30-second test

  ```bash
  cd validation/load-testing
  ./quick-load-test.sh 30 20
  ```

### Performance Criteria

- [ ] **Success Rate**: > 99%
- [ ] **Average Response Time**: < 500ms
- [ ] **Requests per Second**: > 10
- [ ] **No 5xx Errors**: Except occasional cold starts
- [ ] **Test Exit Code**: 0 (pass)

**Test Output Verification:**

```
Results:
  Total Requests:    1000+
  Successful:        > 990 (99%+)
  Failed:            < 10
  Avg Response Time: < 500ms
  Requests/Second:   > 10

✓ PASS
```

---

## Security Validation

### Authentication & Authorization

- [ ] **No Anonymous Access**: Requires authentication (if applicable)
- [ ] **Managed Identity Works**: SQL connection using identity
- [ ] **No Hardcoded Secrets**: All secrets in Key Vault
- [ ] **Token Expiration**: Proper token refresh logic

### Network Security

- [ ] **HTTPS Enforcement**: HTTP redirects to HTTPS
- [ ] **TLS Certificate**: Valid SSL certificate
- [ ] **Security Headers**: Proper headers set (X-Frame-Options, etc.)
- [ ] **CORS Policy**: Only allowed origins permitted

### Compliance Checks

- [ ] **Diagnostic Logs**: Enabled and flowing to Log Analytics
- [ ] **Audit Logs**: SQL audit logs configured
- [ ] **Data Encryption**: Transparent Data Encryption (TDE) enabled
- [ ] **Backup Configured**: Automated backups scheduled

---

## Monitoring & Observability

### Application Insights

- [ ] **Connected**: Application Insights workspace linked
- [ ] **Telemetry Flowing**: Requests visible in Application Insights
- [ ] **Live Metrics**: Real-time metrics available
- [ ] **Availability Tests**: Health check pings configured

### Alerts Configuration

- [ ] **High Error Rate**: Alert when 5xx errors > 5%
- [ ] **Slow Response**: Alert when P95 > 1 second
- [ ] **Service Down**: Alert when health check fails
- [ ] **Resource Limits**: Alert when CPU > 80% or Memory > 90%

### Log Analytics

- [ ] **Query Logs**: Can query application logs

  ```kusto
  AppServiceConsoleLogs
  | where TimeGenerated > ago(1h)
  | order by TimeGenerated desc
  ```

- [ ] **Performance Data**: Metrics available

  ```kusto
  AppServiceHTTPLogs
  | where TimeGenerated > ago(1h)
  | summarize avg(TimeTaken) by bin(TimeGenerated, 5m)
  ```

---

## Performance Baseline

### Baseline Establishment

- [ ] **Baseline Test Run**: Extended test (60s, 10 concurrent)

  ```bash
  ./quick-load-test.sh 60 10 > baseline-results.txt
  ```

- [ ] **Metrics Recorded**: Success rate, response time, RPS documented
- [ ] **Baseline File Created**: `baselines/YYYY-MM-DD-baseline.txt`
- [ ] **Thresholds Set**: Monitoring alerts configured based on baseline

**Baseline Metrics:**

- Success Rate: _____%
- Avg Response Time: _____ms
- Requests/Second: _____

---

## Documentation

### Required Documentation

- [ ] **API Documentation**: Endpoints documented (OpenAPI/Swagger)
- [ ] **Runbook Created**: Operational procedures documented
- [ ] **Troubleshooting Guide**: Common issues and solutions
- [ ] **Architecture Diagram**: System architecture documented
- [ ] **Deployment Guide**: Step-by-step deployment instructions

### Test Reports

- [ ] **Load Test Report**: Generated and saved
- [ ] **Validation Summary**: This checklist completed
- [ ] **Performance Report**: Baseline performance documented
- [ ] **Security Scan Results**: No critical vulnerabilities

---

## Sign-off

### Validation Status

**Overall Status**: [ ] ✓ PASSED  [ ] ❌ FAILED  [ ] ⚠️ PASSED WITH WARNINGS

**Total Checks**: _____  
**Passed**: _____  
**Failed**: _____  
**Warnings**: _____  

### Approvals

| Role | Name | Signature | Date | Notes |
|------|------|-----------|------|-------|
| **Test Engineer** | _____________ | _________ | ______ | |
| **DevOps Lead** | _____________ | _________ | ______ | |
| **Security Review** | _____________ | _________ | ______ | |
| **Technical Lead** | _____________ | _________ | ______ | |
| **Product Owner** | _____________ | _________ | ______ | |

### Conditional Approval

**If PASSED WITH WARNINGS, list conditions:**

1. [Condition 1]
2. [Condition 2]
3. [Condition 3]

**Remediation Plan:**

- Owner: _____________
- Due Date: _____________
- Follow-up: _____________

---

## Post-Validation Actions

### Immediate Actions

- [ ] **Notify Stakeholders**: Send validation report to team
- [ ] **Update Status Board**: Mark deployment as validated
- [ ] **Enable Monitoring**: Ensure all alerts are active
- [ ] **Schedule Follow-up**: Set next validation date

### Scheduled Tasks

- [ ] **Daily Load Tests**: Automated via CI/CD
- [ ] **Weekly Performance Review**: Review metrics dashboard
- [ ] **Monthly Baseline Update**: Re-baseline if needed
- [ ] **Quarterly Security Audit**: Full security review

---

## Issues & Resolutions

**If any checks failed, document here:**

| Check | Issue | Resolution | Status |
|-------|-------|------------|--------|
| Example: API endpoint | 503 errors | Restarted app service | Resolved |
| | | | |
| | | | |

---

## Appendix: Quick Commands

### Validation Commands Cheat Sheet

<!-- markdownlint-disable MD013 -->
```bash
# Check app status
az webapp list -g rg-s05-validation-swc01 --query "[].{name:name, state:state}" -o table

# Test all endpoints
for ep in "/" "/api/version" "/api/whoami" "/api/sourceip"; do
  echo "Testing: $ep"
  curl -s -w "\nStatus: %{http_code}\n" "https://app-saifv2-api-ss4xs2.azurewebsites.net$ep" | head -5
  echo "---"
done

# Run quick load test
cd validation/load-testing && ./quick-load-test.sh 30 20

# View application logs
az webapp log tail -g rg-s05-validation-swc01 -n app-saifv2-api-ss4xs2

# Check resource health
az resource list -g rg-s05-validation-swc01 --query "[].{name:name, type:type, status:properties.provisioningState}" -o table
```
<!-- markdownlint-enable MD013 -->

---

**Checklist Version**: 1.0  
**Last Updated**: November 24, 2025  
**Next Review**: [Date]  
**Owner**: DevOps Team
