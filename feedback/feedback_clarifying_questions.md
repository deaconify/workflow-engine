---
name: feedback_clarifying_questions
description: ALWAYS use AskUserQuestion tool for clarifying questions during issue work — never dump questions as plain text
type: feedback
---

When the issue-worker agent (or any agent) returns clarifying questions, the orchestrator MUST present them using the `AskUserQuestion` tool — NOT as plain text in the conversation.

- **One item per AskUserQuestion call** — never combine multiple questions/findings into a single call. Each question gets its own individual `AskUserQuestion`.
- Present at most 4 items at a time (4 parallel `AskUserQuestion` calls), wait for all responses, then present the next batch of up to 4.
- Ask ALL questions — never skip or summarize away any question.
- This applies to: issue-worker clarifying questions, reviewer warnings, security audit findings, compliance findings, and any other decision point.
- The user explicitly corrected the plain-text pattern on 2026-03-12.
- The user explicitly corrected the batching-multiple-into-one pattern on 2026-03-20.
