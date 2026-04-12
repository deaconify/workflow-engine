---
name: Discovery context must be preserved for follow-up issues
description: Follow-up issues must include full discovery context (file lists, diagnostics, research). Large context goes to brain/discovery/. Agents check for discovery docs before starting work.
type: feedback
originSessionId: 4fe53ee3-15a4-462b-be98-d9f7db785972
---
Follow-up issues MUST include all discovery context from the creating session. Agents MUST check for existing discovery docs before starting work on any issue.

**Why:** In Issue #604, follow-up issues were created with thin bodies — just a title and AC checkboxes. All discovery work (file lists, diagnostic output, error breakdowns, research findings) died with the session's context window. The next session would have to re-discover everything from scratch, wasting tokens and time.

**How to apply:**

1. **Orchestrator (Step 5):** Before spawning github-updater, assemble discovery context for each follow-up: affected files, diagnostic data, research findings, recommended approach. If context is large (20+ files), write to `brain/discovery/issue-{N}-{slug}.md`.
2. **github-updater:** Follow-up issue bodies use the Follow-Up Issue Template (in planning-protocol.md) with mandatory Discovery Context section. Never create thin issues.
3. **issue-worker (Step 1):** Check `brain_search("issue {N}")` for discovery docs before starting research. Read any `brain/discovery/issue-{N}-*.md` files.
4. **researcher (Step 0):** Same — check for discovery docs before external research.
5. **Session that closes the linked issue:** Delete the discovery doc at Step 8.
