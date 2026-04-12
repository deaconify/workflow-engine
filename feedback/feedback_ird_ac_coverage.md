---
name: IRD must cover all acceptance criteria
description: IRD must cross-check against every issue AC checkbox — functional requirements need MUST constraints, not just security/compliance items
type: feedback
---

IRD must map to every acceptance criterion in the GitHub issue. Functional AC (UI tasks, API endpoints, data model work) must be represented as MUST-tier constraints, not silently scoped out.

**Why:** Issue #493 had 4 Ops Portal UI acceptance criteria that were entirely absent from the IRD. The IRD only contained security/compliance constraints. The orchestrator reported "12/12 MUST passed" — technically true against a deficient IRD — and closed the issue with 4 unchecked AC. The requirements-planner scoped out "Frontend Security" (conflating security concerns with functional requirements), the issue-worker was told "backend is priority", and the reviewer only verified IRD constraints without cross-checking issue AC.

**How to apply:**
1. **Step 2 (IRD):** After receiving the IRD, orchestrator cross-checks every issue AC checkbox against IRD constraints. Missing AC → add MUST-tier functional constraints before presenting to user.
2. **Step 2b (IRD presentation):** Include "Acceptance Criteria Coverage" table mapping each AC to its constraint.
3. **Step 4b (reviewer results):** Orchestrator re-reads the issue and verifies every AC is implemented, independent of IRD. Any unimplemented AC is flagged to user regardless of IRD coverage.
4. **Reviewer agent:** Has a mandatory 4g step checking AC against implementation, treating unmet AC as CRITICAL.
5. **Requirements-planner agent:** Has a mandatory 4b step verifying AC coverage before producing the IRD.
