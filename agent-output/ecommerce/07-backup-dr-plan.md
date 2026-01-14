# Backup and Disaster Recovery Plan: Ecommerce Platform

**Generated**: December 17, 2025
**Version**: 1.0
**Environment**: Production
**Primary Region**: swedencentral
**Secondary Region**: germanywestcentral (recommended)

---

## Executive Summary

This document defines the backup strategy and disaster recovery procedures for the ecommerce platform.
The current architecture is **single-region** with zone redundancy, providing protection against
datacenter-level failures but not full regional outages.

| Metric           | Current (Single-Region) | Target (Multi-Region) |
| ---------------- | ----------------------- | --------------------- |
| **RPO**          | 1 hour                  | 15 minutes            |
| **RTO**          | 4 hours                 | 1 hour                |
| **Availability** | 99.9%                   | 99.95%                |
| **Cost Impact**  | Baseline                | +40% (~$640/month)    |

---

## 1. Recovery Objectives

### 1.1 Recovery Time Objective (RTO)

| Tier      | RTO Target | Services                                 |
| --------- | ---------- | ---------------------------------------- |
| Critical  | 1 hour     | App Service, SQL Database, Redis         |
| Important | 4 hours    | Functions, Service Bus, Cognitive Search |
| Standard  | 8 hours    | Log Analytics, App Insights              |

### 1.2 Recovery Point Objective (RPO)

| Data Type      | RPO Target          | Backup Strategy             |
| -------------- | ------------------- | --------------------------- |
| Transaction DB | 5 minutes           | SQL point-in-time restore   |
| Session Data   | 0 (loss acceptable) | Redis in-memory (ephemeral) |
| Search Index   | 24 hours            | Rebuild from source data    |
| Config/Secrets | 0 minutes           | Key Vault with soft-delete  |
| Logs           | 24 hours            | Log Analytics retention     |

---

## 2. Backup Strategy

### 2.1 Azure SQL Database

| Setting                | Configuration                         |
| ---------------------- | ------------------------------------- |
| Backup Type            | Automated (Azure-managed)             |
| Full Backup Frequency  | Weekly                                |
| Differential Frequency | Every 12 hours                        |
| Transaction Log        | Every 5-10 minutes                    |
| Retention (PITR)       | 7 days (Standard) / 35 days (Premium) |
| Long-Term Retention    | Not configured (recommend enabling)   |
| Geo-Redundancy         | GRS (backup stored in paired region)  |

**Point-in-Time Restore Command:**

```bash
az sql db restore \
  --resource-group rg-ecommerce-prod \
  --server sql-ecommerce-prod-swc-{suffix} \
  --name ecommercedb \
  --dest-name ecommercedb-restored \
  --time "2025-12-17T10:00:00Z"
```

### 2.2 Azure Key Vault

| Setting          | Configuration                 |
| ---------------- | ----------------------------- |
| Soft Delete      | Enabled (90 days retention)   |
| Purge Protection | Enabled (cannot force delete) |
| Backup Method    | Manual export or IaC redeploy |

**Key Vault Backup Command:**

```bash
az keyvault secret backup \
  --vault-name kv-ecommerce-prod-{suffix} \
  --name <secret-name> \
  --file <backup-file>
```

### 2.3 Azure Cache for Redis

| Setting           | Configuration                         |
| ----------------- | ------------------------------------- |
| Persistence       | Not enabled (session cache only)      |
| Data Criticality  | Low (regenerated from DB)             |
| Recovery Strategy | Cold start (cache warming on restart) |

**Note**: Redis is used for session caching only. No backup required; cache rebuilds on application startup.

### 2.4 Azure Cognitive Search

| Setting                | Configuration                         |
| ---------------------- | ------------------------------------- |
| Index Backup           | Not native (rebuild from source)      |
| Recovery Strategy      | Reindex from SQL Database             |
| Estimated Reindex Time | 30-60 minutes for current data volume |

### 2.5 Service Bus

| Setting           | Configuration                            |
| ----------------- | ---------------------------------------- |
| Message Retention | 14 days (dead-letter queue)              |
| Geo-DR            | Not configured (Premium tier required)   |
| Recovery Strategy | Replay from dead-letter or source system |

