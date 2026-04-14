#!/usr/bin/env bash
# PreToolUse gate: blocks Edit/Write/MultiEdit on implementation files while
# an IRD is pending persistence. Step 2 (requirements-planner) creates a
# sentinel at brain/sessions/.ird-pending-{issue}. Step 2b removes it only
# after BOTH (a) brain/sessions/ird-{issue}.md exists AND (b) the full IRD
# has been posted as a GitHub comment on the issue.
#
# Input: JSON on stdin with {tool_name, tool_input:{file_path}}.
# Exit 0 = allow. Exit 2 = block with message on stderr.

set -u

input="$(cat)"
tool_name="$(printf '%s' "$input" | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"

case "$tool_name" in
  Edit|Write|MultiEdit|NotebookEdit) ;;
  *) exit 0 ;;
esac

# Find any pending sentinel
shopt -s nullglob
sentinels=(brain/sessions/.ird-pending-*)
[[ ${#sentinels[@]} -eq 0 ]] && exit 0

file_path="$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"

# Allow writes inside brain/sessions/, brain/decisions/, brain/discovery/, .claude/, and top-level git/meta paths
case "$file_path" in
  */brain/sessions/*|*/brain/decisions/*|*/brain/discovery/*|*/.claude/*|*/.github/*) exit 0 ;;
  brain/sessions/*|brain/decisions/*|brain/discovery/*|.claude/*|.github/*) exit 0 ;;
esac

issue="${sentinels[0]##*.ird-pending-}"
cat >&2 <<EOF
[ird-gate] Blocked: IRD for issue #${issue} has not been persisted.

Before editing implementation files, complete Step 2b persistence:
  1. Write brain/sessions/ird-${issue}.md with the approved IRD
  2. Post the FULL IRD as a GitHub comment: gh issue comment ${issue} --body-file ...
  3. Remove the sentinel: rm brain/sessions/.ird-pending-${issue}

See brain/reference/standard-workflow.md Step 2b.
EOF
exit 2
