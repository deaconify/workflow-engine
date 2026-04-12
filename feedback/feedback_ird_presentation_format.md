---
name: IRD and tables must be presented as text, not inside AskUserQuestion
description: Present IRD tables, reviewer results, and close-out summaries as regular markdown text BEFORE the AskUserQuestion approval call. Never put large tables inside the question field.
type: feedback
---

Present IRD (Step 2b), reviewer results (Step 4b), and close-out summaries (Step 4c) as regular markdown text in the conversation. Then use AskUserQuestion ONLY for the short approval question ("Do you approve this IRD?").

**Why:** The AskUserQuestion tool renders the question in a compact UI element that cannot properly display large markdown tables. Putting the entire IRD inside the question field makes it unreadable.

**How to apply:** At every approval gate (Steps 2b, 4b, 4c), output the table content as regular conversation text first, then follow with a short AskUserQuestion asking for approval/modification. The question should reference the table above, not contain it.
