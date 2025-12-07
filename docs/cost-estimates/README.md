# Cost Estimates

This folder contains Azure pricing examples generated for various infrastructure scenarios.

## Available Estimates

| Estimate | Description |
| -------- | ----------- |
| [E-Commerce Cost Estimate](ecommerce-cost-estimate.md) | PCI-DSS compliant retail platform (~$1,595/month) |

## About Cost Estimates

Cost estimates are generated using the Azure Pricing MCP server, which queries real-time Azure retail prices.
These estimates provide:

- Monthly and annual cost projections
- Cost breakdown by service category
- Regional price comparisons
- Savings opportunities with reservations

## Generating New Estimates

The `azure-principal-architect` agent can generate cost estimates as part of the architecture assessment.
You can also use the Azure Pricing MCP tools directly:

- `azure_price_get` - Get specific service pricing
- `azure_region_recommend` - Compare regional costs
- `azure_estimate_project` - Estimate multi-resource deployments

## Related Documentation

- [Azure Pricing MCP](../../mcp/azure-pricing-mcp/) - Real-time pricing tools
- [ROI Calculator](../presenter-toolkit/roi-calculator.md) - Calculate time and cost savings
