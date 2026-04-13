---
title: "Workflow Summary"
doc_type: reference
tags: [ci-cd, testing, security]
---

Concise reference for the Standard Issue Workflow. Agents read the full protocol from `brain/reference/standard-workflow.md` during execution.

## Trigger Phrases

- "Follow Standard Workflow - Issue #N"
- "Standard Workflow - #N"
- "Work on Issue #N"

## Key Invariants

- **Agents**: All invoked via Task tool. Always verify persistence after completion (`git status --short | wc -l`). Re-spawn if empty.
- **User approvals**: Present IRD (Step 2b), reviewer results (Step 4b), and close-out (Step 4c) as markdown tables FIRST, then use a short `AskUserQuestion` for the approval question only. Never put tables inside AskUserQuestion. Fix gaps in-place, never as follow-ups.
- **IRD persistence**: After Step 2b approval, write IRD to `brain/sessions/ird-{issue}.md` and post the FULL IRD (complete table, not a summary) as a GitHub comment. The GitHub comment is the permanent record — never reference the temp file path in it. Steps 3/4 agents read from disk. Deleted at Step 8.
- **Research first**: `@researcher` always runs in Step 1. All questions must present MCP-backed recommendations.
- **IRD covers all AC**: Every acceptance criterion checkbox must have a corresponding IRD constraint.
- **Zero warnings target**: New warnings from implementation must be fixed. Pre-existing warnings reported at close-out.
- **Single commit**: One commit per issue at Step 8. Incremental commits for large scope are squashed.
- **Large scope (20+ files)**: Commit-verify-continue cycle — batch 15-20 files, verify, typecheck, commit.
- **IRD table format (Step 2b)**: Header (Issue, Categories) → Constraints table (# / Tier / Category / Constraint / Target) → Design Decisions table → AC Coverage table → Out of Scope → Already Tracked. Template is inlined in `standard-workflow.md` Step 2b.
- **Reviewer table format (Step 4b)**: Verdict → Requirements Compliance table (# / Tier / Constraint / Status / Evidence) → AC Status table → Issues Found → New Scope Items. Template is inlined in `standard-workflow.md` Step 4b.
- **ADR coverage check (Step 4c)**: Orchestrator verifies all design decisions have ADRs, all EXPLAIN constraints are documented, and researcher findings that set precedents are formalized. Done inline, no agent spawn.
- **Close-out table format (Step 4d)**: Single summary table (Issue / Verdict / IRD Compliance / ADR Coverage / Warnings / Follow-ups / Files / Validation). Template is inlined in `standard-workflow.md` Step 4d.
- **CLAUDE.md is read-only**. Update `brain/reference/project-context.md` for project changes. Workflow changes go through the workflow-engine repo.
- **Step 8 close-out re-read**: Before close-out, the orchestrator MUST re-read `brain/reference/project-context.md` and execute every project-specific close-out obligation declared there (time tracking, external status transitions, merge policy, notifications, session-state reconciliation). Categories the project does not use are simply absent. Context compression late in long sessions otherwise causes these to be silently skipped.

## Shell Hygiene

Applies to the orchestrator AND every spawned agent. These rules eliminate noise and avoid common foot-guns:

- **Trust your cwd.** The Bash tool's working directory persists between calls and is already set to the project root. **Never** prefix commands with `cd /path/to/project` to "be safe" — use relative paths.
- **Only `cd` when genuinely switching repos** (e.g., stepping into a sibling project) or when the user explicitly requests it.
- **Use dedicated tools instead of shelling out:** `Read` not `cat`/`head`/`tail`, `Grep` not `grep`/`rg`, `Glob` not `find`/`ls`, `Edit`/`Write` not `sed`/`echo >`/`cat <<EOF`.
- **Don't run orientation commands** like `pwd` or `ls` to confirm where you are — trust the environment.
- **Forward slashes in paths work on Windows**; quote paths with spaces rather than escaping or `cd`-ing around them.

## Workflow Steps

| Step | Phase | Agent | Purpose |
| --- | --- | --- | --- |
| 0 | Setup | Orchestrator | Workflow sync check, session start, populate current-state.md |
| 1 | Planning | `@issue-worker` + `@researcher` | Read issue + research (parallel) |
| 1b | Planning | Orchestrator | Triage compliance categories |
| 2 | Planning | `@requirements-planner` | Produce IRD (conditional) |
| 2b | Planning | Orchestrator | User reviews/approves IRD |
| 3 | Implementation | `@issue-worker` | Implement with IRD constraints |
| 4 | Implementation | `@reviewer` | Code review + IRD verification |
| 4b | Implementation | Orchestrator | User reviews results |
| 4c | Implementation | Orchestrator | ADR coverage check (inline) |
| 4d | Implementation | Orchestrator | Close-out summary + approval |
| 5 | Close-out | `@github-updater` | Update/close GitHub issues |
| 6 | Close-out | `@documenter` | Update capability docs |
| 7 | Close-out | `@drift-detector` | Update all brain docs |
| 8 | Close-out | Orchestrator | Re-read project-context.md, single commit, execute project-specific close-out obligations |

## Agent Reference

| Agent | File | Model | Purpose |
| --- | --- | --- | --- |
| `issue-worker` | `.claude/agents/issue-worker.md` | opus | Read issue + implement |
| `researcher` | `.claude/agents/researcher.md` | sonnet | MCP documentation research |
| `requirements-planner` | `.claude/agents/requirements-planner.md` | opus | Security/compliance analysis → IRD |
| `reviewer` | `.claude/agents/reviewer.md` | sonnet | Code review + IRD verification |
| `validator` | `.claude/agents/validator.md` | haiku | Lint, typecheck, test, build |
| `github-updater` | `.claude/agents/github-updater.md` | sonnet | GitHub issue lifecycle |
| `documenter` | `.claude/agents/obsidian-documenter.md` | sonnet | Capability doc updates |
| `drift-detector` | `.claude/agents/drift-detector.md` | sonnet | Brain vault maintenance |
| `troubleshooter` | `.claude/agents/troubleshooter.md` | sonnet | On-demand debugging |

## Project Context

All project-specific configuration lives in `brain/reference/project-context.md`:

- Project identity, tech stack, architecture
- Validation commands (lint, typecheck, test, build)
- GitHub repo, labels, naming conventions
- Critical patterns and conventions
- Key file locations
