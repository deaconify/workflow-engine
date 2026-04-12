---
title: "GitHub Issue Standards"
doc_type: reference
related_capabilities: []
tags: [ci-cd, roadmap, naming]
---

# GitHub Issue Standards

> Referenced from CLAUDE.md. Naming conventions, sub-issue workflow, and issue management patterns. Project-specific milestones, labels, and repo info live in `brain/reference/project-context.md`.

## Project & Milestone Structure

**Milestones** represent development phases. Issue assignment is done via GitHub Milestone, not labels.

Read the milestone table from `brain/reference/project-context.md`.

## Label Categories

Read the label taxonomy from `brain/reference/project-context.md`. Every project should define:

- **Type labels** — what kind of work (e.g., `bug`, `feature`, `chore`, `documentation`)
- **Area labels** — what component or domain
- **Priority labels** (optional) — urgency

## Required Labels for New Issues

Every issue should have:

1. **Milestone** - Assign to the correct GitHub Milestone
2. **Type label** - What kind of work?
3. **Area label** - What component?

Optional but recommended:

- **Priority** - for critical or high-priority items
- **Sub-issue link** - Link to parent issue if this is a sub-task

## Issue Title Naming Convention

Titles use **numeric prefixes only** — no word prefixes ("Task", "Milestone", "Phase").

| Level | Format | Used For | Example |
| ----- | ------ | -------- | ------- |
| **Issue** | `M.I: Description` | Main deliverables within a milestone | `7.2: Feature Name` |
| **Sub-issue** | `M.I.S: Description` | Granular work items under an issue | `7.2.1: Sub-task name` |

**Rules:**

1. **Issue vs Sub-issue** — Use an issue (`M.I`) for significant bodies of work. Use a sub-issue (`M.I.S`) for individual deliverables.
2. **Numbering** — `M` is the milestone number, `I` is sequential within that milestone, `S` is sequential within that issue.
3. **Title-milestone alignment** — The `M` prefix MUST match the assigned milestone number. If a follow-up belongs in a different milestone than its parent, it gets that milestone's numbering (not the parent's).
4. **New issues** — Check ALL existing issues under the parent (both open AND closed) to avoid duplicating a number. Read the GitHub repo owner/name from project-context.md, then: `gh issue list --repo OWNER/REPO --state all --limit 100 --json number,title | grep "M.I."` — DO NOT use `--search` flag or MCP `search_issues` (unreliable search index).
5. **No bare titles** — Every issue within a milestone should have a numeric prefix.

## New Issue Workflow

```text
1. Check existing sub-issue numbers (gh issue list --state all --limit 100 | grep "M.I.")
2. Create issue with correct next number (MCP issue_write with milestone number)
3. Link as sub-issue (MCP sub_issue_write — get numeric ID via gh api repos/OWNER/REPO/issues/N --jq '.id')
4. Update parent issue body — add checklist entry (- [ ] #N — M.I.S: Title) via gh issue edit --body
```

Read `OWNER/REPO` from `brain/reference/project-context.md`.

### Parent Issue Closure Rule

**NEVER close a parent issue while it has open child issues**, even if the parent's own tasks are all complete.

### Linking Sub-Issues

Use GitHub MCP `sub_issue_write` (method: `add`) to link sub-issues:

1. Create the issue using `issue_write` (method: `create`) with milestone and labels
2. Get the **node IDs** for both parent and new issue via `gh api graphql`
3. Link using `sub_issue_write` with owner/repo from project-context.md

### Fallback: GraphQL Mutation

If MCP tools are unavailable, use the GraphQL mutation:

```bash
gh api graphql -f query='
mutation {
  addSubIssue(input: {issueId: "PARENT_NODE_ID", subIssueId: "NEW_ISSUE_NODE_ID"}) {
    issue { title }
    subIssue { title number }
  }
}'
```

**Note:** The `gh issue edit --add-sub-issue` flag does not exist. Use MCP `sub_issue_write` or the GraphQL mutation.

## Labels to Avoid

Do NOT use generic GitHub default labels that have been removed:

- ~~good first issue~~ (not applicable)
- ~~help wanted~~ (not applicable)
- ~~invalid~~ (close issues instead)
- ~~wontfix~~ (close issues instead)
- ~~duplicate~~ (close and reference original)
- ~~question~~ (use discussions or close)
- ~~enhancement~~ (use the project's feature label instead)

## Creating New Labels

If you need a new label:

1. Check if an existing label covers the use case
2. Follow the color scheme for the category (read from project-context.md)
3. Use lowercase, hyphenated names (e.g., `new-label`)
4. Add a clear, concise description
