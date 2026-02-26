#!/usr/bin/env bash
# migrate-to-obsidian.sh — Copy docs/agent-todos/ to an Obsidian vault and
# print the resulting config values for .claude/agent-todos.local.json.
#
# Usage: migrate-to-obsidian.sh <project_root> <vault_name> [project_name]
#
#   project_root  — Root of the project (default: $PWD)
#   vault_name_or_path — Absolute vault path (e.g. /Users/alice/Obsidian/vault) OR
#                        bare vault name to look up under iCloud Drive
#   project_name  — Subdirectory under agent-todos/ in the vault
#                   (default: basename of project_root)
#
# On success, prints to stdout:
#   todos_root=<full path>
#   vault_root=<full path>
#   kanban_file=<full path>
#
# Progress/errors are written to stderr.

set -euo pipefail

PROJECT_ROOT="${1:-$PWD}"
VAULT_NAME="${2:-}"
PROJECT_NAME="${3:-$(basename "$PROJECT_ROOT")}"

if [ -z "$VAULT_NAME" ]; then
  echo "Usage: migrate-to-obsidian.sh <project_root> <vault_name> [project_name]" >&2
  exit 1
fi

# macOS check
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Error: This script requires macOS." >&2
  exit 1
fi

# Resolve vault path: absolute path used directly, otherwise look up under iCloud Drive
if [[ "$VAULT_NAME" = /* ]]; then
  VAULT_PATH="$VAULT_NAME"
elif [[ "$VAULT_NAME" = ~* ]]; then
  VAULT_PATH="${VAULT_NAME/#\~/$HOME}"
else
  ICLOUD_OBSIDIAN_BASE="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
  VAULT_PATH="$ICLOUD_OBSIDIAN_BASE/$VAULT_NAME"
fi

if [ ! -d "$VAULT_PATH" ]; then
  echo "Error: Vault not found: $VAULT_PATH" >&2
  if [[ "$VAULT_NAME" != /* ]] && [[ "$VAULT_NAME" != ~* ]]; then
    ICLOUD_OBSIDIAN_BASE="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
    echo "Available vaults:" >&2
    ls "$ICLOUD_OBSIDIAN_BASE" >&2 2>/dev/null || true
  fi
  exit 1
fi

SOURCE_TODOS="$PROJECT_ROOT/docs/agent-todos"

if [ ! -d "$SOURCE_TODOS" ]; then
  echo "Error: Source todos directory not found: $SOURCE_TODOS" >&2
  exit 1
fi

DEST_TODOS="$VAULT_PATH/agent-todos/$PROJECT_NAME"
KANBAN_FILE="$VAULT_PATH/agent-todos/$PROJECT_NAME-kanban.md"

copied=0

for category_dir in "$SOURCE_TODOS"/*/; do
  [ -d "$category_dir" ] || continue
  category="$(basename "$category_dir")"
  dest_category="$DEST_TODOS/$category"
  mkdir -p "$dest_category"

  for src_file in "$category_dir"*.md; do
    [ -e "$src_file" ] || continue
    filename="$(basename "$src_file")"
    dest_file="$dest_category/$filename"
    cp "$src_file" "$dest_file"
    copied=$((copied + 1))
    echo "copied: $category/$filename" >&2
  done
done

echo "done: copied $copied file(s) to $DEST_TODOS" >&2

# Print config values to stdout (full paths, no tilde)
echo "todos_root=$DEST_TODOS"
echo "vault_root=$VAULT_PATH"
echo "kanban_file=$KANBAN_FILE"
