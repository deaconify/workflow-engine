---
title: "Workflow Summary"
doc_type: reference
tags: [ci-cd, testing, security]
---

# Workflow Summary

Concise reference for the Standard Issue Workflow. Agents read the full protocol from `brain/reference/standard-workflow.md` during execution.

## Trigger Phrases

- "Follow Standard Workflow - Issue #N"
- "Standard Workflow - #N"
- "Work on Issue #N"

## Key Invariants

- **Agents**: All invoked via Task tool. Always verify persistence after completion (`git status --short | wc -l`). Re-spawn if empty.
- **User approvals**: Present IRD (Step 2b), reviewer results (Step 4b), and close-out (Step 4c) using mandatory table formats with `AskUserQuestion`. Fix gaps in-place, never as follow-ups.
- **IRD persistence**: After Step 2b approval, write IRD to `brain/sessions/ird-{issue}.md` and post to GitHub. Steps 3/4 agents read from disk. Deleted at Step 8.
- **Research first**: `@researcher` always runs in Step 1. All questions must present MCP-backed recommendations.
- **IRD covers all AC**: Every acceptance criterion checkbox must have a corresponding IRD constraint.
- **Zero warnings target**: New warnings from implementation must be fixed. Pre-existing warnings reported at close-out.
- **Single commit**: One commit per issue at Step 8. Incremental commits for large scope are squashed.
- **Large scope (20+ files)**: Commit-verify-continue cycle — batch 15-20 files, verify, typecheck, commit.
- **All presentation tables** use formats from `brain/reference/compliance-agent-patterns.md`.
- **CLAUDE.md is read-only**. Update `brain/reference/project-context.md` for project changes. Workflow changes go through the workflow-engine repo.

## Workflow Steps

| Step | Phase | Agent | Purpose |
|------|-------|-------|---------|
| 0 | Setup | Orchestrator | Session start, populate current-state.md |
| 1 | Planning | `@issue-worker` + `@researcher` | Read issue + research (parallel) |
| 1b | Planning | Orchestrator | Triage compliance categories |
| 2 | Planning | `@requirements-planner` | Produce IRD (conditional) |
| 2b | Planning | Orchestrator | User reviews/approves IRD |
| 3 | Implementation | `@issue-worker` | Implement with IRD constraints |
| 4 | Implementation | `@reviewer` | Code review + IRD verification |
| 4b | Implementation | Orchestrator | User reviews results |
| 4c | Implementation | Orchestrator | Close-out summary + approval |
| 5 | Close-out | `@github-updater` | Update/close GitHub issues |
| 6 | Close-out | `@documenter` | Update capability docs |
| 7 | Close-out | `@drift-detector` | Update all brain docs |
| 8 | Close-out | Orchestrator | Session end, single commit |

## Agent Reference

| Agent | File | Model | Purpose |
|-------|------|-------|---------|
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
