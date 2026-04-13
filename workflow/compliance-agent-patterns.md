---
title: "Requirements Planning Patterns"
doc_type: reference
tags: [security, data-protection, audit]
---

> **Canonical source for the shift-left security and compliance workflow.** This file documents the Implementation Requirements Document (IRD) format, tier definitions, follow-up consolidation rules, and workflow patterns used by the `@requirements-planner` and `@reviewer` agents. Triggered by categories from the [[compliance-trigger-matrix]] and executed within the [[standard-workflow]].

## Workflow Overview

The Standard Workflow uses a shift-left model: security and compliance analysis happens BEFORE implementation, not after.

```text
Step 1:  Issue Worker reads issue + Researcher gathers docs
Step 1b: Orchestrator applies trigger matrix, selects categories
Step 2:  @requirements-planner produces IRD
Step 2b: User reviews IRD, resolves design decisions
Step 3:  @issue-worker implements with IRD constraints
Step 4:  @reviewer verifies code quality + IRD compliance
Step 4b: User reviews results
Step 5+: Close-out (github-updater, documenter, drift-detector, session end)
```

## Implementation Requirements Document (IRD)

The IRD is the key artifact that flows through the workflow:

- **Produced by**: `@requirements-planner` (Step 2)
- **Reviewed by**: User (Step 2b)
- **Consumed by**: `@issue-worker` (Step 3) as implementation constraints
- **Verified by**: `@reviewer` (Step 4) in the Requirements Compliance section

### Tier Definitions

| Tier | Meaning | Issue-Worker Action | Reviewer Action |
|------|---------|-------------------|----------------|
| MUST | Direct violation or vulnerability if missing | Implement or blocked | CRITICAL if missing (REQUEST CHANGES) |
| SHOULD | Defense-in-depth, audit recommendation | Implement | WARNING if missing (fix in-place) |
| CONSIDER | Best practice, nice to have | Optional | MINOR note if missing |
| EXPLAIN | Documentation/rationale needed | Add code comment or ADR | WARNING if missing |

### IRD Format

```markdown
# Implementation Requirements — Issue #NNN

## Summary
[Brief description]

## Applicable Categories
[Categories with trigger reasons]

## Implementation Constraints

### MUST (blocking)
1. **[Category.Item]** [Specific constraint]

### SHOULD (important)
2. **[Category.Item]** [Specific constraint]

### CONSIDER (optional)
3. **[Category.Item]** [Specific suggestion]

### EXPLAIN (document rationale)
4. **[Category.Item]** [What to document]

## Acceptance Criteria Coverage
[Map every issue checkbox to a constraint — functional AC get MUST-tier constraints]

## Design Decisions Required
[Genuine trade-offs needing user input]

## Out of Scope
[Items evaluated and found NOT applicable]

## Already Tracked
[Items covered by existing open issues]
```

## Orchestrator Presentation Formats

The orchestrator transforms the planner's IRD output into standardized table formats for user review. These formats are mandatory.

### Standard IRD Presentation (Step 2b)

Presented after design decisions are resolved:

> **Issue:** #NNN — [Title]
>
> **Categories Evaluated:** [list with trigger reasons]
>
> **Constraints:**
>
> | # | Tier | Category | Constraint | Target |
> |---|------|----------|-----------|--------|
> | 1 | MUST | [X.N] | [Specific constraint description] | [file or area] |
> | 2 | SHOULD | [X.N] | [Specific constraint description] | [file or area] |
> | 3 | CONSIDER | [X.N] | [Specific constraint description] | [file or area] |
> | 4 | EXPLAIN | [X.N] | [What needs documenting] | [ADR or comment] |
>
> **Design Decisions Resolved:**
>
> | Decision | Resolution | Rationale |
> |----------|-----------|-----------|
> | [Topic] | [Chosen option] | [Why] |
>
> *(If no decisions: "None")*
>
> **Acceptance Criteria Coverage:**
>
> | AC | Covered By |
> |----|-----------|
> | [Acceptance criterion text] | Constraint #N / Functional constraint / N/A |
>
> *(Every checkbox from the issue must appear here)*
>
> **Out of Scope:** [items or "None"]
>
> **Already Tracked:** [issue references or "None"]

### Standard Reviewer Results Presentation (Step 4b)

> **Reviewer Results — Issue #NNN**
>
> **Verdict:** [APPROVE / APPROVE with warnings / REQUEST CHANGES]
>
> **Requirements Compliance:**
>
> | # | Tier | Constraint | Status | Evidence |
> |---|------|-----------|--------|----------|
> | 1 | MUST | [Constraint description] | PASS / FAIL | [file:line or evidence] |
> | 2 | SHOULD | [Constraint description] | PASS / WARNING | [file:line or evidence] |
>
> **Acceptance Criteria Status:**
>
> | AC | Status | Evidence |
> |----|--------|----------|
> | [Criterion from issue] | DONE / NOT DONE | [file:line or explanation] |
>
> **Issues Found:** [CRITICAL / WARNING / OBSERVATION items, or "None"]
>
> **New Scope Items:** [items outside IRD scope, or "None"]

