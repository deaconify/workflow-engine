---
name: Research-backed questions before IRD
description: All security/compliance and code best practice questions must be informed by MCP research before being asked — present recommendations, not open-ended asks
type: feedback
---

Before asking the user any question related to security, compliance, or code best practices, MCP research MUST be performed first. Questions should present the recommended best practice (citing official documentation) alongside the question — never ask open-ended questions without a recommendation.

**Why:** The user wants informed recommendations, not just "what do you want to do?" When questions are backed by research, the user gets the best practice presented and can either approve or override with reasoning. This prevents uninformed design decisions and ensures security/compliance alignment from the start.

**How to apply:**
- The `@researcher` agent ALWAYS runs in Step 1 (not conditionally on "external technology")
- Before asking any security/compliance question, verify you have research backing
- Before asking any code best practice question, verify you have research backing
- Frame questions as: "Best practice per [source] is [X]. Should we follow this?" — not "What should we do?"
- If research didn't cover a topic that comes up during questions, do additional MCP lookups before asking
- This applies to: IRD design decisions (Step 2b), issue-worker clarifying questions (Step 3), and any orchestrator questions
