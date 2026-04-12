---
title: "Standard Issue Workflow"
doc_type: reference
related_capabilities: []
tags: [ci-cd, testing, security, audit]
---

# Standard Issue Workflow

This document contains the full orchestration protocol for the Standard Issue Workflow. It is referenced from CLAUDE.md and read on-demand when the workflow is triggered. Issues follow [[github-standards]] naming and label conventions. Compliance requirements are assessed via the [[compliance-trigger-matrix]].

## Step 0: Session Start

Before spawning any agents, the orchestrator handles session setup inline:

1. **Read** `brain/sessions/current-state.md` (small file — use `Read` directly)
2. **Check for abandoned session** — if `status` is `in-progress`, archive to `brain/sessions/session-log.md` with `(abandoned)` marker and warn the user.
3. **Fetch issue metadata** — call `mcp__github__issue_read` with `method: get` to retrieve the issue title, milestone, and labels.
4. **Populate** `current-state.md` — set `active_issue`, `status: in-progress`, issue title, capability domain, milestone. Clear all other sections.
5. **Lint** modified files with the project's markdown linter.
6. **Proceed** to Step 1 (Planning Phase).

> **Note:** If `brain/sessions/session-log.md` does not exist (e.g., fresh clone), create it with the standard header before proceeding.

## PLANNING PHASE

### Step 1: Read Issue + Research

Spawn the `@issue-worker` agent in **read-only mode** (Steps 1-2 only: read issue + research). **Always** spawn the `@researcher` agent in parallel — this is mandatory, not conditional.

Both agents' findings inform all subsequent questions and decisions.

**Research-backed questions rule:** Before any question is presented to the user during the Planning Phase, the relevant best practice MUST have been researched. Questions must present the recommended approach (citing official docs), not open-ended asks.

**Research-to-ADR rule:** When research identifies best practices that lead to design decisions, the orchestrator MUST create or update the relevant ADR in `brain/decisions/`. Check `brain/decisions/decisions.md` for the highest ADR number before creating new ones.

### Step 1b: Orchestrator Triage

After Step 1 completes, determine which security/compliance categories apply:

1. Identify files affected by the implementation
2. Apply the **smart trigger matrix** — use `brain_lookup("reference/compliance-trigger-matrix.md")`
3. If NO categories match (UI-only, docs-only, test-only changes) — skip Step 2 and proceed to Step 3

### Step 2: Requirements Planning (Conditional)

Spawn the `@requirements-planner` agent with: issue context, research findings, affected files, and relevant checklist categories. **Set `max_turns: 30`.**

The planner produces an **Implementation Requirements Document (IRD)** with tiered constraints (MUST/SHOULD/CONSIDER/EXPLAIN). See `brain/reference/compliance-agent-patterns.md` for the IRD format and tier definitions.

**Verify the result:** The planner MUST return a structured IRD. If empty or truncated, re-spawn.

**Acceptance Criteria Coverage Check (MANDATORY):** Cross-check every AC checkbox against IRD constraints. Add MUST-tier functional constraints for any missing items.

### Step 2b: User Reviews IRD

Present the IRD to the user following the two-phase process below.

#### Phase 1: Resolve Design Decisions

Present unresolved decisions via `AskUserQuestion` — one per call. Create robust ADRs after each decision. Re-index via `brain_refresh()`.

#### Phase 2: Final IRD Approval

Present the complete IRD using this exact table format. This format is **mandatory** — no freeform presentation.

> **Issue:** #NNN — [Title]
>
> **Categories Evaluated:** [list with trigger reasons]
>
> **Constraints:**
>
> | # | Tier | Category | Constraint | Target |
> | --- | --- | --- | --- | --- |
> | 1 | MUST | [X.N] | [Specific constraint description] | [file or area] |
> | 2 | SHOULD | [X.N] | [Specific constraint description] | [file or area] |
> | 3 | CONSIDER | [X.N] | [Specific constraint description] | [file or area] |
> | 4 | EXPLAIN | [X.N] | [What needs documenting] | [ADR or comment] |
>
> **Design Decisions Resolved:**
>
> | Decision | Resolution | Rationale |
> | --- | --- | --- |
> | [Topic] | [Chosen option] | [Why] |
>
> *(If no decisions: "None")*
>
> **Acceptance Criteria Coverage:**
>
> | AC | Covered By |
> | --- | --- |
> | [Acceptance criterion text] | Constraint #N / Functional constraint / N/A |
>
> *(Every checkbox from the issue must appear here)*
>
> **Out of Scope:** [items or "None"]
>
> **Already Tracked:** [issue references or "None"]

