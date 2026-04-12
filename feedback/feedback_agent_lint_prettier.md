---
name: Agents must run prettier on changed files
description: Agent prompts for code changes must include running prettier before reporting completion
type: feedback
originSessionId: 4fe53ee3-15a4-462b-be98-d9f7db785972
---
Every agent that writes or modifies TypeScript files MUST run `npx prettier --write` on changed files before reporting completion.

**Why:** In Issue #604, agents wrote syntactically correct but poorly formatted code (wrong indentation inside factory functions). This caused 508 prettier/lint errors that required a separate fix pass and an additional commit.

**How to apply:** Include in every implementation agent prompt:
- "After all edits, run: `npx prettier --write [changed files]`"
- "Run `npm run lint 2>&1 | grep error | wc -l` and fix any errors before reporting"
- The orchestrator should also run prettier after agent completion as a safety net
