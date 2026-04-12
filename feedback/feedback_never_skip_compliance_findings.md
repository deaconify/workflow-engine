---
name: never-skip-compliance-findings
description: Must present ALL compliance audit findings (including LOW) to user via AskUserQuestion — never skip or silently acknowledge
type: feedback
---

Always present ALL compliance audit findings to the user via AskUserQuestion, regardless of severity (CRITICAL, HIGH, MEDIUM, or LOW). Never silently skip, acknowledge, or note findings without user input.

**Why:** User explicitly corrected this behavior — even LOW findings from pre-existing patterns must be presented for the user to decide how to handle (fix now, follow-up issue, or acknowledge). The user decides, not the orchestrator.

**How to apply:** After each compliance agent returns, check for ANY findings at any severity level. Present each one individually via AskUserQuestion with resolution options (fix now, create follow-up issue, acknowledge and proceed). This applies equally to security audit findings.
