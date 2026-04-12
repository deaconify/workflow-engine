---
name: Full brain vault drift coverage
description: ALL brain documents must be maintained by drift-detector, not just reference files and capability docs
type: feedback
---

All brain documents must be kept current — drift of correct information is unacceptable.

**Why:** The user considers every document in the `brain/` vault to be authoritative. If planning docs, operations guides, infrastructure docs, ADRs, or marketing docs fall out of sync with the codebase, they become actively harmful — misleading future sessions and decisions.

**How to apply:** The drift-detector agent (Step 11) must audit ALL brain directories: `planning/`, `operations/`, `infrastructure/`, `decisions/`, `marketing/`, and `sessions/` — not just `reference/` and `capabilities/`. When spawning the drift-detector, ensure the implementation summary and changed files are detailed enough for it to check all affected docs across the entire vault.
