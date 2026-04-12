---
name: Issue numbering enforcement
description: MUST check existing sub-issues before creating any new sub-issue — applies to both main conversation AND agent prompts. Uses specific gh CLI command that actually works.
type: feedback
---

NEVER assign a sub-issue number (M.I.S) without first checking what numbers already exist.

**Why:** This has been a recurring mistake across MANY conversations despite being documented everywhere. The most recent failure (2026-03-15): created #503 as `8.4.5.4`, renamed to `8.4.5.5` (collided with #500), renamed to `8.4.5.7` (collided with #502), finally fixed to `8.4.5.8`. Root cause: `gh issue list --search` and MCP `search_issues` both use GitHub's search index which is **incomplete and delayed** — they silently omit recently created issues.

**How to apply:**

1. **THE ONLY RELIABLE COMMAND:** Run `gh issue list --repo deaconify/deacon --state all --limit 100 --json number,title | grep "M.I."` where `M.I.` is the parent prefix (e.g., `8.4.5.`). This lists issues by recency (not search index) and is reliable. **DO NOT use `--search` flag** — it uses GitHub's search index which misses issues. **DO NOT use MCP `search_issues`** — same unreliable index.
2. Identify the highest existing sub-issue number from the grep results.
3. Use the next number after that (e.g., if highest is `.7`, use `.8`).
4. This applies in the main conversation AND in agent prompts — when spawning agents that may create follow-up issues, the orchestrator MUST run this check first and provide the correct number to the agent. Never delegate numbering to agents.
5. **After creating the issue**, do BOTH of these — no exceptions:
   a. **Link as sub-issue:** Use `sub_issue_write` (method: `add`) with the parent issue number. Get the numeric ID via `gh api repos/deaconify/deacon/issues/N --jq '.id'`.
   b. **Update parent body:** Add a `- [ ] #N — M.I.S: Title` checklist entry to the parent issue's Sub-Issues section via `gh issue edit --body`. If no Sub-Issues section exists, create one.
6. **Parent issue closure rule:** NEVER close a parent issue while it has open child issues, even if the parent's own tasks are all complete. The parent stays open until ALL sub-issues are closed. When closing a sub-issue (Step 9b), check remaining open sub-issues on the parent and note progress — do NOT close the parent unless all are done.
7. **No shortcuts.** Do not assume you know the next number. Do not skip the search. Do not trust partial results. ALWAYS grep the full recent issue list.
