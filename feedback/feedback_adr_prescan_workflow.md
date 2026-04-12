---
name: ADR Pre-Scan Workflow
description: Requirements planner must scan existing ADRs before researching or presenting design decisions to prevent token waste on already-decided topics
type: feedback
originSessionId: aba7a0e1-4208-4ac7-9e6d-88f2b664b583
---
Requirements planner was re-researching and re-presenting design decisions even when existing ADRs already covered the topic, wasting tokens and time.

**Why:** ADRs document decisions once. If the planner ignores them, every future issue touching the same domain re-researches the same question and asks the user to re-decide.

**How to apply:**
- The `@requirements-planner` now has a mandatory Step 2 (ADR Pre-Scan) before reading reference files or performing MCP research
- Topics are classified as Fully Covered (skip research), Partially Covered (targeted research only), or Not Covered (full research)
- Only "Not Covered" topics appear in the IRD's "Design Decisions Required" section
- The ADR Quality Standard defines what makes an ADR complete enough to prevent re-research (all four sections with substantive content)
- The `@issue-worker` has an ADR Creation Standard ensuring new ADRs are robust enough to be classified as "Fully Covered" in future pre-scans
- See `brain/reference/compliance-agent-patterns.md` (ADR Pre-Scan and ADR Quality Standard sections)