### 2.6 App Service / Functions

| Setting           | Configuration                    |
| ----------------- | -------------------------------- |
| Code Backup       | Git repository (source of truth) |
| Configuration     | IaC (Bicep templates)            |
| Recovery Strategy | Redeploy from source control     |
| Deployment Slots  | Staging slot available for swap  |

---

## 3. Disaster Recovery Procedures

### 3.1 Current State (Single-Region)

```text
┌─────────────────────────────────────────────────────────────┐
│  swedencentral (Primary)                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Availability Zone 1    Availability Zone 2         │   │
│  │  ┌─────────────────┐    ┌─────────────────┐        │   │
│  │  │ App Service     │    │ App Service     │        │   │
│  │  │ (Instance 1)    │    │ (Instance 2)    │        │   │
│  │  └─────────────────┘    └─────────────────┘        │   │
│  │                                                     │   │
│  │  ┌─────────────────────────────────────────┐       │   │
│  │  │ SQL Database (Zone Redundant)           │       │   │
│  │  │ Backup → GRS (germanywestcentral)       │       │   │
│  │  └─────────────────────────────────────────┘       │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

**Current Protections:**

- ✅ Zone redundancy for App Service (P1v4, 2+ instances)
- ✅ Zone redundancy for SQL Database (Premium tier)
- ✅ GRS backup for SQL Database (paired region)
- ❌ No automatic failover to secondary region
- ❌ No active resources in secondary region

### 3.2 Target State (Multi-Region Active-Passive)

```text
┌─────────────────────────────────┐     ┌─────────────────────────────────┐
│  swedencentral (Primary)        │     │  germanywestcentral (Secondary) │
│  ┌───────────────────────┐     │     │  ┌───────────────────────┐      │
│  │ App Service (Active)  │     │     │  │ App Service (Standby) │      │
│  │ Functions (Active)    │     │     │  │ Functions (Standby)   │      │
│  └───────────────────────┘     │     │  └───────────────────────┘      │
│                                 │     │                                 │
│  ┌───────────────────────┐     │     │  ┌───────────────────────┐      │
│  │ SQL (Primary Replica) │────────────→│ SQL (Geo-Secondary)   │      │
│  └───────────────────────┘     │     │  └───────────────────────┘      │
└─────────────────────────────────┘     └─────────────────────────────────┘
                    │                                     │
                    └──────────────┬──────────────────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    │     Azure Front Door        │
                    │     (Global Load Balancer)  │
                    └─────────────────────────────┘
```

**Enhancements Required:**

| Component           | Enhancement                  | Monthly Cost |
| ------------------- | ---------------------------- | ------------ |
| SQL Geo-Replication | Active geo-replication       | +$153        |
| App Service (DR)    | P1v4 instance (warm standby) | +$229        |
| Functions (DR)      | EP1 instance (warm standby)  | +$200        |
| Service Bus Geo-DR  | Premium tier pairing         | +$58         |
| **Total**           |                              | **+$640**    |

---

### 3.3 Planned Failover (Maintenance)

Use for scheduled maintenance, region migrations, or DR testing.

**Step 1: Prepare Secondary Region**

```bash
# Verify secondary resources are healthy
az webapp show --name app-ecommerce-api-dr --resource-group rg-ecommerce-dr \
  --query "state" -o tsv
```

**Step 2: Redirect Traffic**

```bash
# Update Front Door to route to secondary
az afd endpoint update \
  --resource-group rg-ecommerce-prod \
  --profile-name afd-ecommerce-prod-001 \
  --endpoint-name ecommerce-endpoint \
  --enabled-state Disabled

# Enable DR endpoint
az afd endpoint update \
  --resource-group rg-ecommerce-dr \
  --profile-name afd-ecommerce-dr-001 \
  --endpoint-name ecommerce-endpoint \
  --enabled-state Enabled
```

**Step 3: Promote SQL Secondary**

```bash
# For planned failover (no data loss)
az sql db replica set-primary \
  --resource-group rg-ecommerce-dr \
  --server sql-ecommerce-dr-gwc \
  --name ecommercedb
