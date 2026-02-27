#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-$PWD}"

# ---------------------------------------------------------------------------
# Agent-todos config reader
# Reads .agent-todos.local.json and sets TODOS_ROOT, VAULT_ROOT, KANBAN_FILE
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
  local config_file="$PROJECT_ROOT/.agent-todos.local.json"
  TODOS_ROOT="$PROJECT_ROOT/docs/agent-todos"
  VAULT_ROOT=""
  KANBAN_FILE=""
  [ -f "$config_file" ] || return 0
  local v
  v="$(_read_json_key "$config_file" todosRoot)";  [ -n "$v" ] && TODOS_ROOT="${v/#\~/$HOME}"
  v="$(_read_json_key "$config_file" vaultRoot)";  [ -n "$v" ] && VAULT_ROOT="${v/#\~/$HOME}"
  v="$(_read_json_key "$config_file" kanbanFile)"; [ -n "$v" ] && KANBAN_FILE="${v/#\~/$HOME}"
  if [ -z "$KANBAN_FILE" ] && [ "$TODOS_ROOT" != "$PROJECT_ROOT/docs/agent-todos" ]; then
    KANBAN_FILE="$(dirname "$TODOS_ROOT")/$(basename "$TODOS_ROOT")-kanban.md"
  fi
}

read_agent_todos_config
TODOS_DIR="$TODOS_ROOT"

if [ -n "$KANBAN_FILE" ]; then
  OUTPUT_FILE="$KANBAN_FILE"
else
  OUTPUT_FILE="$TODOS_DIR/TODO_OVERVIEW.md"
fi

if [ ! -d "$TODOS_DIR" ]; then
  echo "Error: $TODOS_DIR does not exist" >&2
  exit 1
fi

tmpfile="$(mktemp)"
rowsfile="$(mktemp)"
kanbanfile="$(mktemp)"
trap 'rm -f "$tmpfile" "$rowsfile" "$kanbanfile"' EXIT

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
  rel_path="/${file#"$PROJECT_ROOT"/}"
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

  todo_base="${filename%.md}"
  todo_base="${todo_base#DONE_}"
  if [[ "$todo_base" =~ ^([0-9]{4}) ]]; then
    number="${BASH_REMATCH[1]}"
    ticket="$category-$number"
  else
    ticket=""
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$category" "$title" "$status" "$rel_path" "$ticket" "$file" >> "$rowsfile"
done < <(find "$TODOS_DIR" -mindepth 2 -maxdepth 2 -type f -name '*.md' ! -name 'README.md' ! -name 'overview.md' ! -name 'TODO_OVERVIEW.md' | sort)

# ---------------------------------------------------------------------------
# Obsidian Kanban generation
# ---------------------------------------------------------------------------
obsidian_lane() {
  local lane_status="$1"
  local lane_label="$2"
  local checkbox="$3"
  printf '## %s\n' "$lane_label"
  while IFS=$'\t' read -r category title status rel_path ticket full_path; do
    if [ "$status" = "$lane_status" ]; then
      local wiki_path esc_title
      if [ -n "$VAULT_ROOT" ]; then
        wiki_path="${full_path#"$VAULT_ROOT/"}"
      else
        wiki_path="${rel_path#/}"
      fi
      wiki_path="${wiki_path%.md}"
      esc_title="${title//|/\\|}"
      printf '%s [[%s|%s]]\n' "$checkbox" "$wiki_path" "$esc_title"
    fi
  done < "$rowsfile"
  printf '\n'
}

generate_obsidian_kanban() {
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
}

# ---------------------------------------------------------------------------
# Mermaid Kanban generation (default)
# ---------------------------------------------------------------------------
append_lane() {
  local lane="$1"
  local lane_label="$2"
  local has_lane_rows=0

  printf '  %s[%s]\n' "$lane" "$lane_label" >> "$kanbanfile"
  while IFS=$'\t' read -r category title status rel_path ticket full_path; do
    if [ "$status" = "$lane" ] && [ -n "$ticket" ]; then
      has_lane_rows=1
      esc_title="${title//]/\\]}"
      printf '    %s[%s]@{ ticket: %s }\n' "$ticket" "$esc_title" "$ticket" >> "$kanbanfile"
    fi
  done < "$rowsfile"

  if [ "$has_lane_rows" -eq 0 ]; then
    echo >> "$kanbanfile"
  fi
}

has_rows=0
while IFS=$'\t' read -r _ _ _ _ _ _; do
  has_rows=1
  break
done < "$rowsfile"

if [ -n "$KANBAN_FILE" ]; then
  # Obsidian Kanban format
  generate_obsidian_kanban > "$tmpfile"
else
  # Mermaid format
  {
    echo "# Todo Overview"
    echo
    echo "Generated on $(date '+%F %H:%M:%S %Z')."

    echo
    echo "## Todo Kanban"
    echo

    if [ "$has_rows" -eq 0 ]; then
      echo "_No todos available for visualization._"
    else
      : > "$kanbanfile"
      echo '```mermaid' >> "$kanbanfile"
      echo "%%{init: {\"theme\":\"neutral\"}}%%" >> "$kanbanfile"
      echo "kanban" >> "$kanbanfile"
      append_lane "new" "New"
      append_lane "ready" "Ready"
      append_lane "doing" "Doing"
      append_lane "done" "Done"
      echo '```' >> "$kanbanfile"

      cat "$kanbanfile"
    fi

    echo
    echo "## Todo List"
    echo
    echo "| category | todo | status |"
    echo "| --- | --- | --- |"

    if [ "$has_rows" -eq 0 ]; then
      echo "| - | - | - |"
    else
      while IFS=$'\t' read -r category title status rel_path ticket full_path; do
        esc_title="${title//|/\\|}"
        esc_category="${category//|/\\|}"
        esc_status="${status//|/\\|}"

        echo "| $esc_category | [$esc_title]($rel_path) | $esc_status |"
      done < "$rowsfile"
    fi
  } > "$tmpfile"
fi

# Ensure parent directory exists (KANBAN_FILE may be outside project root)
mkdir -p "$(dirname "$OUTPUT_FILE")"

mv "$tmpfile" "$OUTPUT_FILE"
echo "$OUTPUT_FILE"
