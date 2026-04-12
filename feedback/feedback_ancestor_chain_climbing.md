---
name: GitHub updater must climb full ancestor chain
description: When closing a parent issue, the github-updater must recursively check off and close all ancestors up the tree, not just the immediate parent
type: feedback
---

When the github-updater closes a parent issue (e.g., #475 with title `8.9.5:`), it MUST climb the ancestor chain to update grandparents (e.g., #149 with title `8.9:`). The agent has Step 3a for this, but it failed to execute because the orchestrator told it "no grandparent" and the agent treated `8.9.5:` as a two-part "top-level" issue.

**Why:** Issue #149 (8.9: Enterprise Security) was left open with unchecked `[ ] #475` and `[ ] #493` even though all 5 sub-issues were closed. The github-updater's Step 0 "two-part = top-level" rule was ambiguously applied to the parent issue during chain climbing, not just the original issue.

**How to apply:**
1. The orchestrator MUST tell the github-updater about the full ancestor chain, not just the immediate parent.
2. The github-updater agent Step 3a was strengthened: it now explicitly counts numeric segments in the parent's title and always climbs if 3+ segments exist. The "two-part = top-level" rule only applies to the original issue in Step 0, not to ancestors during chain climbing.
3. After the github-updater completes, the orchestrator should verify that any issue whose sub-issues are ALL closed has itself been closed.
