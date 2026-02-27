#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-$PWD}"

# ---------------------------------------------------------------------------
# Agent-todos config reader
# Reads .agent-todos.local.json and sets TODOS_ROOT, VAULT_ROOT, KANBAN_FILE
# ---------------------------------------------------------------------------
_read_json_key() {
  jq -r --arg key "$2" '.[$key] // empty' "$1" 2>/dev/null
}

read_agent_todos_config() {
  local config_file="$PROJECT_ROOT/.agent-todos.local.json"
  TODOS_ROOT="$PROJECT_ROOT/docs/agent-todos"
  VAULT_ROOT=""
  KANBAN_FILE=""
  [ -f "$config_file" ] || return 0
  local v
  v="$(_read_json_key "$config_file" todosRoot)";  [ -n "$v" ] && TODOS_ROOT="${v/#\~/$HOME}"
  v="$(_read_json_key "$config_file" vaultRoot)";  [ -n "$v" ] && VAULT_ROOT="${v/#\~/$HOME}"
  v="$(_read_json_key "$config_file" kanbanFile)"; [ -n "$v" ] && KANBAN_FILE="${v/#\~/$HOME}"
}

read_agent_todos_config
TODOS_DIR="$TODOS_ROOT"

if [ -z "$KANBAN_FILE" ]; then
  echo "No kanbanFile configured in .agent-todos.local.json — skipping overview generation." >&2
  echo "To enable the Kanban board, add \"kanbanFile\" to .agent-todos.local.json or run /todo-init." >&2
  exit 0
fi

if [ ! -d "$TODOS_DIR" ]; then
  echo "Error: todos directory does not exist: $TODOS_DIR" >&2
  exit 1
fi

tmpfile="$(mktemp)"
rowsfile="$(mktemp)"
trap 'rm -f "$tmpfile" "$rowsfile"' EXIT

extract_frontmatter_value() {
  local key="$1"
  local file="$2"
  awk -v target="$key" '
    BEGIN { in_frontmatter = 0 }
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { exit }
    in_frontmatter && $1 == target ":" {
      sub("^" target ":[[:space:]]*", "")
      gsub(/^"|"$/, "")
      gsub(/^\047|\047$/, "")
      print
      exit
    }
  ' "$file"
}

while IFS= read -r file; do
  category="$(basename "$(dirname "$file")")"
  filename="$(basename "$file")"

  title="$(extract_frontmatter_value "title" "$file")"
  status="$(extract_frontmatter_value "status" "$file")"

  if [ -z "$title" ]; then
    title="${filename%.md}"
    title="${title#DONE_}"
    title="${title#*_}"
    title="$(printf '%s' "$title" | tr '_-' '  ')"
  fi

  if [ -z "$status" ]; then
    if [[ "$filename" == DONE_* ]]; then
      status="done"
    else
      status="unknown"
    fi
  fi

  printf '%s\t%s\t%s\t%s\n' "$category" "$title" "$status" "$file" >> "$rowsfile"
done < <(find "$TODOS_DIR" -mindepth 2 -maxdepth 2 -type f -name '*.md' ! -name 'README.md' ! -name 'overview.md' ! -name 'TODO_OVERVIEW.md' | sort)

# ---------------------------------------------------------------------------
# Obsidian Kanban generation
# ---------------------------------------------------------------------------
obsidian_lane() {
  local lane_status="$1"
  local lane_label="$2"
  local checkbox="$3"
  printf '## %s\n' "$lane_label"
  while IFS=$'\t' read -r category title status full_path; do
    if [ "$status" = "$lane_status" ]; then
      local wiki_path esc_title
      if [ -n "$VAULT_ROOT" ]; then
        wiki_path="${full_path#"$VAULT_ROOT/"}"
      else
        wiki_path="${full_path#"$PROJECT_ROOT/"}"
      fi
      wiki_path="${wiki_path%.md}"
      esc_title="${title//|/\\|}"
      printf '%s [[%s|%s]]\n' "$checkbox" "$wiki_path" "$esc_title"
    fi
  done < "$rowsfile"
  printf '\n'
}

{
  printf -- '---\nkanban-plugin: board\n---\n\n'
  obsidian_lane "new"   "New"   "- [ ]"
  obsidian_lane "ready" "Ready" "- [ ]"
  obsidian_lane "doing" "Doing" "- [ ]"
  obsidian_lane "done"  "Done"  "- [x]"
  cat <<'KANBAN_EOF'
***

## Archive

%% kanban:settings
{"kanban-plugin":"board"}
%%
KANBAN_EOF
} > "$tmpfile"

# Ensure parent directory exists (KANBAN_FILE may be outside project root)
mkdir -p "$(dirname "$KANBAN_FILE")"

mv "$tmpfile" "$KANBAN_FILE"
echo "$KANBAN_FILE"
