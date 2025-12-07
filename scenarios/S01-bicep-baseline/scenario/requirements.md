# Customer Scenario: Financial Services Infrastructure

## Company Profile

**Organization**: Regional Bank Expansion to Azure  
**Industry**: Financial Services  
**Size**: 200 employees, mid-sized financial services firm  
**Current State**: On-premises datacenter, planning cloud migration

## Business Context

The bank is launching a new digital banking platform and needs to establish Azure infrastructure quickly.
The existing IT team has strong Windows Server and networking skills but limited cloud experience.
They've committed to a 6-month timeline for the first phase.

**Key Stakeholders:**

- **John Martinez** - IT Director: Focused on security and compliance
- **Sarah Chen** - Network Administrator: Responsible for connectivity and segmentation
- **Mike Johnson** - Systems Engineer: Will manage deployments and operations

## Technical Requirements

### 1. Network Architecture

The application requires a three-tier network design:

**Web Tier** (DMZ):

- Public-facing web servers
- HTTPS traffic from internet
- Forwarding to app tier

**Application Tier** (Secure Zone):

- Business logic servers
- Accessible only from web tier
- Can connect to data tier

**Data Tier** (Restricted Zone):

- Database servers and storage
- No direct internet access
- Private connectivity only

**Network Specifications:**

- VNet address space: `10.0.0.0/16`
- Web tier subnet: `10.0.1.0/24` (254 IPs)
- App tier subnet: `10.0.2.0/24` (254 IPs)
- Data tier subnet: `10.0.3.0/24` (254 IPs)
- Region: East US (primary)

### 2. Security Requirements

Per regulatory compliance (PCI-DSS, SOC 2):

**Network Security:**

- Network Security Groups (NSGs) on each subnet
- Web tier: Allow 80/443 inbound from internet
- App tier: Allow 8080 from web tier only
- Data tier: Allow 1433 from app tier only
- All tiers: Block all other inbound by default

**Storage Security:**

- Encrypted at rest (Microsoft-managed keys)
- TLS 1.2 minimum for data in transit
- No public blob access
- Audit logging enabled
- Soft delete enabled (7-day retention)

### 3. Storage Requirements

**Blob Storage** for application data:

- Hot tier (frequent access)
- Geo-redundant storage (GRS) for disaster recovery
- Private endpoint in data tier subnet
- Lifecycle management for cost optimization

**Capacity Planning:**

- Initial: 100 GB
- Growth: 50 GB/month
- 3-year projection: 1.8 TB

### 4. Naming and Tagging Standards

**Naming Convention:**

- VNet: `vnet-<env>-<app>-<region>`
- Subnet: `snet-<tier>-<env>`
- NSG: `nsg-<subnet>-<env>`
- Storage: `st<app><env><random>`

**Required Tags:**

| Tag         | Example Value  | Purpose                 |
| ----------- | -------------- | ----------------------- |
| Environment | Production     | Environment designation |
| Application | DigitalBanking | Application name        |
| Owner       | ITOperations   | Responsible team        |
| CostCenter  | CC-1234        | Billing allocation      |
| Compliance  | PCI-DSS        | Regulatory requirement  |

### 5. Operational Requirements

**Monitoring:**

- Azure Monitor integration
- Network Watcher for connectivity diagnostics
- Storage Analytics for blob access patterns

**Backup/Recovery:**

- Storage soft delete: 7 days
- NSG flow logs retained for 90 days
- Daily configuration backups

**Change Management:**

- All infrastructure defined as code (Bicep)
- Version controlled in Git
- Peer review required for production changes
- Automated testing before deployment

## Business Constraints

### Timeline Pressure

**Week 1-2**: Infrastructure foundation (this demo)  
**Week 3-4**: Application deployment  
**Week 5-6**: Security hardening and compliance validation

The team has only 2 weeks to get the core network and storage infrastructure deployed and validated.

### Skill Gap

**Current Team Expertise:**

- ✅ Strong: Windows Server, Active Directory, networking fundamentals
- ⚠️ Moderate: Azure Portal navigation, basic CLI commands
- ❌ Limited: Infrastructure as Code, Bicep/ARM, DevOps practices

**Challenge**: Need to produce near-production-ready Bicep templates without months of training.

