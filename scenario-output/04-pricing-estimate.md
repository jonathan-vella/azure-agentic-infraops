# Step 5: Real-Time Azure Pricing with MCP

> **Tools Used:** Azure Pricing MCP Server (`azure_price_search`, `azure_sku_discovery`, `azure_region_recommend`)  
> **Purpose:** Get accurate, real-time pricing from Azure Retail Prices API

---

## 💬 Prompt

```text
Use the Azure Pricing MCP tools to get real-time pricing for our e-commerce platform
components. I need accurate costs for:
- App Service P1v3 in swedencentral
- Azure Functions Premium EP1
- Azure SQL S3 (100 DTU)
- Azure Cache for Redis C2
- Azure Cognitive Search S1
- Service Bus Premium
- Azure Front Door Premium (PCI-DSS WAF)
```

---

## ✅ MCP Tool Calls & Results

### 1. App Service Plan P1v3 (Windows)

**Tool:** `azure_price_search`

```json
{
  "service_name": "App Service",
  "sku_name": "P1v3",
  "region": "swedencentral"
}
```

**Result:**

| Pricing Type | Price    | Unit         |
| ------------ | -------- | ------------ |
| Consumption  | $0.282/h | 1 Hour       |
| 1-Year SP    | $0.226/h | 1 Hour (20%) |
| 3-Year SP    | $0.180/h | 1 Hour (36%) |

**Monthly Cost:** $205.86 (PAYG) × 2 instances = **$411.72/month**

---

### 2. Azure Functions Premium EP1

**Tool:** `azure_price_search`

```json
{
  "service_name": "Functions",
  "sku_name": "EP1",
  "region": "swedencentral"
}
```

**Result:**

| Pricing Type | Price    | Unit   |
| ------------ | -------- | ------ |
| Consumption  | $0.169/h | 1 Hour |
| 1-Year SP    | $0.140/h | 1 Hour |
| 3-Year SP    | $0.140/h | 1 Hour |

**Monthly Cost:** **$123.37/month**

---

### 3. Azure Cognitive Search S1

**Tool:** `azure_price_search`

```json
{
  "service_name": "Azure Cognitive Search",
  "sku_name": "S1",
  "region": "swedencentral"
}
```

**Result:**

| Pricing Type | Price    | Unit   |
| ------------ | -------- | ------ |
| Consumption  | $0.336/h | 1 Hour |

**Monthly Cost:** **$245.28/month**

---

### 4. Azure Cache for Redis C2

**Tool:** `azure_price_search`

```json
{
  "service_name": "Redis Cache",
  "sku_name": "C2",
  "region": "swedencentral"
}
```

**Result:**

| Tier     | Price    | Unit   |
| -------- | -------- | ------ |
| Basic    | $0.090/h | 1 Hour |
| Standard | $0.112/h | 1 Hour |

**Monthly Cost:** **$65.70/month** (Basic) or **$81.76/month** (Standard with replication)

---

### 5. Regional Price Comparison

**Tool:** `azure_region_recommend`

```json
{
  "service_name": "App Service",
  "sku_name": "P1v3",
  "regions_to_compare": [
    "swedencentral",
    "westeurope",
    "northeurope",
    "eastus",
    "westus2"
  ]
}
```

**Result:**

| Region        | Monthly Cost | vs. swedencentral | Data Residency |
| ------------- | ------------ | ----------------- | -------------- |
| westus2       | $106.58      | -48%              | US West        |
| eastus        | $106.58      | -48%              | US East        |
| northeurope   | $127.75      | -38%              | EU (Ireland)   |
| westeurope    | $159.87      | -22%              | EU (NL)        |
| swedencentral | $205.86      | Baseline          | EU (Sweden) ✅ |

> 💡 **Decision:** Selected swedencentral despite higher costs for EU/GDPR data residency compliance.

---

## 📊 Updated Cost Summary

Based on real-time MCP pricing queries:

| Service                | SKU          | Monthly Cost  | Source                |
| ---------------------- | ------------ | ------------- | --------------------- |
| App Service Plan (×2)  | P1v3 Windows | $411.72       | azure_price_search    |
| Azure Functions        | EP1          | $123.37       | azure_price_search    |
| Azure Cognitive Search | S1           | $245.28       | azure_price_search    |
| Azure SQL Database     | S3 (100 DTU) | $145.16       | azure_price_search    |
| Azure Cache for Redis  | C2 Basic     | $65.70        | azure_price_search    |
| Service Bus            | Premium 1 MU | $677.08       | azure_price_search    |
| Azure Front Door       | Premium      | $330.00       | azure_price_search    |
| Private Endpoints (×5) | -            | $36.50        | Calculated            |
| Key Vault + Logging    | Standard     | $18.00        | azure_price_search    |
| **TOTAL**              | -            | **$2,212/mo** | Real-time MCP queries |

---

## 💰 Savings Opportunities Identified

**Tool:** `azure_price_search` with savings plan filters

| Resource         | PAYG/Month | 3-Year/Month | Annual Savings |
| ---------------- | ---------- | ------------ | -------------- |
| App Service (×2) | $411.72    | $263.50      | $1,779 (36%)   |
| Azure Functions  | $123.37    | $102.40      | $251 (17%)     |
| **Total**        | **$535**   | **$366**     | **$2,030/yr**  |

---

## 🔧 MCP Server Benefits

| Traditional Approach        | With Azure Pricing MCP        |
| --------------------------- | ----------------------------- |
| Manual Azure Calculator     | Automated API queries         |
| Static documentation prices | Real-time retail prices       |
| No savings plan visibility  | 1-year and 3-year rates shown |
| Manual regional comparison  | `azure_region_recommend` tool |
| ~30 min for cost estimate   | ~5 min with MCP tools         |

---

## ➡️ Output

Full cost estimate saved to: [`ecommerce-cost-estimate.md`](./ecommerce-cost-estimate.md)

---

## ➡️ Next Step

Proceed with **Bicep implementation** using the validated architecture and pricing.