### Standard Close-Out Summary (Step 4d)

> **Close-Out Review — Issue #NNN**
>
> | Item | Details |
> | --- | --- |
> | **Issue** | #NNN — [Title] |
> | **Reviewer Verdict** | [APPROVE / APPROVE with warnings] |
> | **IRD Compliance** | [X/Y MUST passed, Z/W SHOULD passed, or "No IRD"] |
> | **ADR Coverage** | [X design decisions documented, Y EXPLAIN constraints satisfied, Z researcher findings reviewed — or "No IRD"] |
> | **Warnings Resolved** | [count resolved, count acknowledged, or "None"] |
> | **Follow-up Issues** | [approved items, or "None"] |
> | **Files Changed** | [count] ([key files]) |
> | **Validation** | [lint, typecheck, tests, build — all passing] |

## Follow-Up Consolidation Rules

The shift-left model reduces follow-ups:

| Situation | Action |
|-----------|--------|
| MUST/SHOULD/CONSIDER/EXPLAIN gap | **Fix in-place** |
| Code quality issue from reviewer | **Fix in-place** |
| New item not in IRD | **Fix in-place if small** |
| Genuinely new scope (different domain) | **Follow-up** — user approves at Step 4b |

**Maximum 2 follow-up issues per workflow run** unless user explicitly approves more.

## Existing Issue Dedup

Both `@requirements-planner` and `@reviewer` check for existing open issues:

1. Run `gh issue list --repo OWNER/REPO --state open --limit 200 --json number,title` (read OWNER/REPO from project-context.md)
2. If a concern is already tracked, note "Already tracked in #N" instead of creating a new constraint

## ADR Pre-Scan (Mandatory)

Before researching or flagging design decisions, scan for existing ADRs:

### Three-Tier ADR Classification

| Classification | Definition | Action |
|---------------|-----------|--------|
| **Fully Covered** | ADR has all four complete sections | **Skip research.** Reference the ADR. |
| **Partially Covered** | ADR exists but incomplete | **Targeted research** on the gap only. |
| **Not Covered** | No ADR covers this topic | **Full research.** Present as design decision. |

### IRD Integration

Annotate each constraint with its ADR classification:

```text
### MUST (blocking)
1. **[Category.Item]** [Constraint description].
   **ADR: Fully covered by [[NNNN-adr-slug]].** No research needed.

2. **[Category.Item]** [Constraint description].
   **ADR: Partially covered by [[NNNN-other-slug]].** [Gap researched.]

### Design Decisions Required
1. **[Topic]** — Not covered by existing ADRs.
   Options: [A] ..., [B] ...
   Recommendation: [with MCP-backed reasoning]
```

## ADR Quality Standard

An ADR is **complete** when all four sections have substantive content:

| Section | Minimum Quality |
|---------|----------------|
| **Context** | States the problem, why a decision was needed, and relevant constraints |
| **Options Considered** | Lists at least 2 options with trade-offs for each |
| **Decision** | States what was decided AND why this option was chosen |
| **Consequences** | Describes concrete impacts — what becomes easier/harder, follow-up work |

### ADR Quality Enforcement

- The `@issue-worker` creates ADRs during implementation
- The `@reviewer` verifies ADR completeness during code review
- The `@drift-detector` audits ADR quality during vault maintenance

## Design Decisions

When the `@requirements-planner` identifies a trade-off **Not Covered** by existing ADRs:

1. Include it in the IRD's "Design Decisions Required" section
2. User resolves during Step 2b
3. Create ADR following the ADR Quality Standard
4. The resolved decision becomes a constraint for the issue-worker

**Flagged as design decisions:** competing concerns, reasonable disagreement, precedent-setting, no existing ADR.

**NOT flagged:** factual bugs, clear best practices, items fully/partially covered by existing ADRs.

## Shared MCP Tools

Both `@requirements-planner` and `@reviewer` use:

- **GitHub MCP**: `issue_read`
- **Microsoft Learn MCP**: `microsoft_docs_search`, `microsoft_docs_fetch`, `microsoft_code_sample_search`
- **Context7 MCP**: `resolve-library-id` (call first), then `query-docs`

All MCP tools are deferred — use `ToolSearch` to load before first use.

## Turn Budget Guidelines

- **Requirements planner**: ~20 turns. Reserve 3-4 for IRD output.
- **Reviewer**: ~50 turns. Reserve 3-4 for structured review output.
- Both agents should parallelize aggressively.
- Priority: output > file analysis > reference reading > MCP research
