// ============================================================================
// E-Commerce Platform - Parameters File
// ============================================================================
// Environment: Production
// Region: swedencentral
// ============================================================================

using 'main.bicep'

// ============================================================================
// Core Parameters
// ============================================================================

param location = 'swedencentral'
param environment = 'prod'
param projectName = 'ecommerce'
param owner = 'platform-team'
param costCenter = 'CC-ECOM-001'

// ============================================================================
// SQL Server Azure AD Admin
// ============================================================================
// Replace with your Azure AD group object ID
param sqlAdminGroupObjectId = '00000000-0000-0000-0000-000000000000'
param sqlAdminGroupName = 'sql-admins'
