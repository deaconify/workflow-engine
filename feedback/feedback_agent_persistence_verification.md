---
name: Agent persistence verification
description: After every agent completes, verify changes persisted to disk via git status/diff before proceeding
type: feedback
originSessionId: 4fe53ee3-15a4-462b-be98-d9f7db785972
---
After every agent completes, MUST verify changes actually persisted to disk before proceeding or trusting the agent's report.

**Why:** In Issue #604, three separate agents reported successful completion (84 handler files, middleware tests, handler test batches) but wrote zero files to disk. The orchestrator trusted the reports and proceeded, wasting hours re-spawning.

**How to apply:** After every implementation agent completes:
1. Run `git status --short | wc -l` to check if files actually changed
2. If 0 changes, the agent failed silently — re-spawn, don't proceed
3. Run `git diff --stat HEAD` to verify the right files changed
4. Commit immediately after verification to prevent loss
