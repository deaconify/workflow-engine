# Changelog

All notable changes to the workflow-engine will be documented in this file.

## [1.2.0] - 2026-04-12

### Added

- **Step 4c: ADR Coverage Check** — new orchestrator-inline step between reviewer approval (4b) and close-out (4d). Verifies all design decisions from Step 2b have corresponding ADRs, all EXPLAIN constraints are documented, and researcher findings that set precedents are formalized. No agent spawn — orchestrator does it directly. Presents gaps to user via `AskUserQuestion`.
- **ADR Coverage row** in the close-out summary table (Step 4d) — reports design decisions documented, EXPLAIN constraints satisfied, and researcher findings reviewed.

### Changed

- Close-out summary moved from Step 4c to **Step 4d** to accommodate the new ADR check step.
- Close-out table template in compliance-agent-patterns.md updated to match (Step 4d, ADR Coverage row added).
- Fixed MD060 table separator warnings in workflow-summary.md.

### Fixed

- **IRD GitHub comment must be FULL content** — Step 2b now explicitly requires posting the complete IRD in the exact table format as the GitHub comment. Previous wording ("Add a comment with the approved IRD content") was vague and led to partial/summarized posts. The comment must NOT reference the temp file path `brain/sessions/ird-{issue}.md` since it's deleted at Step 8.

## [1.1.0] - 2026-04-12

### Changed

- **Inlined IRD table templates into standard-workflow.md** — Steps 2b, 4b, and 4c now contain the exact table format directly instead of referencing compliance-agent-patterns.md via a two-hop indirection. This eliminates the failure mode where the orchestrator skips reading the second file after context compression and freeforms the presentation.
- **Strengthened workflow-summary.md** — replaced "All presentation tables use formats from compliance-agent-patterns.md" (an indirect pointer that doesn't survive compaction) with three explicit bullets describing each table's structure and noting that templates are inlined in standard-workflow.md. Also clarified that tables go in markdown text first, with AskUserQuestion used only for the short approval question.

### Why

Issue #606 revealed inconsistent IRD presentation — the orchestrator produced freeform output instead of the mandatory table format. Root cause: the table templates lived only in compliance-agent-patterns.md, and standard-workflow.md pointed to them with a "read this other file" reference. After context compression, the orchestrator didn't follow the two-hop path.

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
