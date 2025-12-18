# Changelog

All notable changes to **Agentic InfraOps** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.7.1] - 2025-12-18

- fix: Complete docs rebuild cleanup - fix broken links and old path references

## [Unreleased] - Docs Rebuild Complete

### Added

- **docs/reference/** - Single-source-of-truth folder with 5 files:

  - `defaults.md` - Regions, CAF naming, tags, SKUs, security baseline
  - `agents-overview.md` - All 7 agents comparison table with examples
  - `workflow.md` - Canonical 7-step workflow diagram
  - `bicep-patterns.md` - Unique suffix, diagnostic settings, policy workarounds
  - `README.md` - Folder index

- **docs/getting-started/** - Consolidated getting-started folder:

  - `quickstart.md` - Merged quickstart + prerequisites (10-min guide)
  - `first-scenario.md` - Detailed S01 Bicep Baseline walkthrough
  - `learning-paths.md` - Complete learning journey paths
  - `README.md` - Folder index

- **docs/presenter/** - Merged presenter folder (from presenter-toolkit + value-proposition):

  - Unified README with quick navigation table
  - 16 files from presenter-toolkit
  - 3 files from value-proposition

- **Persona-based navigation** in docs/README.md:

  - Mermaid diagram showing 3 entry paths
  - Beginner / Experienced / Presenter paths
  - Quick Find table for common resources
  - Collapsible folder structure sections

- **Emoji difficulty tags** in scenarios/README.md:

  - 🟢 Beginner, 🟡 Intermediate, 🔴 Advanced
  - Difficulty legend explaining each level

- **.github/agents/shared/agent-foundation.md** - Shared foundation for all agents

### Changed

- Updated root README.md links to new docs structure
- Updated copilot-instructions.md with Reference Documentation section
- Updated diagrams/README.md with version and correct links
- Fixed version 3.2.0 → 3.6.0 in 4 files

### Fixed

- **Broken links cleanup**: Fixed 30+ references to old folder paths
  - `presenter-toolkit/` → `presenter/`
  - `value-proposition/` → `presenter/`
  - `S03-five-agent-workflow/` → `S03-agentic-workflow/`
- Updated `.github/workflows/update-version.yml` with correct paths
- Updated `scripts/update-version.ps1` with correct paths
- Updated `.markdownlint-cli2.jsonc` ignore patterns
- Fixed internal cross-references in presenter/ folder files
- Fixed infographics path in time-savings-evidence.md and executive-pitch.md

### Removed

- **docs/presenter-toolkit/** - Merged into docs/presenter/
- **docs/value-proposition/** - Merged into docs/presenter/

## [3.7.0] - 2025-12-17

- feat: Add static-webapp-test workflow validation example

## [3.6.0] - 2025-12-17

- feat: Integrate requirements template into workflow

## [3.6.0] - 2025-01-17

### Changed

- **feat!: Restructure to 7-step workflow** with Deploy as new Step 6

  - Step 1: @plan → `01-requirements.md`
  - Step 2: azure-principal-architect → `02-*` files
  - Step 3: Design Artifacts → `03-des-*` files (optional)
  - Step 4: bicep-plan → `04-*` files
  - Step 5: bicep-implement → `05-*` + Bicep code
  - Step 6: Deploy → `06-deployment-summary.md` (NEW)
  - Step 7: As-Built Artifacts → `07-*` files (optional)

- **Standardized artifact suffixes**:

  - Design phase: `-des` suffix (was `-design`)
  - As-built phase: `-ab` suffix (was `-asbuilt`)

- **Cost estimates moved to Step 3** as design artifacts (`03-des-cost-estimate.md`)

- **Updated all file prefixes** to match step numbers (01- through 07-)

- **Added Azure Pricing MCP fallback chain** to copilot-instructions.md:

  1. Azure Pricing MCP (first choice)
  2. fetch_webpage (official pricing pages)
  3. Azure Retail API (curl)
  4. Azure Pricing Calculator (manual)
  5. Web search (last resort)

- Updated all agent definition files (.github/agents/\*.agent.md)
- Updated docs/workflow/WORKFLOW.md with new 7-step flow
- Updated scenarios README files with new workflow references
- Fixed cost-estimate.instructions.md applyTo pattern

## [3.5.0] - 2025-12-17

- feat(workflow-generator): add initial setup for workflow diagram generation

## [3.4.0] - 2025-12-17

- feat: add workload documentation generator agent (optional Step 7)

## [3.3.0] - 2025-12-17

- feat: centralize agent outputs and add automated versioning

## [3.1.0] - 2025-12-03

### Changed

- **Reorganized docs/ folder structure** with new subfolders for better navigation:
  - `docs/workflow/` - Workflow documentation (moved WORKFLOW.md)
  - `docs/getting-started/` - Quick start and prerequisites (moved QUICKSTART.md)
  - `docs/guides/` - Troubleshooting and how-tos (moved troubleshooting.md)
  - `docs/value-proposition/` - ROI, time savings, executive pitch (moved 4 files)
  - `docs/cost-estimates/` - Azure pricing examples (moved ecommerce-cost-estimate.md)
- **Reorganized scenarios/ folder** with quick-demos subfolder:
  - `scenarios/quick-demos/` - Simple prompt-based demos (moved 4 standalone files)
  - Renamed `scenarios-index.md` → `scenarios/README.md`
  - Renamed `scenario-prompts.md` → `quick-demos/ecommerce-prompts.md`
- Added `docs/README.md` as documentation hub
- Added `scenarios/quick-demos/README.md` as quick demos index
- Updated all internal links to reflect new file locations

### Breaking Changes (File Paths)

- `docs/WORKFLOW.md` → `docs/workflow/WORKFLOW.md`
- `docs/QUICKSTART.md` → `docs/getting-started/QUICKSTART.md`
- `docs/troubleshooting.md` → `docs/guides/troubleshooting.md`
- `docs/time-savings-evidence.md` → `docs/value-proposition/time-savings-evidence.md`
- `docs/executive-pitch.md` → `docs/value-proposition/executive-pitch.md`
- `scenarios/scenario-prompts.md` → `scenarios/quick-demos/ecommerce-prompts.md`
- `scenarios/scenarios-index.md` → `scenarios/README.md`

## [3.2.0] - 2025-12-07

### Added

- **Character Reference Card** (`docs/presenter-toolkit/character-reference.md`) with all 11 personas
- **"Meet [Character]" sections** added to S03 and S04 scenario READMEs
- **New characters**: Jennifer Chen (S03), Carlos Mendez (S04)
- GitHub Actions CI workflow (`.github/workflows/validate.yml`) with 5 validation jobs
- Shared agent configuration (`.github/agents/_shared/defaults.md`) for centralized settings
- Healthcare patient portal scenario (`scenarios/quick-demos/healthcare-demo.md`)
- Data analytics platform scenario (`scenarios/quick-demos/analytics-demo.md`)
- Static website scenario (`scenarios/quick-demos/static-site-demo.md`)
- Architecture Decision Records (ADRs) for key design decisions:
  - ADR-001: Four-step agent workflow design
  - ADR-002: Azure Pricing MCP server integration
  - ADR-003: AVM-first approach for Bicep
  - ADR-004: Default region selection (swedencentral)
- Project improvements plan (`docs/plans/project-improvements.md`)
- This CHANGELOG file

### Changed

- **Scenario restructure**: Renumbered S01-S11 (was S01-S10 with duplicate S04)
- **Character collision resolution**:
  - S03: Sarah Chen → Jennifer Chen (Solutions Architect)
  - S07: Sarah Chen → Maya Patel (On-Call SRE)
  - S09: Marcus Chen → David Kim (Solutions Architect)
  - Secondary stakeholders renamed to avoid main character collisions
- **Presenter toolkit**: Added character-reference link, updated scenario count to S01-S11
- **scenarios/README.md**: Complete rewrite with correct character assignments and time savings
- Azure Pricing MCP server improvements:
  - Removed automatic 10% discount application in cost estimates
  - Added singleton HTTP session pattern to prevent connection errors
  - Added 1-hour TTL caching for API responses (cachetools)
  - Added 30-second timeout for API calls
  - Changed devcontainer setup to use editable install (`pip install -e .`)
- Added pricing accuracy disclaimers to documentation

### Fixed

- Duplicate S04 folders (S04-documentation-generation and S04-ecommerce-platform)
- Character name collisions across scenarios
- Scenario header numbers not matching folder names after restructure
- MCP server "Connector is closed" errors via singleton session pattern
- Devcontainer MCP setup failing to find server module

## [Unreleased]

## [2.0.0] - 2025-12-01

### Changed

- **Breaking**: Repository restructured to focus on 7-step agent workflow
- Simplified folder structure (removed legacy scenarios folder)
- Clean slate for `scenarios/`, `infra/bicep/`, `docs/adr/`, `docs/diagrams/`

### Added

- 6 custom agents for Azure infrastructure workflow:
  - `azure-principal-architect` - WAF assessment (architecture guidance only)
  - `bicep-plan` - Implementation planning with AVM modules
  - `bicep-implement` - Bicep code generation
  - `diagram-generator` - Python architecture diagrams
  - `adr-generator` - Architecture Decision Records
  - `workload-documentation-generator` - Customer-deliverable documentation
- Comprehensive workflow documentation (`docs/workflow/WORKFLOW.md`)
- E-commerce platform scenario prompts (`scenarios/quick-demos/ecommerce-prompts.md`)
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