The user approves, modifies, or removes constraints. Once approved:

1. **Write to disk:** Create `brain/sessions/ird-{issue-number}.md` with the full approved IRD in the exact table format above. This is the session-scoped working copy.
2. **Post FULL IRD to GitHub:** Add a comment on the issue containing the **complete** approved IRD — the entire table format above, verbatim. Do NOT summarize, abbreviate, or link to the local file. Do NOT reference `brain/sessions/ird-{issue-number}.md` in the comment — that file is temporary and will be deleted at Step 8. The GitHub comment IS the permanent audit record.
3. **Lint** the IRD file.
4. **Proceed** to Step 3.

All subsequent steps MUST read the IRD from `brain/sessions/ird-{issue-number}.md` using `Read`. Never from context or memory.

## IMPLEMENTATION PHASE

### Step 3: Issue Worker Implements

Spawn the `@issue-worker` agent with: issue context, research findings, AND a reference to the IRD file. The agent prompt MUST say: "Read the approved IRD from `brain/sessions/ird-{issue-number}.md` before implementing."

**Before spawning:** Record the baseline test count using the project's test command (read from `project-context.md`). This count MUST match exactly after implementation.

The issue-worker reads `brain/reference/project-context.md` for all implementation conventions — they are NOT repeated here.

#### Large-scope implementation (20+ files)

When the issue requires changing more than 20 files, use the **commit-verify-continue** cycle:

1. **Batch**: Split files into groups of 15-20 per agent. Launch up to 4 agents in parallel.
2. **Verify**: After each agent completes, run `git status --short | wc -l`. If 0 changes, re-spawn.
3. **Validate**: Run the project's typecheck command and formatter after each batch.
4. **Commit**: Commit verified work immediately to prevent loss.
5. **Continue**: Launch next batch only after previous batch is committed.
6. **Test count check**: After all batches, verify test count matches baseline.

Agent prompts for large refactoring MUST include:

- "DO NOT delete any existing tests — migrate them. Test count must remain at [N]."
- "DO NOT run `git checkout` or revert files. If a file has issues, skip it and report."
- "Run the project's formatter on all changed files before reporting completion."
- "Run the project's typecheck command at the end and fix any errors."

All incremental commits are squashed into a single commit at Step 8.

### Step 4: Code Review + Requirements Verification

Spawn the `@reviewer` agent with: issue number AND a reference to the IRD file. The agent prompt MUST say: "Read the approved IRD from `brain/sessions/ird-{issue-number}.md` and verify each constraint against the implementation." **Always set `max_turns: 50`.**

The reviewer performs code quality review AND IRD constraint verification.

- **REQUEST CHANGES** — fix in-place, re-validate. NOT follow-up issues.
- **APPROVE with warnings** — fix SHOULD constraints and WARNINGs in-place.
- **APPROVE (clean)** — proceed to Step 4b.

### Step 4b: User Reviews Results

**Acceptance Criteria Cross-Check (MANDATORY):** Before presenting, re-read the IRD from disk and re-read the GitHub issue. Flag any unimplemented AC.

Present using this exact table format. This format is **mandatory** — no freeform presentation. Every constraint from the Step 2b IRD must appear with its verification status.

> **Reviewer Results — Issue #NNN**
>
> **Verdict:** [APPROVE / APPROVE with warnings / REQUEST CHANGES]
>
> **Requirements Compliance:**
>
> | # | Tier | Constraint | Status | Evidence |
> | --- | --- | --- | --- | --- |
> | 1 | MUST | [Constraint description] | PASS / FAIL | [file:line or evidence] |
> | 2 | SHOULD | [Constraint description] | PASS / WARNING | [file:line or evidence] |
>
> **Acceptance Criteria Status:**
>
> | AC | Status | Evidence |
> | --- | --- | --- |
> | [Criterion from issue] | DONE / NOT DONE | [file:line or explanation] |
>
> **Issues Found:** [CRITICAL / WARNING / OBSERVATION items, or "None"]
>
> **New Scope Items:** [items outside IRD scope, or "None"]

