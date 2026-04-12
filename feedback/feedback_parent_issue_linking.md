---
name: Parent issue linking
description: Orchestrator must parse issue title to determine parent, look up the parent issue number, and verify all parent updates after agent completes
type: feedback
---

CRITICAL: When spawning the github-updater agent, NEVER assert that an issue is "standalone" or "not a sub-issue" based on assumptions. Always parse the issue title's naming convention (M.I.S format) to determine the parent relationship.

**Why:** Recurring failure pattern. In Issue #528 (titled "8.4.14"), the orchestrator told the agent the issue was standalone — wrong, parent was #147. In Issue #541 (titled "8.7.25"), the orchestrator gave a vague "check if there is a parent" hint instead of looking up the parent. The agent checked GitHub API `parent_id` (which was null because the sub-issue link wasn't set), concluded no parent exists, and skipped all parent updates: no checkbox, no comment, no sub-issue linking for the follow-up.

**How to apply:** When preparing the github-updater prompt:

1. Parse the issue title for M.I.S format (e.g., "8.7.25" → parent is "8.7")
2. **Look up the parent issue number** by searching: `gh issue list --search "8.7:" | grep "8\.7:"`
3. Tell the agent explicitly: "Parent issue is #N — check off #X in the body, add a completion comment, and link any follow-ups as sub-issues of #N"
4. Never say "standalone" or "no parent" — and never leave it to the agent to figure out
5. **After the agent completes**, the orchestrator MUST verify:
   - The closed issue is checked off (`[x]`) in the parent body
   - A completion comment was posted on the parent
   - Any follow-up issues are linked as sub-issues of the parent AND listed in the parent body checklist
