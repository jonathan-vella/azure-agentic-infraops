# CI/CD Integration Guide - S05 Service Validation

This guide demonstrates how to integrate the `quick-load-test.sh` script into your CI/CD pipelines for
automated service validation.

---

## Table of Contents

1. [Azure DevOps Pipeline](#azure-devops-pipeline)
2. [GitHub Actions Workflow](#github-actions-workflow)
3. [GitLab CI/CD](#gitlab-cicd)
4. [Jenkins Pipeline](#jenkins-pipeline)
5. [Failure Handling](#failure-handling)
6. [Notifications](#notifications)

---

## Azure DevOps Pipeline

### Basic Integration

```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
      - main
      - develop

pool:
  vmImage: 'ubuntu-latest'

stages:
  - stage: Deploy
    jobs:
      - job: DeployInfrastructure
        steps:
          - task: AzureCLI@2
            displayName: 'Deploy Infrastructure'
            inputs:
              azureSubscription: 'Azure-Connection'
              scriptType: 'bash'
              scriptLocation: 'scriptPath'
              scriptPath: 'solution/scripts/deploy.ps1'

  - stage: Validate
    dependsOn: Deploy
    jobs:
      - job: LoadTest
        steps:
          - task: Bash@3
            displayName: 'Run Quick Load Test'
            inputs:
              targetType: 'filePath'
              filePath: '$(System.DefaultWorkingDirectory)/validation/load-testing/quick-load-test.sh'
              arguments: '30 20'
              workingDirectory: '$(System.DefaultWorkingDirectory)/validation/load-testing'
            continueOnError: false
            timeoutInMinutes: 5

          - task: PublishTestResults@2
            displayName: 'Publish Test Results'
            condition: always()
            inputs:
              testResultsFormat: 'JUnit'
              testResultsFiles: '**/test-results.xml'
              failTaskOnFailedTests: true
```

### Advanced Pipeline with Notifications

```yaml
# azure-pipelines-advanced.yml
trigger:
  branches:
    include:
      - main
      - release/*

variables:
  - name: apiUrl
    value: 'https://app-saifv2-api-ss4xs2.azurewebsites.net'
  - name: testDuration
    value: '30'
  - name: concurrentRequests
    value: '20'

stages:
  - stage: PreValidation
    displayName: 'Pre-Deployment Validation'
    jobs:
      - job: CheckInfrastructure
        displayName: 'Check Infrastructure Health'
        steps:
          - task: AzureCLI@2
            displayName: 'Verify Resource Group'
            inputs:
              azureSubscription: 'Azure-Connection'
              scriptType: 'bash'
              scriptLocation: 'inlineScript'
              inlineScript: |
                az group exists --name rg-s05-validation-swc01
                if [ $? -ne 0 ]; then
                  echo "##vso[task.logissue type=error]Resource group not found"
                  exit 1
                fi

  - stage: Deploy
    dependsOn: PreValidation
    displayName: 'Deploy Application'
    jobs:
      - job: DeployApp
        steps:
          - task: AzureCLI@2
            displayName: 'Deploy Bicep Templates'
            inputs:
              azureSubscription: 'Azure-Connection'
              scriptType: 'pwsh'
              scriptLocation: 'scriptPath'
              scriptPath: '$(System.DefaultWorkingDirectory)/solution/scripts/deploy.ps1'
              arguments: '-location swedencentral'

          - task: Bash@3
            displayName: 'Wait for Services to Start'
            inputs:
              targetType: 'inline'
              script: |
                echo "Waiting 60 seconds for containers to start..."
                sleep 60

  - stage: Validate
    dependsOn: Deploy
    displayName: 'Service Validation'
    jobs:
      - job: APITests
        displayName: 'API Endpoint Tests'
        steps:
          - task: Bash@3
            displayName: 'Test All Endpoints'
            inputs:
              targetType: 'inline'
              script: |
                API_URL="$(apiUrl)"
                FAILED=0
                
                for endpoint in "/" "/api/version" "/api/whoami" "/api/sourceip"; do
                  echo "Testing: $endpoint"
                  status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL$endpoint")
                  if [ $status -eq 200 ]; then
                    echo "✓ $endpoint - PASS (HTTP $status)"
                  else
                    echo "##vso[task.logissue type=error]✗ $endpoint - FAIL (HTTP $status)"
                    FAILED=1
                  fi
                done
                
                if [ $FAILED -eq 1 ]; then
                  echo "##vso[task.complete result=Failed;]API endpoints failed"
                  exit 1
                fi

      - job: LoadTest
        dependsOn: APITests
        displayName: 'Load Testing'
        steps:
          - task: Bash@3
            displayName: 'Run Load Test'
            inputs:
              targetType: 'filePath'
              filePath: '$(System.DefaultWorkingDirectory)/validation/load-testing/quick-load-test.sh'
              arguments: '$(testDuration) $(concurrentRequests)'
              workingDirectory: '$(System.DefaultWorkingDirectory)/validation/load-testing'
            continueOnError: false
            timeoutInMinutes: 10

          - task: Bash@3
            displayName: 'Save Test Results'
            condition: always()
            inputs:
              targetType: 'inline'
              script: |
                mkdir -p $(Build.ArtifactStagingDirectory)/test-results
                cp validation/load-testing/*.txt $(Build.ArtifactStagingDirectory)/test-results/ || true

          - task: PublishBuildArtifacts@1
            displayName: 'Publish Test Artifacts'
            condition: always()
            inputs:
              pathToPublish: '$(Build.ArtifactStagingDirectory)/test-results'
              artifactName: 'load-test-results'

  - stage: Notify
    dependsOn: Validate
    condition: always()
    displayName: 'Send Notifications'
    jobs:
      - job: SendEmail
        steps:
          - task: SendEmail@1
            displayName: 'Email Test Results'
            inputs:
              To: 'devops-team@example.com'
              From: 'azure-devops@example.com'
              Subject: 'S05 Validation Test Results - $(Build.BuildNumber)'
              Body: 'Validation tests completed. Status: $(Agent.JobStatus)'
```

---

## GitHub Actions Workflow

### Basic Workflow

```yaml
# .github/workflows/validate.yml
name: Service Validation

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM UTC

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy Infrastructure
        run: |
          cd solution/scripts
          pwsh ./deploy.ps1 -location swedencentral

  validate:
    needs: deploy
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Run Load Test
        run: |
          cd validation/load-testing
          chmod +x quick-load-test.sh
          ./quick-load-test.sh 30 20

      - name: Upload Test Results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: load-test-results
          path: validation/load-testing/*.txt
```

### Advanced Workflow with Matrix Testing

```yaml
# .github/workflows/validate-advanced.yml
name: Service Validation (Advanced)

on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      test_duration:
        description: 'Test duration in seconds'
        required: false
        default: '30'
      concurrent_requests:
        description: 'Concurrent requests'
        required: false
        default: '20'

env:
  API_URL: https://app-saifv2-api-ss4xs2.azurewebsites.net

jobs:
  pre-validation:
    name: Pre-Validation Checks
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Check Resources
        run: |
          echo "Checking resource group..."
          az group show --name rg-s05-validation-swc01
          
          echo "Checking App Services..."
          az webapp list --resource-group rg-s05-validation-swc01 \
            --query "[].{name:name, state:state}" --output table

  endpoint-tests:
    name: API Endpoint Tests
    needs: pre-validation
    runs-on: ubuntu-latest
    strategy:
      matrix:
        endpoint: ['/', '/api/version', '/api/whoami', '/api/sourceip']
    steps:
      - name: Test ${{ matrix.endpoint }}
        run: |
          echo "Testing endpoint: ${{ matrix.endpoint }}"
          response=$(curl -s -w "\n%{http_code}" "$API_URL${{ matrix.endpoint }}")
          status=$(echo "$response" | tail -n1)
          
          if [ $status -eq 200 ]; then
            echo "✓ PASS - HTTP $status"
          else
            echo "✗ FAIL - HTTP $status"
            exit 1
          fi

  load-test:
    name: Load Testing
    needs: endpoint-tests
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Run Quick Load Test
        id: load_test
        run: |
          cd validation/load-testing
          chmod +x quick-load-test.sh
          
          DURATION=${{ github.event.inputs.test_duration || '30' }}
          CONCURRENT=${{ github.event.inputs.concurrent_requests || '20' }}
          
          echo "Running load test: ${DURATION}s, ${CONCURRENT} concurrent"
          ./quick-load-test.sh $DURATION $CONCURRENT | tee load-test-output.txt
          
          # Extract metrics for GitHub summary
          SUCCESS_RATE=$(grep "Success" load-test-output.txt | awk '{print $2}')
          AVG_RESPONSE=$(grep "Avg Response" load-test-output.txt | awk '{print $3}')
          
          echo "success_rate=$SUCCESS_RATE" >> $GITHUB_OUTPUT
          echo "avg_response=$AVG_RESPONSE" >> $GITHUB_OUTPUT

      - name: Generate Summary
        run: |
          echo "## Load Test Results 🚀" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "| Metric | Value |" >> $GITHUB_STEP_SUMMARY
          echo "|--------|-------|" >> $GITHUB_STEP_SUMMARY
          echo "| Success Rate | ${{ steps.load_test.outputs.success_rate }} |" >> $GITHUB_STEP_SUMMARY
          echo "| Avg Response Time | ${{ steps.load_test.outputs.avg_response }} |" >> $GITHUB_STEP_SUMMARY

      - name: Upload Results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: load-test-results-${{ github.run_number }}
          path: validation/load-testing/load-test-output.txt

  notify:
    name: Send Notifications
    needs: [endpoint-tests, load-test]
    if: always()
    runs-on: ubuntu-latest
    steps:
      - name: Send Slack Notification
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "S05 Validation Tests - ${{ job.status }}",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "*S05 Service Validation*\nStatus: ${{ job.status }}\nRun: ${{ github.run_number }}"
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

---

## GitLab CI/CD

```yaml
# .gitlab-ci.yml
stages:
  - deploy
  - validate
  - notify

variables:
  API_URL: "https://app-saifv2-api-ss4xs2.azurewebsites.net"
  TEST_DURATION: "30"
  CONCURRENT_REQUESTS: "20"

deploy_infrastructure:
  stage: deploy
  image: mcr.microsoft.com/azure-cli:latest
  script:
    - az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
    - cd solution/scripts
    - pwsh ./deploy.ps1 -location swedencentral
  only:
    - main
    - develop

validate_endpoints:
  stage: validate
  image: curlimages/curl:latest
  script:
    - |
      for endpoint in "/" "/api/version" "/api/whoami" "/api/sourceip"; do
        echo "Testing: $endpoint"
        status=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL$endpoint")
        if [ $status -ne 200 ]; then
          echo "FAIL: $endpoint returned $status"
          exit 1
        fi
      done
  needs:
    - deploy_infrastructure

load_test:
  stage: validate
  image: ubuntu:latest
  before_script:
    - apt-get update && apt-get install -y curl bc
  script:
    - cd validation/load-testing
    - chmod +x quick-load-test.sh
    - ./quick-load-test.sh $TEST_DURATION $CONCURRENT_REQUESTS
  artifacts:
    paths:
      - validation/load-testing/*.txt
    expire_in: 1 week
  needs:
    - validate_endpoints

notify_success:
  stage: notify
  image: alpine:latest
  script:
    - echo "All tests passed!"
  when: on_success
  needs:
    - load_test

notify_failure:
  stage: notify
  image: alpine:latest
  script:
    - echo "Tests failed!"
  when: on_failure
  needs:
    - load_test
```

---

## Jenkins Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    environment {
        API_URL = 'https://app-saifv2-api-ss4xs2.azurewebsites.net'
        TEST_DURATION = '30'
        CONCURRENT_REQUESTS = '20'
    }
    
    stages {
        stage('Deploy Infrastructure') {
            steps {
                script {
                    sh '''
                        cd solution/scripts
                        pwsh ./deploy.ps1 -location swedencentral
                    '''
                }
            }
        }
        
        stage('Wait for Services') {
            steps {
                script {
                    echo 'Waiting 60 seconds for services to start...'
                    sleep(60)
                }
            }
        }
        
        stage('Validate Endpoints') {
            steps {
                script {
                    def endpoints = ['/', '/api/version', '/api/whoami', '/api/sourceip']
                    endpoints.each { endpoint ->
                        sh """
                            status=\$(curl -s -o /dev/null -w "%{http_code}" "${API_URL}${endpoint}")
                            if [ \$status -ne 200 ]; then
                                echo "FAIL: ${endpoint} returned \$status"
                                exit 1
                            fi
                        """
                    }
                }
            }
        }
        
        stage('Load Testing') {
            steps {
                dir('validation/load-testing') {
                    sh """
                        chmod +x quick-load-test.sh
                        ./quick-load-test.sh ${TEST_DURATION} ${CONCURRENT_REQUESTS} | tee load-test-results.txt
                    """
                }
            }
        }
        
        stage('Publish Results') {
            steps {
                archiveArtifacts artifacts: 'validation/load-testing/*.txt', fingerprint: true
            }
        }
    }
    
    post {
        success {
            emailext (
                to: 'devops-team@example.com',
                subject: "SUCCESS: S05 Validation - Build ${env.BUILD_NUMBER}",
                body: "All validation tests passed.\n\nBuild: ${env.BUILD_URL}"
            )
        }
        failure {
            emailext (
                to: 'devops-team@example.com',
                subject: "FAILURE: S05 Validation - Build ${env.BUILD_NUMBER}",
                body: "Validation tests failed.\n\nBuild: ${env.BUILD_URL}"
            )
        }
    }
}
```

---

## Failure Handling

### Retry Logic

```yaml
# GitHub Actions - Retry on failure
- name: Run Load Test with Retry
  uses: nick-invision/retry@v2
  with:
    timeout_minutes: 10
    max_attempts: 3
    retry_wait_seconds: 30
    command: |
      cd validation/load-testing
      ./quick-load-test.sh 30 20
```

### Conditional Execution

```yaml
# Azure DevOps - Only run on specific branches
trigger:
  branches:
    include:
      - main
      - release/*
    exclude:
      - feature/*
      - hotfix/*
```

### Failure Notifications

```bash
# Bash script with Slack notification
#!/bin/bash

cd validation/load-testing
./quick-load-test.sh 30 20

if [ $? -ne 0 ]; then
  # Send Slack notification
  curl -X POST $SLACK_WEBHOOK_URL \
    -H 'Content-Type: application/json' \
    -d '{
      "text": "❌ Load test FAILED",
      "blocks": [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "*Load Test Failure*\nEnvironment: Production\nTime: '$(date)'"
          }
        }
      ]
    }'
  exit 1
fi
```

---

## Notifications

### Slack Integration

```yaml
# GitHub Actions
- name: Slack Notification
  if: always()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "Load Test: ${{ job.status }}",
        "attachments": [
          {
            "color": "${{ job.status == 'success' && 'good' || 'danger' }}",
            "fields": [
              {
                "title": "Status",
                "value": "${{ job.status }}",
                "short": true
              },
              {
                "title": "Run",
                "value": "${{ github.run_number }}",
                "short": true
              }
            ]
          }
        ]
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Email Notifications

```yaml
# Azure DevOps
- task: SendEmail@1
  condition: or(succeeded(), failed())
  inputs:
    To: 'devops-team@example.com'
    From: 'azure-devops@example.com'
    Subject: 'S05 Validation - $(Agent.JobStatus)'
    Body: |
      Build: $(Build.BuildNumber)
      Status: $(Agent.JobStatus)
      Branch: $(Build.SourceBranch)
      Commit: $(Build.SourceVersion)
      
      Results: $(Build.BuildUri)
```

### Microsoft Teams

```bash
# Bash script for Teams notification
curl -X POST "$TEAMS_WEBHOOK_URL" \
  -H 'Content-Type: application/json' \
  -d '{
    "@type": "MessageCard",
    "@context": "https://schema.org/extensions",
    "summary": "S05 Validation Test Results",
    "themeColor": "0078D4",
    "title": "Load Test Results",
    "sections": [
      {
        "activityTitle": "Test Completed",
        "facts": [
          {
            "name": "Status:",
            "value": "PASSED"
          },
          {
            "name": "Success Rate:",
            "value": "99.6%"
          },
          {
            "name": "Avg Response:",
            "value": "145ms"
          }
        ]
      }
    ]
  }'
```

---

## Best Practices

### 1. **Scheduled Testing**

```yaml
# Run tests daily at 2 AM
on:
  schedule:
    - cron: '0 2 * * *'
```

### 2. **Environment Variables**

```yaml
# Store configuration in variables
variables:
  - name: testDuration
    value: '30'
  - name: concurrentRequests
    value: '20'
  - name: apiUrl
    value: 'https://app-saifv2-api-ss4xs2.azurewebsites.net'
```

### 3. **Artifact Retention**

```yaml
# Keep test results for 30 days
- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: '$(Build.ArtifactStagingDirectory)'
    artifactName: 'test-results'
    retentionDays: 30
```

### 4. **Parallel Execution**

```yaml
# Run multiple load tests in parallel
strategy:
  matrix:
    test:
      - { duration: 30, concurrent: 10 }
      - { duration: 60, concurrent: 20 }
      - { duration: 120, concurrent: 30 }
```

---

## Troubleshooting

### Common Issues

**Issue**: Test times out
**Solution**: Increase `timeoutInMinutes` in task

**Issue**: Curl not found
**Solution**: Install curl in before_script or use image with curl pre-installed

**Issue**: Permission denied on script
**Solution**: Add `chmod +x quick-load-test.sh` before execution

**Issue**: API not accessible from pipeline
**Solution**: Check firewall rules, ensure pipeline agent IP is allowed

---

**Last Updated**: November 24, 2025  
**Version**: 1.0  
**Maintainer**: DevOps Team