```

**Step 4: Verify Services**

```bash
# Health check endpoints
curl -s https://app-ecommerce-api-dr.azurewebsites.net/health
curl -s https://ecommerce.example.com/health
```

### 3.4 Unplanned Failover (Disaster)

Use when primary region is unavailable.

**Step 1: Assess Situation**

```bash
# Check Azure status
az resource show --ids /subscriptions/{sub}/resourceGroups/rg-ecommerce-prod \
  --query "properties.provisioningState"

# Check Front Door health probes
az afd origin show --resource-group rg-ecommerce-prod \
  --profile-name afd-ecommerce-prod-001 \
  --origin-group-name default-origin-group \
  --origin-name primary-origin \
  --query "enabledState"
```

**Step 2: Force SQL Failover**

```bash
# Forced failover (potential data loss based on RPO)
az sql db replica set-primary \
  --resource-group rg-ecommerce-dr \
  --server sql-ecommerce-dr-gwc \
  --name ecommercedb \
  --allow-data-loss
```

**Step 3: Update DNS/Front Door**

```bash
# Front Door automatically routes to healthy origin
# If needed, manually disable failed origin:
az afd origin update \
  --resource-group rg-ecommerce-prod \
  --profile-name afd-ecommerce-prod-001 \
  --origin-group-name default-origin-group \
  --origin-name primary-origin \
  --enabled-state Disabled
```

**Step 4: Notify Stakeholders**

```bash
# Send incident notification
# See Operations Runbook for escalation contacts
```

### 3.5 SQL Database Point-in-Time Recovery

**Scenario**: Accidental data deletion or corruption

```bash
# 1. Identify restore point
az sql db list-restore-points \
  --resource-group rg-ecommerce-prod \
  --server sql-ecommerce-prod-swc-{suffix} \
  --database ecommercedb

# 2. Restore to new database
az sql db restore \
  --resource-group rg-ecommerce-prod \
  --server sql-ecommerce-prod-swc-{suffix} \
  --name ecommercedb \
  --dest-name ecommercedb-restored-$(date +%Y%m%d) \
  --time "2025-12-17T10:00:00Z"

# 3. Validate restored data
# Connect and verify critical tables

# 4. Swap databases (during maintenance window)
# Rename current → _old, restored → production
```

### 5.2 Key Vault Secret Recovery

**Scenario**: Accidentally deleted secret

```bash
# 1. List deleted secrets
az keyvault secret list-deleted \
  --vault-name kv-ecommerce-prod-{suffix}

# 2. Recover specific secret
az keyvault secret recover \
  --vault-name kv-ecommerce-prod-{suffix} \
  --name <secret-name>
```

### 5.3 App Service Recovery

**Scenario**: Failed deployment or configuration issue

```bash
# Option 1: Swap back to previous slot
az webapp deployment slot swap \
  --resource-group rg-ecommerce-prod \
  --name app-ecommerce-api-prod-swc-001 \
  --slot staging \
  --target-slot production

