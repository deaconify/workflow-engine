---
name: Lint warnings must be reported and resolved
description: Never gloss over lint warnings — report them to the user, fix them, or escalate. Zero warnings is the target.
type: feedback
originSessionId: 4fe53ee3-15a4-462b-be98-d9f7db785972
---
Lint warnings MUST NOT be silently accepted. The target is zero errors AND zero warnings.

**Why:** In Issue #604, the validator and reviewer both reported "0 errors, 286 warnings" and moved on without flagging the warnings. This normalizes technical debt and masks real issues (e.g., `no-non-null-assertion` warnings can hide null safety bugs, `no-explicit-any` weakens type coverage).

**How to apply:**
1. **Step 3 (implementation)**: After implementation, run `npm run lint`. If there are ANY warnings, report the count and categories to the user before proceeding.
2. **Step 4 (review)**: The reviewer MUST flag the warning count in its report. "0 errors" is not a clean lint — "0 errors, 0 warnings" is.
3. **New warnings introduced by the implementation**: MUST be fixed before proceeding. No new warnings allowed.
4. **Pre-existing warnings**: Report count to the user at close-out. If the count is high, propose a follow-up issue to clean them up.
5. **Close-out summary (Step 4c)**: The Validation row must show both error AND warning counts: "lint: 0 errors, 0 warnings" — not just "lint: 0 errors."
