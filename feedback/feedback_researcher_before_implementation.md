---
name: Researcher agent before implementation
description: Always spawn researcher agent before issue-worker when issue contains verification or research tasks about external technology behavior
type: feedback
---

The `@researcher` agent MUST ALWAYS be spawned in Step 1, in parallel with the `@issue-worker` (read-only mode). This is mandatory — not conditional on the issue involving "external technology."

**Why:** On Issue #523, researcher was skipped and a critical CSP requirement was nearly missed. More broadly, ALL questions about security/compliance and code best practices must be informed by research before being asked. The researcher's findings feed into the requirements-planner (IRD) and into any clarifying questions — ensuring the user gets best practice recommendations, not open-ended asks.

**How to apply:** Always spawn `@researcher` in Step 1 alongside the `@issue-worker`. The researcher gathers best practices for security, compliance, and code patterns. Its findings inform all subsequent questions and the IRD. See also [feedback_research_backed_questions.md](feedback_research_backed_questions.md) for the question-framing rule.