# Option 2: Redeploy from IaC
cd infra/bicep/ecommerce
./deploy.ps1 -Environment prod -Location swedencentral
```

### 5.4 Complete Environment Recovery

**Scenario**: Full region failure (no multi-region setup)

1. **Create new resource group in secondary region**

   ```bash
   az group create --name rg-ecommerce-dr --location germanywestcentral
   ```

2. **Restore SQL from geo-backup**

   ```bash
   az sql db create \
     --resource-group rg-ecommerce-dr \
     --server sql-ecommerce-dr-gwc \
     --name ecommercedb \
     --edition GeneralPurpose \
     --family Gen5 \
     --capacity 2 \
     --backup-storage-redundancy Geo
   ```

3. **Redeploy infrastructure**

   ```bash
   cd infra/bicep/ecommerce
   ./deploy.ps1 -Environment prod -Location germanywestcentral
   ```

4. **Rebuild search index**

   ```bash
   # Trigger indexer to rebuild from SQL
   az search indexer run \
     --resource-group rg-ecommerce-dr \
     --service-name srch-ecommerce-dr-gwc \
     --name ecommerce-indexer
   ```

5. **Update DNS/Front Door to new endpoints**

---

## 4. Testing Schedule

| Test Type                  | Frequency | Duration | Stakeholders                  |
| -------------------------- | --------- | -------- | ----------------------------- |
| Backup Verification        | Weekly    | 1 hour   | Operations Team               |
| Point-in-Time Restore Test | Monthly   | 2 hours  | DBA, Operations               |
| Failover Drill (Planned)   | Quarterly | 4 hours  | All Teams, Management         |
| Full DR Test               | Annually  | 8 hours  | All Teams, Executives, Vendor |

### Test Checklist

- [ ] Verify backup completeness
- [ ] Test restore procedures
- [ ] Validate data integrity post-restore
- [ ] Measure actual RTO/RPO vs targets
- [ ] Document lessons learned
- [ ] Update runbooks as needed

---

## 5. Communication Plan

### 5.1 Backup Monitoring

| Alert                     | Condition                  | Severity | Action                     |
| ------------------------- | -------------------------- | -------- | -------------------------- |
| Backup Failed             | SQL backup job failure     | Sev 1    | Immediate investigation    |
| Backup Age > 24h          | No backup in last 24 hours | Sev 2    | Investigate within 4 hours |
| Geo-Replication Lag > 1hr | SQL geo-replication delay  | Sev 2    | Check network/load         |
| Storage Capacity < 20%    | Backup storage running low | Sev 3    | Plan capacity increase     |

### 7.2 Log Analytics Queries

**Check SQL Backup Status:**

```kusto
AzureDiagnostics
| where Category == "SQLSecurityAuditEvents"
| where OperationName == "BACKUP"
| summarize LastBackup = max(TimeGenerated) by Resource
| where LastBackup < ago(24h)
```

**Check Geo-Replication Lag:**

```kusto
AzureMetrics
| where ResourceProvider == "MICROSOFT.SQL"
| where MetricName == "geo_replication_lag_seconds"
| summarize AvgLag = avg(Average) by bin(TimeGenerated, 1h)
| where AvgLag > 3600
```

---

## 6. Roles and Responsibilities

| Role                    | Responsibility                              |
| ----------------------- | ------------------------------------------- |
| **DR Coordinator**      | Owns DR plan, coordinates drills            |
| **DBA**                 | SQL backup/restore, data integrity          |
| **Platform Engineer**   | App Service, Functions, networking recovery |
| **Security Lead**       | Key Vault recovery, access validation       |
| **Communications Lead** | Stakeholder notifications, status updates   |

---

## 7. Dependencies

| Dependency       | Failure Impact            | Mitigation                     |
| ---------------- | ------------------------- | ------------------------------ |
| Azure SQL        | No transaction processing | Geo-replication + failover     |
| Azure Key Vault  | No secrets access         | Soft delete + purge protection |
| Azure Front Door | No traffic routing        | Multi-region endpoints         |
| Azure AD         | No authentication         | N/A (Azure-wide issue)         |

---

## 8. Recovery Runbooks

| Runbook             | Location    | Owner             |
| ------------------- | ----------- | ----------------- |
| SQL PITR Restore    | Section 3.5 | DBA               |
| Planned Failover    | Section 3.3 | Platform Engineer |
| Unplanned Failover  | Section 3.4 | DR Coordinator    |
| Full Infrastructure | Section 3.6 | Platform Engineer |

---

## 9. Appendix

### 9.1 Document Control

| Version | Date       | Author                       | Changes         |
| ------- | ---------- | ---------------------------- | --------------- |
| 1.0     | 2025-12-17 | Workload Documentation Agent | Initial version |

---

### 9.2 References

- [Azure SQL Database Backup](https://learn.microsoft.com/azure/azure-sql/database/automated-backups-overview)
- [Azure SQL Geo-Replication](https://learn.microsoft.com/azure/azure-sql/database/active-geo-replication-overview)
- [Key Vault Backup and Restore](https://learn.microsoft.com/azure/key-vault/general/backup)
- [App Service Backup](https://learn.microsoft.com/azure/app-service/manage-backup)
- [Azure Front Door Disaster Recovery](https://learn.microsoft.com/azure/frontdoor/front-door-overview)
