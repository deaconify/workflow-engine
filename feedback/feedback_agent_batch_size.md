---
name: Agent batch size limits for mechanical refactoring
description: Cap agent batches at 15-20 files for mechanical refactoring. Commit after each batch. Verify before next batch.
type: feedback
originSessionId: 4fe53ee3-15a4-462b-be98-d9f7db785972
---
For large mechanical refactoring (DI migration, pattern changes across many files), cap each agent at 15-20 files maximum.

**Why:** In Issue #604 (144 files), a single agent attempting all 85 handler files exhausted its turn limit and persisted nothing. Batches of 20 files worked reliably. Agents also need enough turns to read each file before editing.

**How to apply:**
1. Count total files needing changes
2. Divide into batches of 15-20 files per agent
3. Launch agents in parallel (up to 4)
4. After EACH batch completes: verify persistence (git status), commit, then launch next batch
5. Never proceed to the next phase until all batches are committed
6. Include in agent prompts: "DO NOT run git checkout or revert files. If a file has issues, skip it and report."
