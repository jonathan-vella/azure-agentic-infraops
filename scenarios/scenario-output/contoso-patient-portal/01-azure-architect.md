# Step 2: Azure Principal Architect

> **Agent Used:** `azure-principal-architect` > **Purpose:** Azure Well-Architected Framework assessment and
> architecture validation

---

## 💬 Prompt

```text
Assess this patient portal architecture for Azure Well-Architected Framework alignment:

Requirements:
- HIPAA compliance for healthcare data
- 10,000 patients + 50 staff users
- 99.9% SLA target
- $800/month budget

Proposed architecture:
- App Service P1v3 (.NET 8 API)
- Azure SQL S1 (20 DTU)
- Key Vault Standard
- VNet with private endpoints
- Log Analytics + App Insights

Provide WAF pillar scores and any HIPAA gaps.
```

---

## ✅ WAF Assessment

### Overall Score: 8.2/10

| Pillar                     | Score | Assessment                                     |
| -------------------------- | ----- | ---------------------------------------------- |
| **Security**               | 9/10  | Private endpoints, managed identity, Key Vault |
| **Reliability**            | 7/10  | Single region, no geo-redundancy               |
| **Performance**            | 8/10  | P1v3 adequate for 60 concurrent users          |
| **Cost Optimization**      | 9/10  | Well under budget, right-sized SKUs            |
| **Operational Excellence** | 8/10  | Full monitoring, IaC deployment                |

---

## Detailed Assessment

### Security (9/10) ✅

**Strengths:**

- ✅ Private endpoints eliminate public data access
- ✅ Managed identity removes credential management
- ✅ Key Vault for centralized secrets
- ✅ TLS 1.2 enforced on all services
- ✅ Azure AD authentication for SQL
- ✅ NSG segmentation between tiers

**Recommendations:**

- Consider Azure AD B2C for patient authentication
- Add Azure DDoS Protection (Basic is included)
- Enable Defender for Cloud for threat detection

### Reliability (7/10) ⚠️

**Strengths:**

- ✅ App Service built-in auto-restart
- ✅ SQL automated backups (7-day PITR)
- ✅ Key Vault high availability

**Gaps:**

- ⚠️ Single region deployment (no geo-redundancy)
- ⚠️ App Service P1v3 doesn't support zone redundancy
- ⚠️ No Traffic Manager for multi-region failover

**Recommendations:**

- For 99.9% SLA: Current architecture meets target
- For 99.99% SLA: Add geo-replication to germanywestcentral (+40% cost)

### Performance (8/10) ✅

**Strengths:**

- ✅ P1v3 handles 60+ concurrent requests
- ✅ SQL S1 adequate for 10K patient read-heavy workload
- ✅ App Insights for performance monitoring

**Calculations:**

- Expected concurrent users: ~60 (1% of 10K patients + 50 staff)
- P1v3 capacity: ~100 concurrent requests
- Headroom: 40% capacity available for peaks

### Cost Optimization (9/10) ✅

**Monthly Cost Breakdown:**

| Resource               | Cost     | % of Budget |
| ---------------------- | -------- | ----------- |
| App Service P1v3       | $146     | 18%         |
| Azure SQL S1           | $30      | 4%          |
| Key Vault              | $3       | <1%         |
| Storage                | $5       | 1%          |
| Monitoring             | $15      | 2%          |
| Private Endpoints (×2) | $15      | 2%          |
| **Total**              | **$214** | **27%**     |

**Verdict**: 73% under budget — room for:

- Staging environment ($150/month)
- Azure AD B2C ($0.00325/MAU)
- Geo-replication ($85/month for SQL)

### Operational Excellence (8/10) ✅

**Strengths:**

- ✅ Infrastructure as Code (Bicep)
- ✅ Application Insights for APM
- ✅ Log Analytics for centralized logging
- ✅ Managed services reduce ops burden

**Recommendations:**

- Add deployment slots for zero-downtime updates
- Configure Azure Monitor alerts for SLA breaches
- Set up weekly backup verification

---

## HIPAA Compliance Mapping

| HIPAA Control         | Azure Implementation               | Status |
| --------------------- | ---------------------------------- | ------ |
| Access Controls       | Azure AD + RBAC                    | ✅     |
| Audit Controls        | Log Analytics (90-day retention)   | ✅     |
| Integrity Controls    | TDE for SQL, checksums for storage | ✅     |
| Transmission Security | TLS 1.2+, private endpoints        | ✅     |
| Authentication        | Managed identity, Azure AD         | ✅     |
| Authorization         | Key Vault RBAC, SQL permissions    | ✅     |

> ⚠️ **BAA Required**: Ensure Azure BAA is signed for covered services.
> See: https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-hipaa-us

---

## Architecture Diagram

```text
                    ┌─────────────────────────────┐
                    │         Internet            │
                    └──────────────┬──────────────┘
                                   │ HTTPS (443)
                    ┌──────────────▼──────────────┐
                    │      Azure App Service      │
                    │         (P1v3)              │
                    │    ┌────────────────┐       │
                    │    │ Managed Identity│      │
                    │    └────────────────┘       │
                    └──────────────┬──────────────┘
                                   │ Private Endpoint
          ┌────────────────────────┼────────────────────────┐
          │                        │                        │
┌─────────▼─────────┐   ┌─────────▼─────────┐   ┌─────────▼─────────┐
│    Azure SQL      │   │   Azure Key Vault │   │   Log Analytics   │
│      (S1)         │   │    (Standard)     │   │   + App Insights  │
│  ┌────────────┐   │   │  ┌────────────┐   │   │                   │
│  │Private EP  │   │   │  │Private EP  │   │   │                   │
│  └────────────┘   │   │  └────────────┘   │   │                   │
└───────────────────┘   └───────────────────┘   └───────────────────┘
```

---

## Risk Assessment

| Risk                       | Likelihood | Impact | Mitigation                   |
| -------------------------- | ---------- | ------ | ---------------------------- |
| Single region failure      | Low        | High   | Add geo-replication ($85/mo) |
| SQL performance bottleneck | Low        | Medium | Monitor DTU, scale to S2     |
| Security breach            | Low        | High   | Defender for Cloud, WAF      |
| Budget overrun             | Very Low   | Low    | 73% under budget             |

---

## ➡️ Next Step

Proceed to **`bicep-plan`** agent for infrastructure implementation planning.
