#!/usr/bin/env bash
# import-obsidian-todos.sh — Retrieve agent todo files from an Obsidian vault on iCloud Drive.
#
# Usage:
#   import-obsidian-todos.sh --check-platform
#       Exit 0 on macOS, exit 1 otherwise.
#
#   import-obsidian-todos.sh --list-vaults
#       List available Obsidian vault names on iCloud Drive.
#
#   import-obsidian-todos.sh --list-categories <vaultname>
#       List category subdirectories under <vaultname>/agent-todos/.
#
#   import-obsidian-todos.sh --list <vaultname> <category>
#       List open (non-DONE_) markdown files in <vaultname>/agent-todos/<category>/.
#
#   import-obsidian-todos.sh --delete <vaultname> <category> <filename>
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
    die "This script only works on macOS (detected: $(uname -s))."
  fi
}

vault_path() {
  local vault="$1"
  echo "$ICLOUD_OBSIDIAN_BASE/$vault"
}

todos_path() {
  local vault="$1"
  local category="$2"
  echo "$ICLOUD_OBSIDIAN_BASE/$vault/agent-todos/$category"
}

# --- Commands ---

cmd_check_platform() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Platform OK: macOS"
    exit 0
  else
    echo "Unsupported platform: $(uname -s)" >&2
    exit 1
  fi
}

cmd_list_vaults() {
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
  require_macos

  local vault="${1:?Usage: import-obsidian-todos.sh --list-categories <vaultname>}"
  local vpath
  vpath="$(vault_path "$vault")"

  if [[ ! -d "$vpath" ]]; then
    die "Vault not found: $vpath"
  fi

  local agent_todos_dir="$vpath/agent-todos"
  if [[ ! -d "$agent_todos_dir" ]]; then
    die "No agent-todos directory in vault '$vault'. Expected: $agent_todos_dir"
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
  require_macos

  local vault="${1:?Usage: import-obsidian-todos.sh --list <vaultname> <category>}"
  local category="${2:?Usage: import-obsidian-todos.sh --list <vaultname> <category>}"
  local tpath
  tpath="$(todos_path "$vault" "$category")"

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
  require_macos

  local vault="${1:?Usage: import-obsidian-todos.sh --delete <vaultname> <category> <filename>}"
  local category="${2:?Usage: import-obsidian-todos.sh --delete <vaultname> <category> <filename>}"
  local filename="${3:?Usage: import-obsidian-todos.sh --delete <vaultname> <category> <filename>}"
  local tpath
  tpath="$(todos_path "$vault" "$category")"
  local filepath="$tpath/$filename"

  if [[ ! -f "$filepath" ]]; then
    die "File not found: $filepath"
  fi

  # Move to Trash instead of permanent delete
  mv "$filepath" "$HOME/.Trash/"
  echo "Moved to Trash: $filename"
}

# --- Main ---

if [[ $# -lt 1 ]]; then
  echo "Usage: import-obsidian-todos.sh <command> [args...]" >&2
  echo "" >&2
  echo "Commands:" >&2
  echo "  --check-platform                          Check if running on macOS" >&2
  echo "  --list-vaults                             List Obsidian vaults" >&2
  echo "  --list-categories <vault>                 List categories in vault" >&2
  echo "  --list <vault> <category>                 List open todos" >&2
  echo "  --delete <vault> <category> <filename>    Move file to Trash" >&2
  exit 1
fi

COMMAND="$1"
shift

case "$COMMAND" in
  --check-platform)   cmd_check_platform ;;
  --list-vaults)      cmd_list_vaults ;;
  --list-categories)  cmd_list_categories "$@" ;;
  --list)             cmd_list "$@" ;;
  --delete)           cmd_delete "$@" ;;
  *)                  die "Unknown command: $COMMAND" ;;
esac