After presenting, use `AskUserQuestion` for each warning/observation requiring user decision.

### Step 4c: ADR Coverage Check (Orchestrator — Inline)

Before presenting the close-out summary, the orchestrator performs an inline ADR coverage check. No agent spawn — the orchestrator does this directly.

1. **Design decisions from Step 2b** — list every design decision resolved during IRD approval. For each, verify a corresponding ADR exists in `brain/decisions/`. If missing, create it now (auto-increment number, follow ADR Quality Standard from `compliance-agent-patterns.md`).
2. **EXPLAIN constraints from IRD** — re-read the IRD from `brain/sessions/ird-{issue-number}.md`. For each EXPLAIN constraint, verify it has a code comment or ADR. Flag any gaps to the user.
3. **Researcher findings from Step 1** — review the key findings and best practice confirmations from the `@researcher` agent. If any finding confirmed a pattern or approach that sets a precedent (a choice future issues will follow), check whether an ADR covers it. If not, present to the user via `AskUserQuestion`: "The researcher confirmed [best practice] and we followed it. Should this be formalized as an ADR, or is it too narrow to warrant one?"

Only create ADRs the user approves. After creating any new ADRs, call `brain_refresh()`.

Include the results in the close-out summary's **ADR Coverage** row.

### Step 4d: Close-Out Review & Commit

Present using this exact table format. This format is **mandatory** — no freeform presentation.

> **Close-Out Review — Issue #NNN**
>
> | Item | Details |
> | --- | --- |
> | **Issue** | #NNN — [Title] |
> | **Reviewer Verdict** | [APPROVE / APPROVE with warnings] |
> | **IRD Compliance** | [X/Y MUST passed, Z/W SHOULD passed, or "No IRD"] |
> | **ADR Coverage** | [X design decisions documented, Y EXPLAIN constraints satisfied, Z researcher findings reviewed — or "No IRD"] |
> | **Warnings Resolved** | [count resolved, count acknowledged, or "None"] |
> | **Follow-up Issues** | [approved items, or "None"] |
> | **Files Changed** | [count] ([key files]) |
> | **Validation** | [lint: 0 errors / N warnings, typecheck: 0 errors, tests: N/N passing, build: clean] |

**Lint warning policy:** The Validation row MUST show both error AND warning counts:

- **New warnings from this issue**: MUST be fixed before proceeding
- **Pre-existing warnings**: Report count and top categories. Propose follow-up if high.

Wait for explicit approval. When confirmed, **do NOT commit yet** — proceed to Step 5. Single commit at Step 8.

## CLOSE-OUT PHASE

### Step 5: Update GitHub Issues

**Discovery context assembly (MANDATORY for follow-ups):** Assemble affected files, diagnostic data, research findings, and recommended approach. Write large context to `brain/discovery/issue-{N}-{slug}.md`.

Spawn the `@github-updater` agent. **Set `max_turns` = 35 + (follow_up_count x 9), minimum 50.**

**Verify:** After completion, check all follow-ups are linked as sub-issues and in parent body checklist.

### Step 6: Document in Obsidian

Spawn the `@documenter` agent with issue number, implementation summary, and changed files.

### Step 7: Drift Detection

Spawn the `@drift-detector` agent with implementation summary and changed files list.

### Step 8: Session End

After drift detection completes:

1. **Update** `current-state.md` — set `status: idle`, `active_issue: null`, populate Completed This Session, clear Active Work.
2. **Append** to `brain/sessions/session-log.md` — compact entry with date, capability, summary, files changed count, review verdict.
3. **Prune** session log to 20 entries max.
4. **Delete IRD file** — `brain/sessions/ird-{issue-number}.md`. The GitHub comment is the permanent record.
5. **Do NOT delete discovery docs** — they persist until their linked issue is closed.
6. **Lint** both session files.
7. **Single commit** — invoke the `/commit` skill. ALL changes (implementation + brain docs) in one commit to `main`.

## CLAUDE.md and Reference File Maintenance

**Do NOT update CLAUDE.md directly during the standard workflow.** The `@drift-detector` agent (Step 7) handles brain doc updates and flags CLAUDE.md changes for manual review.
