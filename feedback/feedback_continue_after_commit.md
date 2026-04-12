---
name: Continue after commit through all remaining steps
description: After the single commit at Step 8, immediately continue all close-out steps without stopping or waiting for user input
type: feedback
---

After the `/commit` skill completes, immediately continue executing all remaining steps without pausing for user interaction. The commit output is NOT a stopping point.

**Why:** User has repeatedly observed the workflow stalling after commit. The Standard Workflow is a complete pipeline — stopping mid-flow forces the user to manually prompt continuation every time.

**How to apply:** After `/commit` returns, immediately spawn the next agents and complete all remaining steps. Never wait for user input between close-out steps unless an error occurs.
