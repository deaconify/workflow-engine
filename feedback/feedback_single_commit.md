---
name: Single commit per issue — combine implementation and brain docs
description: Only one commit per Standard Workflow issue — implementation + brain docs together at the end, not two separate commits
type: feedback
---

The Standard Workflow must produce exactly ONE commit per issue, not two. Combine implementation changes and brain documentation updates into a single commit at the end of the workflow (after drift detection completes, before session end).

**Why:** Two commits per issue (one for implementation at Step 4c, one for brain docs at Step 8) is unnecessary overhead. The brain docs are part of the issue's deliverable, not a separate concern.

**How to apply:** Do NOT commit at Step 4c. Instead, defer the commit until after Steps 5-7 complete (GitHub update, Obsidian docs, drift detection). Then commit ALL changes (implementation + brain docs) together in a single commit at Step 8 using `/commit`.
