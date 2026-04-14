# Changelog

All notable changes to the workflow-engine will be documented in this file.

## [1.9.0] - 2026-04-14

### Added (1.9.0)

- **IRD Persistence Gate** — a `PreToolUse` hook (`scaffolding/hooks/ird-gate.sh`) that blocks `Edit`/`Write`/`MultiEdit`/`NotebookEdit` on implementation files while any `brain/sessions/.ird-pending-*` sentinel exists. The gate cannot be bypassed by forgetting a step — edits to implementation files are mechanically refused until the sentinel is removed.
- **Step 2 sentinel creation** — `standard-workflow.md` Step 2 now mandates `: > brain/sessions/.ird-pending-{issue}` before spawning the requirements-planner. This arms the gate.
- **Step 2b Persistence Gate substeps** — rewritten as a numbered, blocking checklist: (1) `Write` IRD then `Read` it back to verify, (2) `gh issue comment ... --body-file` then `gh issue view --comments` to verify the full table posted, (3) lint, (4) remove sentinel. Explicit anti-bypass warning: never remove the sentinel to unblock yourself.
- **sync.sh hook installation** — `init` installs `scaffolding/hooks/*.sh` to `.claude/hooks/` and, if no `.claude/settings.json` exists, creates one wired to `ird-gate.sh`. Regular `sync` refreshes hook scripts (overwrite) but leaves `settings.json` untouched. If a pre-existing `settings.json` doesn't reference `ird-gate.sh`, a warning tells the user to merge `.claude/hooks/settings.snippet.json` manually.

### Why (1.9.0)

Observed failure mode: orchestrator treated the IRD as a conversational artifact, got user approval, and moved straight into implementation — skipping both the `brain/sessions/ird-{issue}.md` write and the GitHub comment. Prose-level reminders in `standard-workflow.md` were not enough; the persistence step was easy to rationalize past.

Fix is layered: the workflow doc now presents Step 2b persistence as a blocking gate with verification commands (readable by the agent), and the hook enforces it mechanically (unbypassable). The hook is the belt; the workflow update is the suspenders.

## [1.8.0] - 2026-04-14

### Added (1.8.0)

- **TaskCreate mandate at Step 0** — orchestrator must create one TaskList entry per workflow step (0, 1, 1b, 2, 2b, 3, 4, 4b, 4c, 4d, 5, 6, 7, 8) and update status as it progresses. Workflow is not complete until every task is marked completed.
- **Interruption Protocol** — mid-workflow questions get a brief answer then return to the current `in_progress` task. Starting a new issue's workflow with a non-empty TaskList from a prior issue is forbidden unless the current workflow is explicitly aborted with user confirmation.
- **No False Terminations** — explicit statement that reviewer APPROVE, close-out table approval, branch push, and PR-opened (for projects that use PRs) are mid-flight milestones. Only Step 8 completion ends the workflow. Projects without PRs flow straight through Steps 5–8 per their merge policy (declared in `project-context.md`).
- **Step 4 mid-flight banner** — inline reminder that Steps 4–8 are a single continuous close-out.
- **Reviewer claim verification (Step 4b)** — orchestrator must spot-check reviewer findings about file existence, version strings, and counts before presenting. File-existence claims verified via `Glob`/`Read`.
- **Constraint recount (Step 4d)** — IRD Compliance row is recounted from `brain/sessions/ird-{issue-number}.md` directly, never copy-pasted from the reviewer's table. Tiers reported separately (MUST / SHOULD / EXPLAIN), never collapsed into a single unlabeled ratio.

### Why (1.8.0)

Two failure modes observed in consumer sessions:

1. **Mid-flight termination** — orchestrator stopped at "PR opened" or "reviewer APPROVE" and pivoted to a new issue, skipping Steps 4c–8 (ADR coverage, GitHub close-out, documenter, drift-detector, merge, close-out obligations). Root cause: workflow steps lived in prose and were dropped under interruption. Fix: mandate TaskCreate for Steps 0–8 so steps cannot silently disappear.
2. **Unverified reviewer output** — orchestrator copy-pasted reviewer findings (including a hallucinated "file does not exist" claim for a file that trivially existed) and reviewer-supplied ratios into the close-out table. Root cause: treating an agent's output as authoritative without spot-checking. Fix: require file-existence verification and independent recount from the IRD file.

Engine is PR-agnostic — merge policy remains defined per project in `project-context.md`.

## [1.7.0] - 2026-04-13

### Added (1.7.0)

- **Shell Hygiene section** added to all 9 agent definitions and to `workflow-summary.md`. Covers: trust the persistent Bash cwd (no `cd` prefixes), use dedicated tools over shell equivalents (`Read`/`Grep`/`Glob`/`Edit`/`Write`), no orientation commands (`pwd`/`ls`), forward slashes work on Windows.

### Why (1.7.0)

Sub-agents across multiple consumer projects were defensively prefixing every Bash command with `cd /path/to/project`, even though the working directory persists across calls and is already set. Per-project memory fixes caught individual instances but didn't propagate. Shared agent definitions are the right place for cross-cutting shell discipline.

## [1.6.0] - 2026-04-13

### Added (1.6.0)

