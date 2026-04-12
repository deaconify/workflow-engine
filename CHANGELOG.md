# Changelog

All notable changes to the workflow-engine will be documented in this file.

## [1.0.0] - 2026-04-11

### Added

- Initial release with 9 generalized agents
- Standard Workflow protocol (standard-workflow.md)
- Workflow summary for CLAUDE.md @import (workflow-summary.md)
- Planning protocol with follow-up issue template
- GitHub issue standards (naming, labels, sub-issues)
- Compliance agent patterns (IRD format, table templates, ADR pre-scan)
- Compliance trigger matrix (scaffolding template)
- Sync script with GitHub download, contamination check, and init mode
- Scaffolding for new project bootstrap (CLAUDE.md, project-context.example.md, brain structure)
- 34 cross-project feedback entries from Deaconify development

### Design Principles

- Agents contain zero project-specific content
- All project context in `brain/reference/project-context.md`
- CLAUDE.md uses `@` imports for compaction-safe brain references
- Sync = pure file copy, no template rendering
- Contamination check prevents language-specific terms in shared files
