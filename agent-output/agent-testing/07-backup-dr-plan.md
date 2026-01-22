# Backup and Disaster Recovery Plan: Agent Testing Framework

**Generated**: 2026-01-22
**Version**: 1.0
**Environment**: test
**Primary Region**: swedencentral
**Secondary Region**: germanywestcentral

---

## Executive Summary

The Agent Testing Framework is **ephemeral test infrastructure** with a 2-hour TTL. Disaster recovery focuses on **redeployment from IaC** rather than data recovery.

| Metric           | Current              | Target               |
| ---------------- | -------------------- | -------------------- |
| **RPO**          | N/A (no persistent)  | N/A                  |
| **RTO**          | 15 min               | 15 min               |
| **Availability** | 99% (test)           | 99%                  |

---

## 1. Recovery Objectives

### 1.1 Recovery Time Objective (RTO)

| Tier      | RTO Target | Services                        |
| --------- | ---------- | ------------------------------- |
| Critical  | 15 min     | Full infrastructure redeploy    |
| Important | 5 min      | Single resource restart         |
| Standard  | 30 min     | DR region failover              |

### 1.2 Recovery Point Objective (RPO)

| Data Type     | RPO Target | Backup Strategy         |
| ------------- | ---------- | ----------------------- |
| Test data     | N/A        | No backup (ephemeral)   |
| SQL Database  | 7 days     | Automated PITR          |
| Configuration | N/A        | Stored in IaC (Git)     |

---

## 2. Backup Strategy

### 2.1 Azure SQL Database

| Setting             | Configuration               |
| ------------------- | --------------------------- |
| Backup Type         | Automated PITR              |
| Retention (PITR)    | 7 days (Basic tier default) |
| Long-Term Retention | Not configured              |
| Geo-Redundancy      | LRS (locally redundant)     |

**Point-in-Time Restore Command:**

```bash
az sql db restore \
  --resource-group rg-agenttest-test-swc \
  --server sql-test-agent-testing-swc-chw5en \
  --name testdb \
  --dest-name testdb-restored \
  --time "2026-01-22T12:00:00Z"
```

### 2.2 Azure Key Vault

| Setting          | Configuration     |
| ---------------- | ----------------- |
| Soft Delete      | Disabled          |
| Purge Protection | Disabled          |

---

## 3. Disaster Recovery Procedures

### 3.1 Failover Procedure

**Single Resource Failure:**

```bash
# Identify failed resource
az resource list -g rg-agenttest-test-swc \
  --query "[?provisioningState!='Succeeded']" -o table

# Redeploy from Bicep
cd infra/bicep/agent-testing
az deployment group create \
  --resource-group rg-agenttest-test-swc \
  --template-file main.bicep
```

### 3.2 Failback Procedure

**Region Failover to germanywestcentral:**

```bash
# Create DR resource group
az group create --name rg-agenttest-test-gwc --location germanywestcentral

# Deploy to DR region
az deployment group create \
  --resource-group rg-agenttest-test-gwc \
  --template-file main.bicep \
  --parameters location=germanywestcentral
```

---

## 4. Testing Schedule

| Test Type        | Frequency | Last Test  | Next Test  |
| ---------------- | --------- | ---------- | ---------- |
| PITR Restore     | Monthly   | N/A        | 2026-02-22 |
| Full Redeploy    | Monthly   | 2026-01-22 | 2026-02-22 |
| DR Region Deploy | Quarterly | N/A        | 2026-04-22 |

---

## 5. Communication Plan

| Audience         | Channel       | Template               |
| ---------------- | ------------- | ---------------------- |
| Platform Team    | Teams/Slack   | DR Initiation          |
| Stakeholders     | Email         | Status Update          |
| On-call Engineer | PagerDuty     | Alert Notification     |

---

## 6. Roles and Responsibilities

| Role             | Person               | Responsibility           |
| ---------------- | -------------------- | ------------------------ |
| DR Coordinator   | platform-engineering | Initiate DR procedures   |
| Infra Engineer   | platform-engineering | Execute recovery steps   |
| Communications   | platform-engineering | Status updates           |

---

## 7. Dependencies

| Dependency         | Impact if Unavailable        | Mitigation                |
| ------------------ | ---------------------------- | ------------------------- |
| Azure CLI          | Cannot deploy                | Use Portal or PowerShell  |
| GitHub             | Cannot access IaC            | Local clone available     |
| Entra ID           | Cannot authenticate          | Wait for recovery         |

---

## 8. Recovery Runbooks

### Runbook 8.1: Complete Recovery

```bash
# Step 1: Recreate resource group
az group create --name rg-agenttest-test-swc --location swedencentral

# Step 2: Deploy infrastructure
cd infra/bicep/agent-testing
az deployment group create \
  --resource-group rg-agenttest-test-swc \
  --template-file main.bicep

# Step 3: Verify deployment
az resource list -g rg-agenttest-test-swc -o table
```

---

## 9. Appendix

### 9.1 IaC Recovery Files

| File                                        | Purpose        |
| ------------------------------------------- | -------------- |
| `infra/bicep/agent-testing/main.bicep`      | Main template  |
| `infra/bicep/agent-testing/main.bicepparam` | Parameters     |
| `infra/bicep/agent-testing/modules/*.bicep` | Resource modules|

### 9.2 Recovery Time Estimates

| Scenario                 | RTO           |
| ------------------------ | ------------- |
| Single resource restart  | 2 minutes     |
| Full redeploy            | 10-15 minutes |
| DR region deployment     | 15-20 minutes |

---

_Backup and DR plan generated by Workload Documentation Generator._
