---
name: Always use AskUserQuestion for approvals
description: Close-out reviews and all user approval gates must use AskUserQuestion tool, never plain text
type: feedback
---

Close-out reviews (Step 4c) and ALL user approval gates in the Standard Workflow MUST use the `AskUserQuestion` tool — never present as plain text and assume the user will respond.

**Why:** The user has corrected this multiple times. Plain text presentation of approval gates does not create an interactive approval point — the user needs an explicit question to respond to.

**How to apply:** Every time the workflow says "wait for user approval" or "user approves", use `AskUserQuestion` with approve/reject options. This applies to: Step 2b (IRD approval), Step 4b (reviewer warnings), Step 4c (close-out approval), and any other decision points.
