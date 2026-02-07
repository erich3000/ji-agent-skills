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

{
  echo "# Todo Overview"
  echo
  echo "Generated on $(date '+%F %H:%M:%S %Z')."
  echo
  echo "| category | todo | status |"
  echo "| --- | --- | --- |"

  has_rows=0

  while IFS= read -r file; do
    has_rows=1
    rel_path="${file#"$PROJECT_ROOT"/}"
    category="$(basename "$(dirname "$file")")"
    filename="$(basename "$file")"

    title="$(awk '
      BEGIN { in_frontmatter = 0 }
      NR == 1 && $0 == "---" { in_frontmatter = 1; next }
      in_frontmatter && $0 == "---" { exit }
      in_frontmatter && $1 == "title:" {
        sub(/^title:[[:space:]]*/, "")
        gsub(/^"|"$/, "")
        gsub(/^\047|\047$/, "")
        print
        exit
      }
    ' "$file")"

    status="$(awk '
      BEGIN { in_frontmatter = 0 }
      NR == 1 && $0 == "---" { in_frontmatter = 1; next }
      in_frontmatter && $0 == "---" { exit }
      in_frontmatter && $1 == "status:" {
        sub(/^status:[[:space:]]*/, "")
        gsub(/^"|"$/, "")
        gsub(/^\047|\047$/, "")
        print
        exit
      }
    ' "$file")"

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

    esc_title="${title//|/\\|}"
    esc_category="${category//|/\\|}"
    esc_status="${status//|/\\|}"

    echo "| $esc_category | [$esc_title]($rel_path) | $esc_status |"
  done < <(find "$TODOS_DIR" -mindepth 2 -maxdepth 2 -type f -name '*.md' ! -name 'README.md' ! -name 'overview.md' ! -name 'TODO_OVERVIEW.md' | sort)

  if [ "$has_rows" -eq 0 ]; then
    echo "| - | - | - |"
  fi
} > "$tmpfile"

mv "$tmpfile" "$OUTPUT_FILE"
echo "$OUTPUT_FILE"
