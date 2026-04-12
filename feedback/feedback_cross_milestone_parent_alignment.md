---
name: Cross-milestone parent must match title numbering
description: When an issue is deferred to a different milestone, the sub-issue parent link must match the M.I prefix in the title — not the originating issue from the old milestone
type: feedback
---

When an issue originates in one milestone but is assigned to a different milestone, the sub-issue parent link MUST match the `M.I` prefix in the title, not the originating issue.

**Why:** Issue #598 was numbered `9.6.21` (milestone 9) but linked as a sub-issue of #462 (8.9.1, milestone 8). This contradicts the naming convention — if the title says `9.6.x`, the parent must be the `9.6` issue (#164). The orchestrator's prompt to the github-updater contained contradictory instructions (assign 9.x numbering AND link to #462).

**How to apply:**
- `Parent:` in the body = structural parent, matches the `M.I` title prefix. This is the sub-issue link target.
- `Origin:` in the body = provenance reference to where the work came from (cross-milestone). No sub-issue link.
- The originating issue (#462) gets a **Cross-Milestone References** section (not a checkbox) and its old checkbox is marked `[x]` with a deferral note.
- When briefing agents on issue configuration, never instruct both "number as 9.x" and "link as sub-issue of [milestone 8 issue]" — these are contradictory.
