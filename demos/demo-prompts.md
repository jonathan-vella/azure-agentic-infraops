Create a deployment plan for a multi-tier e-commerce platform on Azure with the following requirements:

Business Requirements:

- High availability (99.9% SLA) for a retail website serving European customers
- Handle peak traffic of 10,000 concurrent users during sales events
- PCI-DSS compliance for payment data handling
- Sub-100ms response time for product catalog queries

Technical Requirements:

- Web frontend (React SPA)
- REST API backend (.NET 8)
- Product catalog database with full-text search
- User session caching
- Order processing with async capabilities
- Secure secrets management
- CDN for static assets

Constraints:

- Region: swedencentral (primary)
- Budget: Mid-tier (not the cheapest, but cost-conscious)
- Team has Azure PaaS experience but limited Kubernetes knowledge

Please provide a detailed implementation plan including:

1. Recommended Azure services for each component
2. Network architecture
3. Security considerations
4. Estimated monthly costs
5. Implementation phases
