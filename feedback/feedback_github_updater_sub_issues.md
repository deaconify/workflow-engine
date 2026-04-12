---
name: github-updater must link sub-issues, update parent body, and check for content duplicates
description: The github-updater agent must check for existing issues with overlapping content before creating follow-ups, link as sub-issues, and update parent body
type: feedback
---

When the github-updater agent creates follow-up issues, it MUST also: (1) determine the correct parent for each follow-up based on content/context (not just naming convention), (2) link each as a sub-issue of that parent via `sub_issue_write` MCP tool, (3) update the parent issue body with a checklist entry via `gh issue edit --body`.

**Why:** In Issue #535, the github-updater created 10 follow-up issues (#545-#554) but only listed them in a closing comment — it did not link them as sub-issues and did not update the parent body. In Issue #547, the agent created #560 and #562 which duplicated existing open issues #550 and #542 respectively — it did not check for content overlap before creating.

**How to apply:**

1. **CRITICAL — Content dedup before creation:** Before creating ANY follow-up issue, the orchestrator (or agent) MUST search all existing open issues for content overlap. Run `gh issue list --repo deaconify/deacon --state all --limit 200 --json number,title,state` and check if any existing issue already covers the same topic. If a match is found, do NOT create the follow-up — instead note the existing issue number. This prevents duplicate issues like #560 (dup of #550) and #562 (dup of #542).

2. **Sub-issue linking:** After creation, verify all follow-up issues are: (a) linked as sub-issues to the correct parent (check via `issue_read` method `get_sub_issues`), (b) listed in the parent body checklist. The `sub_issue_write` MCP tool takes `issue_number` (parent's issue number) and `sub_issue_id` (child's numeric REST API ID) — use `gh api repos/deaconify/deacon/issues/$num --jq '.id'` to get the ID.

3. **Orchestrator must include dedup instructions in agent prompt:** When spawning the github-updater, explicitly instruct it to check for existing issues with overlapping content before creating each follow-up. Provide the list of existing issue titles if possible.
