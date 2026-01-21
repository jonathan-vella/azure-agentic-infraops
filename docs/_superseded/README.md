# Superseded Documentation

> **⚠️ ARCHIVED CONTENT - NOT ACTIVELY MAINTAINED**

This folder contains documentation that has been superseded by content in the active `docs/` folders.
Files are preserved for historical reference and to maintain git history.

---

## Purpose

When documentation is reorganized, consolidated, or becomes out-of-scope for the current project direction,
files are moved here rather than deleted. This approach:

- Preserves git history for all documentation
- Allows recovery if content becomes relevant again
- Provides historical context for architectural decisions

---

## Contents

| Folder | Description | Active Replacement |
|--------|-------------|-------------------|
| `adr/` | Architecture Decision Records | Referenced from `docs/README.md` |
| `diagrams/` | Generated architecture diagrams | `agent-output/{project}/` |
| `getting-started/` | Snapshot of getting-started guides | `docs/getting-started/` |
| `guides/` | Snapshot of how-to guides | `docs/guides/` |
| `presenter/` | Snapshot of presenter materials | `docs/presenter/` |
| `reference/` | Snapshot of reference docs | `docs/reference/` |

---

## Notable Archived Files

| File | Reason Archived |
|------|-----------------|
| `guides/terraform-extension-guide.md` | Project is Bicep-only; guide preserved for future Terraform adoption |
| `guides/getting-started-journey.md` | Consolidated with `getting-started/learning-paths.md` |

---

## Guidelines

1. **Do not edit files in this folder** — they are historical snapshots
2. **Do not add new files here** — use active `docs/` folders
3. **Reference with caution** — links may point to outdated resources
4. **Version strings are frozen** — they reflect the version when archived

---

**Archived**: 2026-01-21 | **Version at archive**: 5.3.0
