---
title: "Discovery Documents"
doc_type: reference
tags: [architecture]
---

This directory contains discovery context documents for open issues. These files preserve research findings, file lists, diagnostic data, and recommended approaches across sessions.

## Lifecycle

- **Created**: When a follow-up issue needs non-trivial context (20+ files, diagnostic output, multi-page research)
- **Read**: By agents at the start of work on the linked issue (`brain_search("issue {N}")`)
- **Deleted**: By the session that closes the linked issue (Step 8 of Standard Workflow)

## Naming Convention

`issue-{N}-{slug}.md` where `N` is the GitHub issue number and `slug` is a short description.

## Template

```markdown
---
title: "Discovery: [description]"
doc_type: discovery
tags: [discovery, issue-N, relevant-tags]
github_issue: N
---

# Discovery: [Description]

**Issue:** #N — [Title]
**Origin:** #[originating-issue]
**Created:** YYYY-MM-DD

## [Content sections as needed]
```
