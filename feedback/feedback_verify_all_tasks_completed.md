---
name: Verify all issue tasks completed before closing
description: Every checkbox in the issue body must be either implemented or explicitly tracked as a follow-up before closing the issue
type: feedback
---

Every task checkbox in the issue body must be accounted for before closing: either implemented (checked off) or explicitly created as a follow-up sub-issue. The issue-worker, reviewer, and orchestrator all failed to catch 5 unchecked items in #249 (alert timeline visualization, Azure Monitor integration x3, email notifications deferred to #329).

**Why:** The user caught that #249 was closed with unchecked tasks and no follow-up issues for them. This creates orphaned work that falls through the cracks.

**How to apply:** During Step 4c (close-out review), the orchestrator MUST compare every checkbox in the issue body against what was implemented. Any unchecked items must either be (a) completed before closing, or (b) created as follow-up sub-issues of the current issue, which stays open until all sub-issues are resolved. Never close an issue with unchecked tasks unless they're tracked elsewhere.
