---
name: IRD must be persisted to disk and GitHub
description: Write approved IRD to brain/sessions/ird-{issue}.md and post to GitHub issue — agents read from disk, never from orchestrator context
type: feedback
originSessionId: 4fe53ee3-15a4-462b-be98-d9f7db785972
---
The approved IRD MUST be written to disk and posted to the GitHub issue. Agents MUST read the IRD from the file, never from the orchestrator's context window.

**Why:** In Issue #604, the IRD existed only in the orchestrator's context. Agents received paraphrased versions. The reviewer "verified" constraints from memory, not from the approved document. Result: 57 deleted tests went undetected because the reviewer was working from assumptions, not the source of truth. Context window compression can also truncate or lose IRD details mid-session.

**How to apply:**

1. **Step 2b (after user approves):** Write the full approved IRD (exact table format) to `brain/sessions/ird-{issue-number}.md`. Post the same content as a comment on the GitHub issue.
2. **Step 3 (implementation):** Agent prompt says "Read the approved IRD from `brain/sessions/ird-{issue-number}.md`" — no paraphrasing, no summarizing constraints in the prompt.
3. **Step 4 (review):** Reviewer prompt says "Read the approved IRD from `brain/sessions/ird-{issue-number}.md` and verify each constraint" — reviewer reads the actual document, not the orchestrator's restatement.
4. **Step 4b (orchestrator presents results):** Orchestrator re-reads the IRD file to build the compliance table. Never presents from memory.
5. **Step 8 (cleanup):** Delete `brain/sessions/ird-{issue-number}.md` — the GitHub comment is the permanent audit record.

**IRD file format:** Same standard table format from Step 2b Phase 2 (constraints table, design decisions, AC coverage, out of scope). Include the issue number and title in the header.
