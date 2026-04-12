# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## What This Repo Is

This is **shared infrastructure** — not an application. It contains agent definitions, workflow protocols, and scaffolding templates that get synced to consuming projects (Deaconify, FIN001, future projects) via `sync.sh`. Changes here propagate to every consumer on their next sync.

**There is no application code, no test suite, no build step.** Validation is done by syncing to a consumer project and verifying behavior.

## Repository Structure

```text
workflow-engine/
├── agents/           # 9 agent definitions (synced → .claude/agents/)
├── workflow/         # Workflow reference docs (synced → brain/reference/)
├── scaffolding/      # New project bootstrap (copied on init only, never overwritten)
├── feedback/         # Cross-project workflow lessons (scope: universal)
├── sync.sh           # Consumer sync script
├── VERSION           # Semver — bump on every change
└── CHANGELOG.md      # Human-readable change history
```

## The Contamination Rule

**CRITICAL — This is the #1 invariant of this repo.**

Agents and workflow docs must contain **zero project-specific content**. No language names, no framework names, no hardcoded commands. All project-specific context lives in each consumer's `brain/reference/project-context.md`, which agents read at runtime.

**Forbidden in `agents/` and `workflow/` files:**

- Language-specific commands: `npm`, `pip`, `pytest`, `ruff`, `vitest`, `cargo`, `dotnet`, `maven`
- Framework/library names: `Fluent UI`, `Cosmos DB`, `Zod`, `React`, `Django`, `FastAPI`
- Project names: `Deaconify`, `Deacon`, `FIN001`, any client or product name
- Auth patterns: `BFF`, `MSAL`, `OAuth` (these belong in project-context.md)
- Hardcoded paths: `api/services/`, `src/functions/` (use generic descriptions)

**Instead, write:** "Read the project's lint command from project-context.md" — not "Run `npm run lint`".

**Allowed exceptions:**

- `brain/` paths (universal across all consumers)
- `.claude/agents/` paths (universal)
- `brain_search`, `brain_lookup`, etc. (brain-mcp is universal tooling)
- `npx markdownlint-cli2` or `pymarkdown scan` when referenced generically as "the project's markdown linter"
- `gh` CLI commands (GitHub CLI is universal)
- MCP tool names (`microsoft_docs_search`, `resolve-library-id`, etc.)

**Scaffolding files (`scaffolding/`) are exempt** — they contain placeholder examples showing what to fill in.

### Verifying Contamination

Run the contamination check before committing:

```bash
grep -riEn "npm run|npm test|npx prettier|pip install|pytest|ruff|vitest|cargo test|dotnet|deaconify|deacon|autotask|fluent.ui|cosmos.db|@azure/cosmos|teams.ai|adaptive.card|BFF pattern|MSAL|Zod schema" agents/ workflow/
```

This should return zero matches. The same check runs automatically inside `sync.sh`.

## How Sync Works

Consumers run `sync.sh` from their project root. It downloads the latest tarball from this GitHub repo via `gh api`, extracts it, and copies files:

| Source | Destination | Behavior |
| ------ | ----------- | -------- |
| `agents/*.md` | `.claude/agents/` | **Overwritten** on every sync |
| `workflow/*.md` (except trigger-matrix) | `brain/reference/` | **Overwritten** on every sync |
| `workflow/compliance-trigger-matrix.md` | `brain/reference/` | **Copied on init only**, never overwritten |
| `scaffolding/` | Various | **Copied on init only** |
| `feedback/` | Not synced | Reference only — lessons incorporated into agents/workflow |

**Consequence:** Any change to `agents/` or `workflow/` will replace the corresponding file in every consumer project on next sync. If a consumer has local edits to a synced file, those edits will be lost. The correct workflow is: upstream the change here first, then sync.

## Versioning

Every change that affects synced files (`agents/`, `workflow/`) MUST:

1. Bump `VERSION` (semver: major for breaking changes, minor for new features, patch for fixes)
2. Add an entry to `CHANGELOG.md` with the date and description
3. Commit with a descriptive message

Consumer projects track their synced version in `.workflow-version`. The sync script compares this against `VERSION` to determine if an update is needed.

## Making Changes

### Editing an agent (`agents/*.md`)

1. Make the change
2. Run the contamination check (see above)
3. Verify the agent's Step 0 still references `brain/reference/project-context.md`
4. Bump VERSION, update CHANGELOG
5. Commit and push
6. Test: sync to a consumer project and verify the agent works correctly

### Editing a workflow doc (`workflow/*.md`)

1. Make the change
2. Run the contamination check
3. If table formats changed in `compliance-agent-patterns.md`, verify `workflow-summary.md` still references them correctly
4. Bump VERSION, update CHANGELOG
5. Commit and push

### Adding a new agent

1. Create `agents/new-agent.md` with Step 0 referencing project-context.md
2. Add to the agent table in `workflow/workflow-summary.md`
3. Add to the `SYNCED_AGENTS` array in `sync.sh`
4. Run contamination check
5. Bump VERSION, update CHANGELOG

### Adding a new workflow doc

1. Create `workflow/new-doc.md`
2. Add to `SYNCED_WORKFLOW_DOCS` in `sync.sh` (unless it's scaffolding-only)
3. Run contamination check
4. Bump VERSION, update CHANGELOG

### Adding feedback entries

Feedback files in `feedback/` are reference material — they document workflow lessons learned. They are NOT synced to consumers automatically. Instead, lessons are incorporated into agent definitions or workflow docs over time.

**Scope tags:** Each feedback entry should have a `scope` in its content:

- `scope: universal` — applies to any project (agent persistence, batch size, IRD rules)
- `scope: typescript` / `scope: python` / etc. — language-specific, stays in originating project's memory

Only `scope: universal` feedback belongs in this repo.

## What NOT To Do

- **Never add project-specific content** to `agents/` or `workflow/` files
- **Never reference a specific consumer** (Deaconify, FIN001) outside of README.md
- **Never add application code, tests, or build steps** — this is infrastructure
- **Never modify `scaffolding/` files to match a specific consumer** — keep them generic templates
- **Never forget to bump VERSION** — consumers rely on version comparison for sync decisions
- **Never add a synced file to sync.sh without a contamination check**

## Testing Changes

There is no automated test suite. To verify changes:

1. Sync to a consumer project: `cd /path/to/consumer && /path/to/workflow-engine/sync.sh --force`
2. Run the consumer's validation suite (lint, typecheck, tests, build)
3. Optionally: trigger a Standard Workflow on a test issue to verify agent behavior

## Current Consumers

| Project | Repo | Tech Stack | Version |
| ------- | ---- | ---------- | ------- |
| Deaconify | `deaconify/deacon` | TypeScript, Azure Functions | Check `.workflow-version` |
| FIN001 | `Function-One-Clients/2026-FIN001-BitbucketBackupSolution` | Python, Azure Functions | Check `.workflow-version` |