- **Step 8 project-context re-read** — Orchestrator MUST re-read `brain/reference/project-context.md` at the start of close-out and execute every project-specific close-out obligation declared there. Generic categories named in the workflow (external time tracking, external status transitions, merge policy, notifications, session-state reconciliation) — projects that don't use a category simply omit it. No project-specific terminology in the engine.
- **Step 8 verification step** — Orchestrator must verify all declared close-out obligations were executed before declaring the session complete.

### Why (1.6.0)

Late in long sessions, context compression caused the orchestrator to treat "commit + push + PR" as the end of close-out and silently skip project-specific obligations declared in `project-context.md`. Step 8 had no explicit re-read instruction. The fix keeps the engine contamination-free while making the project-context re-read mandatory.

## [1.5.0] - 2026-04-13

### Added (1.5.0)

- **Step 0.0: Workflow sync check** — Standard Workflow Step 0 now runs `.claude/hooks/workflow-sync.sh check` before session setup. If an update is available, syncs automatically and informs the user. Non-blocking — if the script is missing or fails, logs a warning and continues.
- **Sync script self-update** — `sync.sh` now copies itself to `.claude/hooks/workflow-sync.sh` during both sync and init operations. Consumers always get the latest sync script version.
- **Sync script deployed to consumer projects** — `.claude/hooks/workflow-sync.sh` installed in both Deacon and FIN001.

## [1.4.0] - 2026-04-13

### Added (1.4.0)

- **github-updater Step 1c.6** — Now adds new follow-up issues to the GitHub Project board AND sets project field values (Priority, Compliance Domain, Effort, etc.) via GraphQL mutations. Field IDs, option IDs, and assignment guidelines are read from the consumer's `project-context.md` "Project Fields" subsection. Entire step is skipped when the repo does not use GitHub Projects, or when the Project Fields subsection is absent (board-add only fallback).

### Why (1.4.0)

- Previously, follow-up issues were added to the project board but project fields (Priority, Effort, etc.) were left unset, requiring manual triage. Centralizing the field IDs in `project-context.md` keeps the agent contamination-free while ensuring consistent metadata on every new issue.

## [1.3.0] - 2026-04-12

### Added (1.3.0)

- **TDD mandate in Standard Workflow** — Step 3 now requires Red-Green-Refactor cycle for all implementation. Tests are specifications that constrain AI-generated code.
- **TDD in issue-worker agent** — Step 4 (Implement) now opens with TDD cycle instructions and invokes the `test-driven-development` superpowers skill for the full playbook. Includes fallback R-G-R instructions if the skill is unavailable.
- **"Listen to Your Tests" principle** in issue-worker — test friction signals design problems; refactor production code rather than writing complex test scaffolding.
- **TDD verification in reviewer agent** — Step 4e (Test Coverage) expanded to verify test existence alongside implementation, test-to-requirement mapping, and edge case coverage. Flags implementation without corresponding tests as a WARNING.

### Why (1.3.0)

TDD policy review (2026-04-12) found that all infrastructure for TDD exists (DI, type-safe mocks, coverage thresholds, TDD superpowers skill) but no process enforcement. The gap was process, not technology. These changes add the mandate (engine) and the playbook (skill) while keeping the DI architecture that makes TDD practical.

## [1.2.0] - 2026-04-12

### Added (1.2.0)

- **Step 4c: ADR Coverage Check** — new orchestrator-inline step between reviewer approval (4b) and close-out (4d). Verifies all design decisions from Step 2b have corresponding ADRs, all EXPLAIN constraints are documented, and researcher findings that set precedents are formalized. No agent spawn — orchestrator does it directly. Presents gaps to user via `AskUserQuestion`.
- **ADR Coverage row** in the close-out summary table (Step 4d) — reports design decisions documented, EXPLAIN constraints satisfied, and researcher findings reviewed.

### Changed (1.2.0)

- Close-out summary moved from Step 4c to **Step 4d** to accommodate the new ADR check step.
- Close-out table template in compliance-agent-patterns.md updated to match (Step 4d, ADR Coverage row added).
- Fixed MD060 table separator warnings in workflow-summary.md.

### Fixed

- **IRD GitHub comment must be FULL content** — Step 2b now explicitly requires posting the complete IRD in the exact table format as the GitHub comment. Previous wording ("Add a comment with the approved IRD content") was vague and led to partial/summarized posts. The comment must NOT reference the temp file path `brain/sessions/ird-{issue}.md` since it's deleted at Step 8.

## [1.1.0] - 2026-04-12

### Changed (1.1.0)

- **Inlined IRD table templates into standard-workflow.md** — Steps 2b, 4b, and 4c now contain the exact table format directly instead of referencing compliance-agent-patterns.md via a two-hop indirection. This eliminates the failure mode where the orchestrator skips reading the second file after context compression and freeforms the presentation.
- **Strengthened workflow-summary.md** — replaced "All presentation tables use formats from compliance-agent-patterns.md" (an indirect pointer that doesn't survive compaction) with three explicit bullets describing each table's structure and noting that templates are inlined in standard-workflow.md. Also clarified that tables go in markdown text first, with AskUserQuestion used only for the short approval question.

### Why (1.1.0)

Issue #606 revealed inconsistent IRD presentation — the orchestrator produced freeform output instead of the mandatory table format. Root cause: the table templates lived only in compliance-agent-patterns.md, and standard-workflow.md pointed to them with a "read this other file" reference. After context compression, the orchestrator didn't follow the two-hop path.

## [1.0.0] - 2026-04-11

### Added (1.0.0)

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
