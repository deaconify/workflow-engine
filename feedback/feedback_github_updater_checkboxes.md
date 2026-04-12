---
name: github-updater must check off task checkboxes before closing
description: The github-updater agent must update issue body checkboxes from [ ] to [x] before closing — this is a recurring failure where the agent skips body edits
type: feedback
---

The github-updater agent MUST check off all completed task checkboxes (`- [ ]` → `- [x]`) in the issue body BEFORE closing the issue. This is explicitly required by the agent's Step 2 instructions but the agent has repeatedly skipped it, closing issues with all checkboxes still unchecked.

**Why:** In Issue #590 (2026-04-03), the agent acknowledged "Task lists: Not checked off" in its output but closed the issue anyway. All 11 checkboxes remained unchecked on the closed issue. This makes it appear that no work was completed and undermines the issue tracking system. The agent's Step 2 has been strengthened to make this a mandatory sub-step (2a) with verification and retry requirements.

**How to apply:** After the github-updater agent completes, the orchestrator should spot-check that the closed issue's body has checkboxes checked. If the agent reports "Task lists: Not checked off" or similar, the orchestrator must fix this inline before proceeding to subsequent steps. The agent definition at `.claude/agents/github-updater.md` Step 2a now explicitly requires: read body → replace checkboxes → write body → verify update.
