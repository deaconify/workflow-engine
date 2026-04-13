---
title: "Project Context"
doc_type: reference
tags: [architecture, deployment]
---

<!-- This file is the single source of truth for all project-specific configuration.
     Agents read this at runtime to adapt to your project. Fill in every section. -->

## Project Identity

- **Name**: [Your Project Name]
- **Description**: [One-line description]
- **Tech Stack**: [Language], [Framework], [Database]
- **Runtime**: [Node.js 22 / Python 3.12 / etc.]

## GitHub Repository

- **Owner**: [github-org]
- **Repo**: [repo-name]
- **Full**: `[github-org]/[repo-name]`

Always use `owner: "[github-org]", repo: "[repo-name]"` with GitHub MCP tools.

## Validation Commands

<!-- These exact commands are run by the @validator agent -->

### Backend

```bash
[lint-command]        # e.g., npm run lint, ruff check .
[typecheck-command]   # e.g., npm run typecheck, mypy .
[test-command]        # e.g., npm test, pytest
[build-command]       # e.g., npm run build, python -m build
```

### Frontend (if applicable)

```bash
cd [frontend-dir]
[frontend-lint]       # e.g., npm run lint
[frontend-build]      # e.g., npm run build
[frontend-test]       # e.g., npm test
```

## Architecture

- **Entry Point**: `[path/to/main/entry]`
- **Service Layer**: `[path/to/services/]`
- **Functions/Routes**: `[path/to/functions/]`
- **Tests**: `[path/to/tests/]` (pattern: `**/__tests__/**/*.test.ts`)
- **Config**: `[path/to/config/]`
- **Frontend** (if applicable): `[path/to/frontend/]`

## Critical Patterns

<!-- These are enforced during implementation and review -->

### Naming

- [Any identifier naming restrictions, e.g., "Never use 'ProductName' in code identifiers"]

### Authentication

- [Auth pattern description, e.g., "BFF pattern with HttpOnly cookies"]

### Data Isolation

- [Data isolation pattern, e.g., "Tenant ID partition key on all queries"]

### Validation

- [Validation approach, e.g., "Zod schemas for all external data"]

### Styling (if frontend)

- [Styling rules, e.g., "Fluent UI v9 makeStyles/tokens only, no external CSS"]

### Structured Logging

- [Logging rules, e.g., "Logger interface, never console.* in production"]

### Function/Route Registration

- [Registration rules, e.g., "New functions MUST be imported in index.ts"]

## Issue Management

### Milestones

<!-- List your project's milestones -->

| Milestone | Title | Status |
|-----------|-------|--------|
| 1 | [First milestone] | Open/Closed |

### Labels

- **Type labels**: `bug`, `feature`, `chore`, `documentation`
- **Area labels**: [list your area labels, e.g., `api`, `admin`, `auth`]
- **Priority labels**: `p0` (critical), `p1` (high)

### Issue Types (if using GitHub issue types)

<!-- Include type IDs if your project uses them -->

| Label | GitHub Issue Type | Type ID |
|-------|-------------------|---------|
| `bug` | Bug | `[type-id]` |
| `feature` | Feature | `[type-id]` |
| `chore` | Task | `[type-id]` |

### Project Board (if using GitHub Projects)

- **Project ID**: `[project-id]`
- **Status Field ID**: `[field-id]`
- **"In Progress" Option ID**: `[option-id]`

## Key Packages

<!-- List key dependencies so the drift-detector can verify they exist -->

- `[package-name]` — [purpose]
- `[package-name]` — [purpose]

## Pattern Compliance Checklist

<!-- Used by the @reviewer to verify implementations -->

| Pattern | Description | Verification |
|---------|-------------|--------------|
| [Auth pattern] | [Description] | [How to verify] |
| [Data isolation] | [Description] | [How to verify] |
| [Validation] | [Description] | [How to verify] |

## Brain MCP

<!-- If using brain-mcp for this project -->

- **Index**: SQLite-vec with local embeddings
- **Markdown Linter**: `npx markdownlint-cli2 "brain/**/*.md"`

## Tag Vocabulary

<!-- Controlled vocabulary for brain doc tags -->

| Category | Tags |
|----------|------|
| [Category] | `tag1`, `tag2`, `tag3` |
