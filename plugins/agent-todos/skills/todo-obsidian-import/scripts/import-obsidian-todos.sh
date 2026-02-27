#!/usr/bin/env bash
# import-obsidian-todos.sh — Retrieve agent todo files from an Obsidian vault.
#
# Reads vault path from .agent-todos.local.json (vaultRoot) when available.
# Falls back to iCloud Drive discovery on macOS when no config is set.
#
# Usage:
#   import-obsidian-todos.sh --get-vault-path <project_root>
#       Print the configured vaultRoot (expanded) or empty string.
#
#   import-obsidian-todos.sh --list-vaults [project_root]
#       If vaultRoot is configured: print it.
#       If not configured: requires macOS; list vault names from iCloud Drive.
#
#   import-obsidian-todos.sh --list-categories <vault_path>
#       List category subdirectories under <vault_path>/agent-todos/.
#
#   import-obsidian-todos.sh --list <vault_path> <category>
#       List open (non-DONE_) markdown files in <vault_path>/agent-todos/<category>/.
#
#   import-obsidian-todos.sh --delete <vault_path> <category> <filename>
#       Move a single file from the vault to ~/.Trash/ (safe delete).

set -euo pipefail

ICLOUD_OBSIDIAN_BASE="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"

# --- Helpers ---

die() {
  echo "Error: $*" >&2
  exit 1
}

require_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    die "This command only works on macOS (detected: $(uname -s)). Set vaultRoot in .agent-todos.local.json to use a custom vault path."
  fi
}

# Accept absolute path or vault name relative to iCloud base
vault_path() {
  local vault="$1"
  if [[ "$vault" == /* ]]; then
    echo "$vault"
  else
    echo "$ICLOUD_OBSIDIAN_BASE/$vault"
  fi
}

todos_path() {
  local vpath="$1"
  local category="$2"
  echo "$vpath/agent-todos/$category"
}

# ---------------------------------------------------------------------------
# Agent-todos config reader
# Reads .agent-todos.local.json and sets VAULT_ROOT
# ---------------------------------------------------------------------------
_read_json_key() {
  python3 - "$1" "$2" <<'PYEOF' 2>/dev/null
import json, sys
try:
    d = json.load(open(sys.argv[1]))
    v = d.get(sys.argv[2])
    if v is not None:
        print(v)
except Exception:
    pass
PYEOF
}

read_agent_todos_config() {
  local project_root="$1"
  local config_file="$project_root/.agent-todos.local.json"
  VAULT_ROOT=""
  [ -f "$config_file" ] || return 0
  local v
  v="$(_read_json_key "$config_file" vaultRoot)"; [ -n "$v" ] && VAULT_ROOT="${v/#\~/$HOME}"
}

# --- Commands ---

cmd_get_vault_path() {
  local project_root="${1:?Usage: import-obsidian-todos.sh --get-vault-path <project_root>}"
  read_agent_todos_config "$project_root"
  echo "$VAULT_ROOT"
}

cmd_list_vaults() {
  local project_root="${1:-$PWD}"
  read_agent_todos_config "$project_root"

  if [[ -n "$VAULT_ROOT" ]]; then
    echo "$VAULT_ROOT"
    return 0
  fi

  # No config — fall back to iCloud listing (macOS only)
  require_macos

  if [[ ! -d "$ICLOUD_OBSIDIAN_BASE" ]]; then
    die "Obsidian iCloud directory not found at: $ICLOUD_OBSIDIAN_BASE"
  fi

  local found=0
  for dir in "$ICLOUD_OBSIDIAN_BASE"/*/; do
    [[ -d "$dir" ]] || continue
    basename "$dir"
    found=1
  done

  if [[ $found -eq 0 ]]; then
    echo "No Obsidian vaults found." >&2
    exit 1
  fi
}

cmd_list_categories() {
  local vault="${1:?Usage: import-obsidian-todos.sh --list-categories <vault_path>}"
  local vpath
  vpath="$(vault_path "$vault")"

  if [[ ! -d "$vpath" ]]; then
    die "Vault not found: $vpath"
  fi

  local agent_todos_dir="$vpath/agent-todos"
  if [[ ! -d "$agent_todos_dir" ]]; then
    die "No agent-todos directory in vault. Expected: $agent_todos_dir"
  fi

  local found=0
  for dir in "$agent_todos_dir"/*/; do
    [[ -d "$dir" ]] || continue
    basename "$dir"
    found=1
  done

  if [[ $found -eq 0 ]]; then
    echo "No categories found in $agent_todos_dir" >&2
    exit 1
  fi
}

cmd_list() {
  local vault="${1:?Usage: import-obsidian-todos.sh --list <vault_path> <category>}"
  local category="${2:?Usage: import-obsidian-todos.sh --list <vault_path> <category>}"
  local vpath
  vpath="$(vault_path "$vault")"
  local tpath
  tpath="$(todos_path "$vpath" "$category")"

  if [[ ! -d "$tpath" ]]; then
    die "Directory not found: $tpath"
  fi

  local found=0
  for file in "$tpath"/*.md; do
    [[ -f "$file" ]] || continue
    local base
    base=$(basename "$file")
    # Skip DONE_ files
    if [[ "$base" == DONE_* ]]; then
      continue
    fi
    echo "$file"
    found=1
  done

  if [[ $found -eq 0 ]]; then
    echo "No open todo files found in: $tpath" >&2
    exit 1
  fi
}

cmd_delete() {
  local vault="${1:?Usage: import-obsidian-todos.sh --delete <vault_path> <category> <filename>}"
  local category="${2:?Usage: import-obsidian-todos.sh --delete <vault_path> <category> <filename>}"
  local filename="${3:?Usage: import-obsidian-todos.sh --delete <vault_path> <category> <filename>}"
  local vpath
  vpath="$(vault_path "$vault")"
  local tpath
  tpath="$(todos_path "$vpath" "$category")"
  local filepath="$tpath/$filename"

  if [[ ! -f "$filepath" ]]; then
    die "File not found: $filepath"
  fi

  # Move to Trash instead of permanent delete; create Trash dir if it does not exist
  mkdir -p "$HOME/.Trash"
  mv "$filepath" "$HOME/.Trash/"
  echo "Moved to Trash: $filename"
}

# --- Main ---

if [[ $# -lt 1 ]]; then
  echo "Usage: import-obsidian-todos.sh <command> [args...]" >&2
  echo "" >&2
  echo "Commands:" >&2
  echo "  --get-vault-path <project_root>               Print configured vaultRoot or empty" >&2
  echo "  --list-vaults [project_root]                  List vaults (config or iCloud)" >&2
  echo "  --list-categories <vault_path>                List categories in vault" >&2
  echo "  --list <vault_path> <category>                List open todos" >&2
  echo "  --delete <vault_path> <category> <filename>   Move file to Trash" >&2
  exit 1
fi

COMMAND="$1"
shift

case "$COMMAND" in
  --get-vault-path)   cmd_get_vault_path "$@" ;;
  --list-vaults)      cmd_list_vaults "$@" ;;
  --list-categories)  cmd_list_categories "$@" ;;
  --list)             cmd_list "$@" ;;
  --delete)           cmd_delete "$@" ;;
  *)                  die "Unknown command: $COMMAND" ;;
esac
