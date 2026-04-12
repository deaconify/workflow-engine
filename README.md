# Workflow Engine

Shared agent/workflow infrastructure for Claude Code projects. Provides 9 standardized agents, workflow protocols, and an Obsidian brain vault structure that any project can sync from.

## Overview

- **9 agents** — generalized, zero project-specific content
- **Standard Workflow** — shift-left security/compliance analysis, structured issue lifecycle
- **Brain vault** — Obsidian-based documentation with brain-mcp semantic search
- **Sync script** — pulls from GitHub, copies files, runs contamination checks

## Quick Start

### New Project

```bash
# Download and run init
curl -sL https://raw.githubusercontent.com/deaconify/workflow-engine/main/sync.sh -o sync.sh
chmod +x sync.sh
./sync.sh init
```

Then edit `brain/reference/project-context.md` with your project details.

### Existing Project

```bash
# Copy sync.sh to your project
cp /path/to/workflow-engine/sync.sh .claude/hooks/workflow-sync.sh
chmod +x .claude/hooks/workflow-sync.sh

# Sync
.claude/hooks/workflow-sync.sh
```

## Structure

```text
workflow-engine/
├── agents/           # 9 generalized agent definitions
├── workflow/         # Shared workflow reference docs
├── scaffolding/      # New project bootstrap templates
├── feedback/         # Cross-project workflow lessons
├── sync.sh           # Sync script (copy + contamination check)
├── VERSION           # Semver
└── CHANGELOG.md
```

## How It Works

1. **Agents contain zero project-specific content.** All context comes from `brain/reference/project-context.md`, which each project maintains locally.

2. **CLAUDE.md uses `@` imports** — 3 brain doc imports that get expanded at session start and survive context compression:
   - `@brain/reference/project-context.md` — project identity, tech stack, commands
   - `@brain/sessions/current-state.md` — session state
   - `@brain/reference/workflow-summary.md` — key workflow invariants

3. **Sync = pure file copy.** No templates, no variables, no rendering. The sync script copies agents and workflow docs, then runs a contamination check.

4. **Auto-sync at Standard Workflow start.** Step 0 checks for updates and syncs automatically.

## Agents

| Agent | Purpose |
| ----- | ------- |
| `issue-worker` | Read issue + implement with IRD constraints |
| `researcher` | MCP-powered documentation research |
| `requirements-planner` | Security/compliance analysis → IRD |
| `reviewer` | Code review + IRD verification |
| `validator` | Lint, typecheck, test, build |
| `github-updater` | GitHub issue lifecycle |
| `obsidian-documenter` | Capability doc updates |
| `drift-detector` | Brain vault maintenance |
| `troubleshooter` | On-demand debugging |

## Synced vs Local Files

| File | Synced? | Notes |
| ---- | ------- | ----- |
| `.claude/agents/*.md` | Yes | Overwritten on sync |
| `brain/reference/standard-workflow.md` | Yes | Full protocol |
| `brain/reference/workflow-summary.md` | Yes | Concise invariants |
| `brain/reference/planning-protocol.md` | Yes | Issue templates |
| `brain/reference/github-standards.md` | Yes | Naming conventions |
| `brain/reference/compliance-agent-patterns.md` | Yes | IRD format, table templates |
| `brain/reference/compliance-trigger-matrix.md` | No | Scaffolded on init, project-specific |
| `brain/reference/project-context.md` | No | Project-specific |
| `brain/capabilities/` | No | Project-specific |
| `brain/decisions/` | No | Project-specific |
| `CLAUDE.md` | No | Local, managed by sync init |

## Version

Current: see [VERSION](VERSION)
