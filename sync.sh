#!/usr/bin/env bash
# workflow-engine sync script
# Downloads and syncs shared agents, workflow docs, and hooks from the
# deaconify/workflow-engine GitHub repo into the current project.
#
# Usage:
#   ./sync.sh              # Sync to latest from GitHub
#   ./sync.sh check        # Check if updates available (no changes)
#   ./sync.sh init         # Bootstrap a new project (interactive)
#   ./sync.sh --force      # Force sync even if up-to-date

set -euo pipefail

REPO="deaconify/workflow-engine"
VERSION_FILE=".workflow-version"
TEMP_DIR=$(mktemp -d)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

cleanup() {
  local exit_code=$?
  rm -rf "$TEMP_DIR"
  if [[ $exit_code -ne 0 ]]; then
    echo -e "${RED}[error]${NC} sync aborted (exit ${exit_code}) at line ${BASH_LINENO[0]:-?} — last command: ${BASH_COMMAND:-?}" >&2
    echo -e "${RED}[error]${NC} no files were updated. re-run with: bash -x $0" >&2
  fi
  exit $exit_code
}
trap cleanup EXIT

log() { echo -e "${GREEN}[sync]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }
error() { echo -e "${RED}[error]${NC} $1" >&2; }

# ─── Download latest release from GitHub ───────────────────────────────────
download_latest() {
  log "Downloading latest from ${REPO}..."

  # Download the default branch tarball
  if ! gh api "repos/${REPO}/tarball" > "$TEMP_DIR/archive.tar.gz" 2>/dev/null; then
    error "Failed to download from ${REPO}. Is gh authenticated?"
    exit 1
  fi

  # Extract
  mkdir -p "$TEMP_DIR/extracted"
  tar -xzf "$TEMP_DIR/archive.tar.gz" -C "$TEMP_DIR/extracted" --strip-components=1

  # Read remote version
  if [[ -f "$TEMP_DIR/extracted/VERSION" ]]; then
    REMOTE_VERSION=$(cat "$TEMP_DIR/extracted/VERSION" | tr -d '[:space:]')
  else
    error "VERSION file not found in downloaded archive"
    exit 1
  fi
}

# ─── Version comparison ───────────────────────────────────────────────────
get_local_version() {
  if [[ -f "$VERSION_FILE" ]]; then
    cat "$VERSION_FILE" | tr -d '[:space:]'
  else
    echo "0.0.0"
  fi
}

# ─── Contamination check ─────────────────────────────────────────────────
contamination_check() {
  local dir="$1"
  local found=0

  # Language-specific terms that should NOT appear in synced files
  local terms="npm run lint|npm run typecheck|npm run build|npm test|npx prettier|pip install|pytest|ruff|cargo|go test|dotnet|maven|gradle"

  log "Running contamination check..."

  while IFS= read -r file; do
    if grep -qEi "$terms" "$file" 2>/dev/null; then
      warn "Contamination found in $(basename "$file"):"
      grep -nEi "$terms" "$file" | head -3
      found=1
    fi
  done < <(find "$dir" -name "*.md" -type f 2>/dev/null)

  if [[ $found -eq 0 ]]; then
    log "Contamination check passed — no language-specific terms found"
  else
    warn "Some synced files contain language-specific terms. These should be generalized."
  fi
}

# ─── Synced file lists ────────────────────────────────────────────────────
# Files that are always overwritten during sync
SYNCED_AGENTS=(
  "issue-worker.md"
  "researcher.md"
  "requirements-planner.md"
  "reviewer.md"
  "validator.md"
  "github-updater.md"
  "obsidian-documenter.md"
  "drift-detector.md"
  "troubleshooter.md"
)

SYNCED_WORKFLOW_DOCS=(
  "standard-workflow.md"
  "workflow-summary.md"
  "planning-protocol.md"
  "github-standards.md"
  "compliance-agent-patterns.md"
)

# compliance-trigger-matrix.md is NOT synced — it's scaffolding only

# ─── SYNC (update) ───────────────────────────────────────────────────────
do_sync() {
  local force="${1:-}"

  download_latest

  local local_version
  local_version=$(get_local_version)

  if [[ "$local_version" == "$REMOTE_VERSION" && "$force" != "--force" ]]; then
    log "Already up to date (v${REMOTE_VERSION})"
    return 0
  fi

  log "Updating from v${local_version} to v${REMOTE_VERSION}..."

  # 1. Copy agents
  mkdir -p .claude/agents
  local agent_count=0
  for agent in "${SYNCED_AGENTS[@]}"; do
    if [[ -f "$TEMP_DIR/extracted/agents/$agent" ]]; then
      cp "$TEMP_DIR/extracted/agents/$agent" ".claude/agents/$agent"
      agent_count=$((agent_count + 1))
    else
      warn "Agent not found in archive: $agent"
    fi
  done
  log "Synced ${agent_count} agents to .claude/agents/"

  # 2. Copy workflow docs to brain/reference/
  mkdir -p brain/reference
  local doc_count=0
  for doc in "${SYNCED_WORKFLOW_DOCS[@]}"; do
    if [[ -f "$TEMP_DIR/extracted/workflow/$doc" ]]; then
      cp "$TEMP_DIR/extracted/workflow/$doc" "brain/reference/$doc"
      doc_count=$((doc_count + 1))
    else
      warn "Workflow doc not found in archive: $doc"
    fi
  done
  log "Synced ${doc_count} workflow docs to brain/reference/"

  # 3. Self-update the sync script
  if [[ -f "$TEMP_DIR/extracted/sync.sh" ]]; then
    mkdir -p .claude/hooks
    cp "$TEMP_DIR/extracted/sync.sh" ".claude/hooks/workflow-sync.sh"
    chmod +x ".claude/hooks/workflow-sync.sh"
    log "Sync script updated at .claude/hooks/workflow-sync.sh"
  fi

  # 3b. Refresh workflow hooks (overwrite — bug fixes must propagate)
  if [[ -d "$TEMP_DIR/extracted/scaffolding/hooks" ]]; then
    mkdir -p .claude/hooks
    for hook in "$TEMP_DIR/extracted/scaffolding/hooks"/*.sh; do
      [[ -f "$hook" ]] || continue
      cp "$hook" ".claude/hooks/$(basename "$hook")"
      chmod +x ".claude/hooks/$(basename "$hook")"
    done
    log "Workflow hooks refreshed in .claude/hooks/"
  fi

  # 4. Run contamination check on synced files
  contamination_check ".claude/agents"
  contamination_check "brain/reference"

  # 5. Update version file
  echo "$REMOTE_VERSION" > "$VERSION_FILE"

  log "Sync complete: v${local_version} → v${REMOTE_VERSION}"

  # 6. Show changelog if available
  if [[ -f "$TEMP_DIR/extracted/CHANGELOG.md" ]]; then
    echo ""
    echo -e "${CYAN}─── CHANGELOG ───${NC}"
    head -30 "$TEMP_DIR/extracted/CHANGELOG.md"
    echo -e "${CYAN}─────────────────${NC}"
  fi
}

# ─── CHECK (dry run) ─────────────────────────────────────────────────────
do_check() {
  download_latest

  local local_version
  local_version=$(get_local_version)

  if [[ "$local_version" == "$REMOTE_VERSION" ]]; then
    log "Up to date (v${REMOTE_VERSION})"
    return 0
  else
    warn "Update available: v${local_version} → v${REMOTE_VERSION}"
    return 1
  fi
}

# ─── INIT (bootstrap new project) ────────────────────────────────────────
do_init() {
  if [[ -f "$VERSION_FILE" ]]; then
    error "This project is already initialized (found ${VERSION_FILE})"
    error "Use './sync.sh' to update instead."
    exit 1
  fi

  download_latest

  echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║  Workflow Engine — New Project Setup (v${REMOTE_VERSION})     ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
  echo ""

  # 1. Create brain/ directory structure from scaffolding
  log "Creating brain/ directory structure..."
  mkdir -p brain/reference brain/capabilities brain/decisions brain/sessions \
           brain/discovery brain/compliance brain/planning brain/operations \
           brain/infrastructure brain/marketing brain/_templates

  # Copy scaffolding brain files
  if [[ -d "$TEMP_DIR/extracted/scaffolding/brain" ]]; then
    cp -r "$TEMP_DIR/extracted/scaffolding/brain/"* brain/ 2>/dev/null || true
  fi

  # 2. Copy project-context.example.md as starting point
  if [[ -f "$TEMP_DIR/extracted/scaffolding/project-context.example.md" ]]; then
    cp "$TEMP_DIR/extracted/scaffolding/project-context.example.md" \
       "brain/reference/project-context.md"
    log "Created brain/reference/project-context.md — EDIT THIS FILE with your project details"
  fi

  # 3. Copy agents
  mkdir -p .claude/agents
  for agent in "${SYNCED_AGENTS[@]}"; do
    if [[ -f "$TEMP_DIR/extracted/agents/$agent" ]]; then
      cp "$TEMP_DIR/extracted/agents/$agent" ".claude/agents/$agent"
    fi
  done
  log "Installed ${#SYNCED_AGENTS[@]} agents to .claude/agents/"

  # 4. Copy workflow docs
  for doc in "${SYNCED_WORKFLOW_DOCS[@]}"; do
    if [[ -f "$TEMP_DIR/extracted/workflow/$doc" ]]; then
      cp "$TEMP_DIR/extracted/workflow/$doc" "brain/reference/$doc"
    fi
  done
  log "Installed workflow docs to brain/reference/"

  # 5. Copy compliance-trigger-matrix (scaffolding — only on init)
  if [[ -f "$TEMP_DIR/extracted/workflow/compliance-trigger-matrix.md" ]]; then
    cp "$TEMP_DIR/extracted/workflow/compliance-trigger-matrix.md" \
       "brain/reference/compliance-trigger-matrix.md"
    log "Created brain/reference/compliance-trigger-matrix.md — customize for your project"
  fi

  # 6. Create CLAUDE.md from template
  if [[ -f "$TEMP_DIR/extracted/scaffolding/CLAUDE.md" ]]; then
    cp "$TEMP_DIR/extracted/scaffolding/CLAUDE.md" "CLAUDE.md"
    log "Created CLAUDE.md with @imports"
  fi

  # 7. Copy sync script to project hooks
  mkdir -p .claude/hooks
  cp "$TEMP_DIR/extracted/sync.sh" ".claude/hooks/workflow-sync.sh"
  chmod +x ".claude/hooks/workflow-sync.sh"
  log "Installed sync script at .claude/hooks/workflow-sync.sh"

  # 7b. Install workflow hooks (ird-gate, etc.)
  if [[ -d "$TEMP_DIR/extracted/scaffolding/hooks" ]]; then
    for hook in "$TEMP_DIR/extracted/scaffolding/hooks"/*.sh; do
      [[ -f "$hook" ]] || continue
      cp "$hook" ".claude/hooks/$(basename "$hook")"
      chmod +x ".claude/hooks/$(basename "$hook")"
    done
    log "Installed workflow hooks to .claude/hooks/"
  fi

  # 7c. Install hook config into .claude/settings.json (init-only; never overwrite)
  local snippet="$TEMP_DIR/extracted/scaffolding/hooks/settings.snippet.json"
  local settings=".claude/settings.json"
  if [[ -f "$snippet" ]]; then
    mkdir -p .claude
    if [[ ! -f "$settings" ]]; then
      if command -v jq >/dev/null 2>&1; then
        jq 'del(._comment)' "$snippet" > "$settings"
      else
        grep -v '"_comment"' "$snippet" > "$settings"
      fi
      log "Created $settings with ird-gate hook"
    elif ! grep -q "ird-gate.sh" "$settings"; then
      warn "$settings exists but does not reference ird-gate.sh — merge manually from .claude/hooks/settings.snippet.json"
      cp "$snippet" ".claude/hooks/settings.snippet.json"
    fi
  fi

  # 8. Set version file
  echo "$REMOTE_VERSION" > "$VERSION_FILE"

  # 9. Run contamination check
  contamination_check ".claude/agents"

  echo ""
  log "Initialization complete! Next steps:"
  echo ""
  echo "  1. Edit brain/reference/project-context.md with your project details"
  echo "  2. Edit brain/reference/compliance-trigger-matrix.md for your file patterns"
  echo "  3. Start a Claude Code session and test: 'Follow Standard Workflow - Issue #N'"
  echo ""
}

# ─── Main ─────────────────────────────────────────────────────────────────
case "${1:-}" in
  check)
    do_check
    ;;
  init)
    do_init
    ;;
  --force)
    do_sync "--force"
    ;;
  "")
    do_sync
    ;;
  *)
    echo "Usage: $0 [check|init|--force]"
    echo ""
    echo "  (no args)   Sync to latest from GitHub"
    echo "  check       Check if updates available (no changes)"
    echo "  init        Bootstrap a new project"
    echo "  --force     Force sync even if up-to-date"
    exit 1
    ;;
esac
