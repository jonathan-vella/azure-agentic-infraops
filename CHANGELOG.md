# Changelog

All notable changes to the GitHub Copilot Azure Infrastructure Workflow will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- GitHub Actions CI workflow (`.github/workflows/validate.yml`) with 5 validation jobs
- Shared agent configuration (`.github/agents/_shared/defaults.md`) for centralized settings
- Healthcare patient portal scenario (`scenarios/healthcare-demo.md`)
- Data analytics platform scenario (`scenarios/analytics-demo.md`)
- Static website scenario (`scenarios/static-site-demo.md`)
- Architecture Decision Records (ADRs) for key design decisions:
  - ADR-001: Four-step agent workflow design
  - ADR-002: Azure Pricing MCP server integration
  - ADR-003: AVM-first approach for Bicep
  - ADR-004: Default region selection (swedencentral)
- Project improvements plan (`docs/plans/project-improvements.md`)
- This CHANGELOG file

### Changed

- Azure Pricing MCP server improvements:
  - Removed automatic 10% discount application in cost estimates
  - Added singleton HTTP session pattern to prevent connection errors
  - Added 1-hour TTL caching for API responses (cachetools)
  - Added 30-second timeout for API calls
  - Changed devcontainer setup to use editable install (`pip install -e .`)
- Added pricing accuracy disclaimers to documentation:
  - `mcp/azure-pricing-mcp/README.md`
  - `.github/instructions/cost-estimate.instructions.md`
  - `docs/ecommerce-cost-estimate.md`

### Fixed

- MCP server "Connector is closed" errors via singleton session pattern
- Devcontainer MCP setup failing to find server module

## [2.0.0] - 2025-12-01

### Changed

- **Breaking**: Repository restructured to focus on 4-step agent workflow
- Simplified folder structure (removed legacy scenarios folder)
- Clean slate for `scenarios/`, `infra/bicep/`, `docs/adr/`, `docs/diagrams/`

### Added

- 6 custom agents for Azure infrastructure workflow:
  - `azure-principal-architect` - WAF assessment (architecture guidance only)
  - `bicep-plan` - Implementation planning with AVM modules
  - `bicep-implement` - Bicep code generation
  - `diagram-generator` - Python architecture diagrams
  - `adr-generator` - Architecture Decision Records
  - `infrastructure-specialist` - Unified agent (optional)
- Comprehensive workflow documentation (`docs/WORKFLOW.md`)
- E-commerce platform scenario prompts (`scenarios/scenario-prompts.md`)
- Azure Pricing MCP server (`mcp/azure-pricing-mcp/`)
- Dev container with pre-configured tooling

### Removed

- Legacy scenarios and resources folders
- Outdated demo content

## [1.0.0] - 2024-06-01

### Added

- Initial repository structure
- Basic Bicep templates
- PowerShell deployment scripts
- GitHub Copilot instructions file

---

## Version Numbering

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to workflow or agent interfaces
- **MINOR**: New agents, demos, or significant feature additions
- **PATCH**: Bug fixes, documentation improvements, minor enhancements

## Links

- [VERSION.md](VERSION.md) - Detailed version history
- [GitHub Releases](https://github.com/jonathan-vella/azure-agentic-infraops/releases)
