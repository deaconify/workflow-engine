---
name: Use brain-mcp for reading brain docs
description: Prefer brain-mcp tools (brain_search, brain_lookup, brain_context) over direct Read for brain/ vault files — 94% token savings on large files
type: feedback
originSessionId: c03266bb-2a57-4d96-9c11-fd3b10b3836d
---
All agents and the orchestrator MUST use brain-mcp tools instead of direct `Read` for `brain/` vault files.

**Why:** Large reference files (e.g., `architecture-patterns.md` at 40,718 tokens) waste context when only one section is needed. brain-mcp provides section-level retrieval (~320 tokens, 99% savings) and semantic search across all 128+ vault documents. CLAUDE.md, standard-workflow.md, and all 7 brain-reading agents have mandatory brain-mcp instructions.

**How to apply:**
- Use `brain_lookup(path, section)` instead of `Read` when you need a specific section of a brain doc
- Use `brain_lookup(path)` to get a section index before deciding what to read
- Use `brain_search(query)` to discover which docs are relevant to a topic
- Use `brain_context(query, token_budget)` for curated multi-doc context assembly
- Fall back to `Read` only for: files under 50 lines (current-state.md, session-log.md), writing/editing, or when the full file is genuinely needed
- After writing/editing brain files, call `brain_refresh()` to re-index
- All brain-mcp tools are deferred — use `ToolSearch` to load before first use
