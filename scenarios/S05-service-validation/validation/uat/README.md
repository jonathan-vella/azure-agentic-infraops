# User Acceptance Testing (UAT) for SAIF API v2

## Overview

This directory contains User Acceptance Testing (UAT) scripts for the SAIF API v2 deployment.
UAT validates that the application meets business requirements and functions correctly from an end-user perspective.

## Test Coverage

### Functional Tests

- **Health Check**: Verify application is running and accessible
- **Version Information**: Validate version endpoint returns correct data
- **Identity Verification**: Confirm managed identity is correctly configured
- **Client Information**: Verify client IP address detection
- **Database Connectivity**: Validate SQL connection with Entra ID authentication
- **Error Handling**: Test graceful error responses

### Non-Functional Tests

- **Response Time**: Ensure endpoints respond within acceptable timeframes (< 500ms)
- **Availability**: Verify 99%+ uptime during test period
- **Data Accuracy**: Validate response data matches expected formats
- **Security**: Confirm HTTPS enforcement and security headers

## Test Scripts

### PowerShell (Pester)

```powershell
# Run all UAT tests
Invoke-Pester -Path ./uat-tests.ps1 -Output Detailed

# Run specific test
Invoke-Pester -Path ./uat-tests.ps1 -Tag "HealthCheck" -Output Detailed

# Generate test report
Invoke-Pester -Path ./uat-tests.ps1 -OutputFile ./test-results.xml -OutputFormat NUnitXml
```

### Bash

```bash
# Run all UAT tests
./uat-tests.sh

# Run with verbose output
./uat-tests.sh --verbose

# Run specific endpoint test
./uat-tests.sh --endpoint health
```

## Prerequisites

### PowerShell Requirements

- PowerShell 7.0 or higher
- Pester module (version 5.0+)

```powershell
# Install Pester if needed
Install-Module -Name Pester -Force -SkipPublisherCheck
```

### Bash Requirements

- curl
- jq (for JSON parsing)

```bash
# Install jq on Ubuntu/Debian
sudo apt-get install jq

# Install jq on macOS
brew install jq
```

## Configuration

### Environment Variables

Set the API base URL before running tests:

```powershell
# PowerShell
$env:API_BASE_URL = "https://app-saifv2-api-xxx.azurewebsites.net"

# Bash
export API_BASE_URL="https://app-saifv2-api-xxx.azurewebsites.net"
```

## Test Execution

### Quick Test

```bash
# Test all endpoints quickly
curl -s $API_BASE_URL/ | jq .
curl -s $API_BASE_URL/api/version | jq .
curl -s $API_BASE_URL/api/whoami | jq .
```

### Comprehensive Test

```powershell
# Run full UAT suite
Invoke-Pester -Path ./uat-tests.ps1 -Output Detailed -PassThru
```

## Expected Results

### Success Criteria

- ✅ All endpoints return HTTP 200 OK
- ✅ Response times < 500ms for all endpoints
- ✅ JSON responses are valid and well-formed
- ✅ Managed identity authentication works for SQL endpoints
- ✅ No hardcoded credentials in responses
- ✅ Security headers present in all responses

### Failure Handling

If any test fails:

1. **Check Application Health**: Verify App Service is running
2. **Review Logs**: Check Application Insights for errors
3. **Verify Configuration**: Ensure environment variables are set
4. **Test Connectivity**: Confirm network access to Azure resources
5. **Rerun Tests**: Execute failed tests individually for details

## Test Reports

### Report Locations

- PowerShell: `./test-results.xml` (NUnit format)
- Bash: `./test-results.log` (text format)
- CI/CD: Results published to pipeline artifacts

### Sample Report

```text
UAT Test Results - SAIF API v2
================================
Test Date: 2025-11-24 14:30:00 UTC
Environment: Production
Total Tests: 12
Passed: 12
Failed: 0
Success Rate: 100%

Endpoint Tests:
  ✅ Health Check (/) - 89ms
  ✅ Version (/api/version) - 45ms
  ✅ Identity (/api/whoami) - 112ms
  ✅ Source IP (/api/sourceip) - 38ms
  ✅ SQL Identity (/api/sqlwhoami) - 156ms
  ✅ SQL Connection (/api/sqlsrcip) - 143ms

Performance Tests:
  ✅ All endpoints < 500ms
  ✅ Average response time: 97ms

Security Tests:
  ✅ HTTPS enforcement
  ✅ Security headers present
  ✅ No credentials in responses
```

## Troubleshooting

### Common Issues

#### Issue: "Connection refused"

**Cause**: App Service not running or incorrect URL

**Solution**:

```bash
# Verify App Service is running
az webapp show --name app-saifv2-api-xxx --resource-group rg-s05-validation-swc01 --query state
```

#### Issue: "401 Unauthorized" on SQL endpoints

**Cause**: Managed identity not configured or missing RBAC role

**Solution**:

```bash
# Verify managed identity
az webapp identity show --name app-saifv2-api-xxx --resource-group rg-s05-validation-swc01

# Verify RBAC role
az role assignment list --assignee <managed-identity-id> --scope <sql-server-id>
```

#### Issue: "Timeout" errors

**Cause**: Application cold start or performance issues

**Solution**:

1. Warm up application with health check
2. Check Application Insights for slow dependencies
3. Review App Service Plan SKU (should be P1v3 or higher)

## CI/CD Integration

### Azure DevOps

```yaml
- task: PowerShell@2
  displayName: 'Run UAT Tests'
  inputs:
    targetType: 'filePath'
    filePath: '$(Build.SourcesDirectory)/validation/uat/uat-tests.ps1'
  env:
    API_BASE_URL: $(ApiBaseUrl)

- task: PublishTestResults@2
  displayName: 'Publish Test Results'
  inputs:
    testResultsFormat: 'NUnit'
    testResultsFiles: '**/test-results.xml'
```

### GitHub Actions

```yaml
- name: Run UAT Tests
  run: |
    pwsh -File ./validation/uat/uat-tests.ps1
  env:
    API_BASE_URL: ${{ secrets.API_BASE_URL }}

- name: Publish Test Results
  uses: dorny/test-reporter@v1
  with:
    name: UAT Tests
    path: '**/test-results.xml'
    reporter: java-junit
```

## Best Practices

1. **Run UAT After Deployment**: Always execute UAT tests after infrastructure or code changes
2. **Test in Staging First**: Validate in non-production before production deployment
3. **Automate in Pipeline**: Integrate UAT tests into CI/CD for continuous validation
4. **Monitor Over Time**: Track test execution trends for performance regression
5. **Document Failures**: Record all failures with timestamps and error details

## Next Steps

After successful UAT:

1. **Generate Test Report**: Document results for stakeholders
2. **Update Baseline**: Refresh performance baselines if improved
3. **Sign-Off**: Obtain customer approval using sign-off templates
4. **Monitor**: Enable Application Insights alerts for ongoing monitoring

## References

- [Pester Documentation](https://pester.dev/)
- [API Validation Checklist](../examples/api-validation-checklist.md)
- [Test Execution Log](../examples/test-execution-log.md)
- [Troubleshooting Guide](../examples/troubleshooting-guide.md)

---

**Last Updated**: November 24, 2025  
**Version**: 1.0  
**Maintained By**: DevOps Team