### Budget Constraints

**Monthly Infrastructure Budget:** Constrained for demo/dev environment  
**Cost Optimization Required:**

- Use Standard tier where appropriate (not Premium)
- Leverage locally redundant storage for non-critical data
- Right-size subnets to avoid waste

### Compliance Requirements

**Audit Trail:**

- Who deployed what, when?
- Configuration change history
- Security rule modifications

**Documentation:**

- Architecture diagrams required
- Runbooks for common operations
- Disaster recovery procedures

## Success Criteria

The infrastructure deployment will be considered successful if:

1. ✅ **Deployment Speed**: Complete in <1 hour (not days)
2. ✅ **Security**: Pass automated compliance checks (Azure Policy)
3. ✅ **Reliability**: No deployment errors or rollbacks
4. ✅ **Maintainability**: Code is readable and well-documented
5. ✅ **Cost**: Low monthly run rate for demo/dev environment
6. ✅ **Knowledge Transfer**: Team can modify/extend templates independently

## Pain Points (Traditional Approach)

### 1. Learning Curve

- Bicep syntax is unfamiliar: 2-3 weeks training
- Azure resource schemas are complex: constant documentation lookups
- Best practices unclear: trial and error

**Estimated Impact:** 40+ hours of training and research

### 2. Template Development

- Writing VNet configuration: 15 minutes
- Defining NSG rules: 20 minutes (lots of brackets)
- Storage account settings: 10 minutes (finding right properties)
- Debugging deployment errors: 15 minutes average

**Estimated Impact:** 60+ minutes per attempt, 3-5 iterations typical

### 3. Error Troubleshooting

- Cryptic error messages: "Property 'X' not found on type 'Y'"
- Version mismatches: API versions change frequently
- Copy-paste errors: Missing commas, wrong indentation

**Estimated Impact:** 2-4 hours debugging per deployment

### 4. Documentation Burden

- Manually document each resource
- Keep diagrams in sync with code
- Write deployment runbooks

**Estimated Impact:** 3-4 hours per template

### Total Traditional Approach Time

**Estimated: 45-60 minutes for template development** (excluding training)  
**Plus: 40+ hours one-time learning investment**

## How Copilot Addresses These Pain Points

### Natural Language Interface

```bicep
// Create an Azure VNet with three subnets for web, app, and data tiers
```

No need to memorize syntax - describe what you need in plain English.

### Context-Aware Suggestions

- Copilot knows Azure resource schemas
- Suggests latest API versions
- Follows naming best practices automatically

### Built-In Best Practices

- Security configurations included by default
- Proper resource relationships
- Outputs for connecting resources

### Instant Documentation

- Code is self-documenting with clear structure
- Copilot can generate markdown docs from code
- Architecture diagrams from templates

### Expected Copilot Time

**10-15 minutes** for the same infrastructure  
**Zero training required** - learn by doing

## Scenario Extensions (For Longer Demos)

If you have more time or want to customize the demo:

### Extension 1: Add Monitoring

```bicep
// Add Log Analytics workspace and diagnostic settings for all resources
```

### Extension 2: Add Private Endpoints

```bicep
// Create a private endpoint for the storage account in the data tier subnet
// Add private DNS zone for blob.core.windows.net
```

### Extension 3: Add Azure Bastion

```bicep
// Add Azure Bastion subnet and host for secure VM access
```

### Extension 4: Add Firewall

```bicep
// Add Azure Firewall in a dedicated subnet for centralized security
```

### Extension 5: Multi-Region

```bicep
// Extend the infrastructure to West US for disaster recovery
```

## Real-World Context

This scenario is based on actual customer engagements where:

- **Mid-sized banks** are moving to cloud for digital transformation
- **IT teams** have strong traditional skills but limited cloud/IaC experience
- **Tight timelines** require rapid infrastructure deployment
- **Compliance requirements** demand security-first design
- **Budget constraints** make efficiency critical

GitHub Copilot bridges the gap between traditional IT expertise and modern cloud practices,
enabling teams to deliver faster without sacrificing quality.

---

**Next**: Review the [architecture diagram](./architecture.md) to visualize this infrastructure.

[🏠 Back to Demo README](../README.md)
