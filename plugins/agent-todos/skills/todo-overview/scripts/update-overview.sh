#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-$PWD}"
TODOS_DIR="$PROJECT_ROOT/docs/agent-todos"
OUTPUT_FILE="$TODOS_DIR/TODO_OVERVIEW.md"

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
  rel_path="${file#"$PROJECT_ROOT"/}"
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

  printf '%s\t%s\t%s\t%s\t%s\n' "$category" "$title" "$status" "$rel_path" "$ticket" >> "$rowsfile"
done < <(find "$TODOS_DIR" -mindepth 2 -maxdepth 2 -type f -name '*.md' ! -name 'README.md' ! -name 'overview.md' ! -name 'TODO_OVERVIEW.md' | sort)

append_lane() {
  local lane="$1"
  local lane_label="$2"
  local has_lane_rows=0

  printf '  %s[%s]\n' "$lane" "$lane_label" >> "$kanbanfile"
  while IFS=$'\t' read -r category title status rel_path ticket; do
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

{
  echo "# Todo Overview"
  echo
  echo "Generated on $(date '+%F %H:%M:%S %Z')."
  echo
  echo "| category | todo | status |"
  echo "| --- | --- | --- |"

  has_rows=0

  while IFS=$'\t' read -r category title status rel_path ticket; do
    has_rows=1
    esc_title="${title//|/\\|}"
    esc_category="${category//|/\\|}"
    esc_status="${status//|/\\|}"

    echo "| $esc_category | [$esc_title]($rel_path) | $esc_status |"
  done < "$rowsfile"

  if [ "$has_rows" -eq 0 ]; then
    echo "| - | - | - |"
    echo
    echo "## Todo Kanban"
    echo
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

    echo
    echo "## Todo Kanban"
    echo
    cat "$kanbanfile"
  fi
} > "$tmpfile"

mv "$tmpfile" "$OUTPUT_FILE"
echo "$OUTPUT_FILE"
