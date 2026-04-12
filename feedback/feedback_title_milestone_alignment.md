---
name: Title-milestone alignment
description: Issue title prefix M must match the assigned milestone number — sub-issues inherit parent's milestone, cross-milestone follow-ups get the target milestone's numbering
type: feedback
---

Issue title prefix (`M` in `M.I.S`) MUST always match the assigned milestone number.

**Why:** Issue #597 was created as `8.9.1.1.1` (inheriting parent #462's milestone 8 numbering) but assigned to milestone 9. This creates confusing mismatches where the title implies one phase but the milestone says another.

**How to apply:**
- When creating follow-up issues, determine the correct milestone FIRST
- Derive the title prefix from the milestone number, not from the parent issue's title
- A follow-up from issue `8.9.1` that belongs in milestone 9 becomes `9.x.y`, NOT `8.9.1.x`
- Sub-issues that stay in the same milestone as their parent inherit the parent's numbering normally
- Updated in: `brain/reference/github-standards.md` (rule 3) and `.claude/agents/github-updater.md` (Step 1c)
