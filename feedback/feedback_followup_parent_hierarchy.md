---
name: Follow-up issues parent to the working issue, not grandparent
description: When creating follow-up sub-issues, they must be children of the issue being worked on — not the grandparent. The working issue stays open until all sub-issues are resolved.
type: feedback
---

Follow-up issues created during implementation belong as sub-issues of the issue being worked on, NOT the grandparent issue.

**Why:** Issue #245 had follow-ups #589-591 incorrectly attached as sub-issues of #148 (the grandparent). The M.I.S numbering (8.8.7.1, 8.8.7.2, 8.8.7.3) already signals they're children of 8.8.7 (#245), not siblings of it. Additionally, #245 was incorrectly closed — it should stay open until all its sub-issues are resolved.

**How to apply:**
- When creating follow-up issues during Standard Workflow Step 5, always make them sub-issues of the issue being worked on (e.g., #245), not its parent (#148).
- Do NOT close an issue that has open follow-up sub-issues. Leave it open.
- The github-updater agent prompt must clearly specify: "parent for follow-ups is #N (the working issue)" — never the grandparent.
- Verify after creation: `get_sub_issues` on the working issue should show the follow-ups, NOT on the grandparent.
