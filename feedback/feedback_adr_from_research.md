---
name: ADRs from research-backed decisions
description: When research identifies best practices and design decisions are made, always create or update ADRs in brain/decisions/
type: feedback
originSessionId: a1613d79-e318-479a-9a01-de6d2b2c5a51
---
When the @researcher agent identifies best practices and those findings lead to design decisions (explicit user choices or confirmed approaches), always create or update the relevant ADR in `brain/decisions/`.

**Why:** The user wants research findings and their resulting design decisions to be persistently documented in the architecture decision records, not just ephemeral conversation context. ADRs preserve the *why* — the research sources, trade-offs considered, and chosen approach — so future sessions can reference them.

**How to apply:**
- After Step 1 research completes and any design decision is made (Step 2b Phase 1, or user-directed decisions during implementation), check if an existing ADR covers the topic.
- If yes: update the ADR with the new research findings and decision.
- If no: create a new ADR (auto-increment from decisions.md) with the research sources cited.
- This applies even when the decision confirms an existing approach — the research citation strengthens the rationale.
- Do this during implementation (not deferred to drift-detection) so the ADR is part of the single commit.
