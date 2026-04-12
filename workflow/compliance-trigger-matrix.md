---
title: "Requirements Planning Trigger Matrix"
doc_type: reference
tags: [security, data-protection, audit, architecture]
---

# Requirements Planning Trigger Matrix

> **SCAFFOLDING FILE — Copied on init, never overwritten by sync.**
> This file is project-specific. Each project customizes it with their own file patterns and compliance categories. The template below provides a starting structure.

## How This Works

1. The orchestrator identifies affected files from the issue context
2. Each file is matched against the trigger matrix below
3. The union of all matched categories is passed to the `@requirements-planner`
4. The planner may refine scope based on actual change context (add or remove categories)

## Trigger Matrix

Customize this table for your project. Map file path patterns to the security and compliance categories defined in the `@requirements-planner` agent's checklists.

| Changed Files Pattern | Security Categories | Compliance Categories |
|---|---|---|
| Auth middleware or auth functions | A, B, H | CD, CE, CI |
| Session management files | A, H | CD, CE, CI |
| Billing/payment functions | A, B, F | CA, CB, CD, CE, CH, CI |
| Payment provider integration files | F | CH |
| Database repositories, data access | C, D | CA, CB, CC |
| New/modified data model types | C | CA, CB, CC |
| HTTP endpoint handlers | D, F | CG |
| External API clients | C, D | CA, CF |
| Webhook handlers | G | CA, CD, CF |
| Environment config | E | CG |
| Logging, error handlers | E | CD, CE |
| Queue workers, background jobs | — | CA, CB, CD, CG |
| Infrastructure files | — | CG |
| Frontend security components | I | CH |
| Frontend non-security components | I | — |
| UI-only (styling, layout) | — | — |
| Tests only | — | — |
| Documentation only | — | — |

## Category Reference

Security categories (A-J) and Compliance categories (CA-CI) are defined in the `@requirements-planner` agent's checklists, which live in `brain/reference/compliance-trigger-matrix.md` in each project.

## Decision Flow

```text
Affected files from issue context (Step 1)
  -> Categorize each file against trigger matrix
  -> Collect union of all matched categories
  -> If NO categories match -> skip Step 2
  -> If categories match -> pass to @requirements-planner with issue context
  -> Planner produces IRD -> user reviews (Step 2b)
```
