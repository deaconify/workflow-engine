---
name: feedback_commit_to_main
description: All development work must be committed directly to main branch — no feature branches. Project is pre-MVP.
type: feedback
---

Always commit directly to the `main` branch. Do NOT create feature branches for issue work.

**Why:** The project is pre-MVP with a single developer. Feature branches add unnecessary overhead. The issue-worker agent should not create branches either.

**How to apply:** When starting issue work, ensure you're on `main`. When committing, commit to `main`. If a subagent (like issue-worker) creates a feature branch, fast-forward merge it back to main and delete the branch before presenting to the user.
