---
name: never-skip-failed-agents
description: Must re-spawn agents that fail to produce a report — never move on without a complete result
type: feedback
---

If a required agent exhausts its turns or fails to produce a structured report, NEVER move on to the next workflow step. The agent must be re-spawned with a more focused prompt.

**Why:** User explicitly flagged this as unacceptable. If an agent is required by the workflow (e.g., requirements-planner triggered by the matrix, or reviewer for IRD verification), its report is mandatory. "Covered by other audits" is not an acceptable justification for skipping.

**How to apply:** When an agent completes without a structured report/verdict, immediately re-spawn it with a more focused prompt that emphasizes budget management (e.g., "skip exhaustive file reads, prioritize producing the report"). Only proceed to the next step once all required agents have returned complete reports with clear verdicts.
