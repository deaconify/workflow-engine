---
title: "Planning Protocol"
doc_type: reference
related_capabilities: []
tags: [roadmap, product-vision, architecture]
---

> Referenced from CLAUDE.md. Full planning workflow, issue template, and creation process. Issues follow [[github-standards]] naming conventions.

## Planning Workflow

When the user enters plan mode for feature work (or says "Plan Feature: [description]"), follow this protocol:

### Step 1: Interview (for non-trivial features)

Before exploring code, ask the user 3-5 targeted questions:

- What problem does this solve? Who benefits?
- What's the expected user interaction flow?
- Are there constraints or non-negotiable requirements?
- Any existing patterns or services to reuse?
- What does "done" look like?

Use `AskUserQuestion` for structured questions with options when applicable.

### Step 2: Explore

Launch Explore agents to investigate the codebase:

- Existing patterns and services that can be reused
- Affected files and their current structure
- Related components and dependencies
- Test patterns for similar features

### Step 3: Design + Issue Breakdown

Write the plan with this structure:

```markdown
# Plan: [Feature Name]

## Context
Why this change is needed. The problem or opportunity. 1-2 paragraphs.

## Requirements
Specific, testable requirements as checkboxes.

## Technical Approach
Architecture decisions, patterns to follow, services to reuse (with file paths).

## Issue Breakdown
For each issue:
- Title (descriptive only — no word prefixes)
- Milestone (which GitHub Milestone this belongs to)
- Parent issue (if this is a sub-issue)
- Labels (read available labels from project-context.md)
- Context (why this specific piece, how it fits in the whole)
- Requirements (checkboxes — one per testable behavior)
- Technical approach (specific files to modify/create, patterns to follow with file:line references)
- Acceptance criteria (what must be true when done)
- Dependencies (which issues must be completed first)
- Implementation order (sequence number for execution)

## Verification
How to test the complete feature end-to-end once all issues are done.
```

### Step 4: User Review

Exit plan mode for user approval. The user can edit the plan directly.

### Step 5: Issue Creation

Once approved, create all GitHub issues in batch using the Issue Breakdown section. Each issue follows the standardized template below.

## Issue Body Template

Every issue created from a plan should use this structure:

```markdown
## Context
[1-2 paragraphs: WHY this change is needed. How it fits into the parent milestone/feature.
What problem it solves. Business context that helps make architectural decisions.]

Parent: #[parent-issue-number] — [parent title]

## Requirements
- [ ] [Specific, testable requirement 1]
- [ ] [Specific, testable requirement 2]
- [ ] [Specific, testable requirement 3]

## Technical Approach

### Files to Modify
- `path/to/file` — [what changes and why]
- `path/to/other-file` — [what changes and why]

### Files to Create
- `path/to/new-file` — [purpose, what pattern to follow]

### Patterns to Follow
- Follow the pattern in `path/to/example:42-80` for [specific pattern]
- Reuse `ExistingService` from `path/to/service` for [specific capability]
- Follow validation patterns from project-context.md

### Key Decisions
- [Decision 1]: [chosen approach] because [reason]
- [Decision 2]: [chosen approach] because [reason]

## Acceptance Criteria
- [ ] [Verifiable behavior 1 — what a reviewer can check]
- [ ] [Verifiable behavior 2]
- [ ] All existing tests pass
- [ ] New tests cover [specific scenarios]
- [ ] All validation checks pass (lint, typecheck, build)

## References
- Plan: [link to plan if applicable]
- Related: #[related-issue]
- Docs: [relevant documentation links]
```

## Issue Creation Workflow

After creating each issue:

```text
1. Create issue (MCP issue_write with milestone number)
2. Link as sub-issue if needed (MCP sub_issue_write)
3. Apply labels: type + area (read available labels from project-context.md)
```

## Follow-Up Issue Template

Follow-up issues created during the Standard Workflow (by the github-updater
or orchestrator) MUST include discovery context. This prevents the next session
from re-researching, re-running diagnostics, or re-discovering file lists.

```markdown
## Summary
[1-2 sentences: what needs to be done and why]

Origin: #[originating-issue] — [discovered during implementation of X]

## Acceptance Criteria
- [ ] [Verifiable behavior 1]
- [ ] [Verifiable behavior 2]
- [ ] All tests pass, lint clean (0 errors, 0 warnings)

## Discovery Context

### Affected Files
<!-- Exact file list, grouped by category. Include line counts or occurrence
     counts where relevant. This saves the next session from re-scanning. -->

### Diagnostic Data
<!-- Raw output or summary: lint warnings, test failures, error categories.
     Include the exact command used to generate the data. -->

### Research Findings
<!-- ADR references, best practice citations, pattern decisions already made.
     Link to brain docs: [[NNNN-adr-slug]] -->

### Recommended Approach
<!-- If the creating session already knows HOW to fix it, document it here.
     Include effort estimate and any risks. -->

## References
- Origin issue: #[N]
- Discovery doc: `brain/discovery/issue-{N}-{slug}.md` (if large context)
- Related ADRs: [[NNNN-slug]]
```

**When to use a discovery doc vs inline context:**

- **Inline** (in the issue body): File lists under ~20 entries, short diagnostic
  summaries, simple approach recommendations
- **Discovery doc** (`brain/discovery/issue-{N}-{slug}.md`): File lists over
  20 entries, full diagnostic output, multi-page research findings. Link from
  the issue body.

## Key Principles

- **"Why" before "what"** — Context section comes first and explains the business reason
- **Pattern references by file path** — cite exact file:line instead of describing patterns
- **Testable checkboxes** — every requirement and acceptance criterion maps to a verifiable behavior
- **Explicit file list** — enumerate files to modify/create upfront so the agent can scope the work
- **Key decisions pre-made** — don't leave architectural decisions to the implementation session
- **No prefixes in titles** — descriptive names only; phase tracking via Milestone assignment
- **Each issue independently implementable** — no implicit dependencies
- **4-8 files maximum per issue** — if larger, split it
- **Use extended thinking** (`think hard`) for complex multi-issue plans
