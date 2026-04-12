---
name: Standard table formats for workflow gates
description: IRD approval (Step 2b) and close-out review (Step 4c) must always use the mandatory table formats defined in standard-workflow.md. Commits use /commit skill.
type: feedback
---

IRD approval and close-out review must always use standardized table formats — no freeform presentation.

**Why:** The user found inconsistent IRD presentations hard to review and approve. A fixed table format with Tier/Category/Constraint/Target columns makes review predictable and fast. The close-out review consolidates everything into one sign-off gate before committing.

**How to apply:**
- Step 2b Phase 2: Always present IRD as the standard constraints table. Include resolved design decisions in the same table view before final approval.
- Step 4c: Always present the close-out summary table (issue, verdict, compliance, warnings, follow-ups, files, validation) before committing.
- All commits during the Standard Workflow use the `/commit` skill — implementation commit at Step 4c, brain docs commit at Step 8.
- Never present IRD or close-out as bullet lists or freeform text — always the defined table structure.
