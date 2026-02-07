#!/usr/bin/env bash
# create-todo.sh — Create a new todo file with frontmatter and sequential numbering.
#
# Usage: create-todo.sh <category> <title> [base-dir]
#
#   category  — Subdirectory name under docs/agent-todos/ (created if missing)
#   title     — Human-readable title for the todo
#   base-dir  — Project root (defaults to $PWD)
#
# The script:
#   1. Scans all files (open and DONE_) in the category to find the highest number
#   2. Generates the next 4-digit prefix
#   3. Converts the title to snake_case, truncated to 60 characters
#   4. Creates the file with YAML frontmatter (title, status: new) and an H1 heading

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: create-todo.sh <category> <title> [base-dir]" >&2
  exit 1
fi

CATEGORY="$1"
TITLE="$2"
BASE_DIR="${3:-$PWD}"
TODO_DIR="$BASE_DIR/docs/agent-todos/$CATEGORY"

# Create category directory if it does not exist
mkdir -p "$TODO_DIR"

# Find the highest numeric prefix across all files in the category.
# Matches patterns: NNNN_*, DONE_NNNN_*
MAX_NUM=0
for file in "$TODO_DIR"/*; do
  [ -e "$file" ] || continue
  base=$(basename "$file")
  # Strip DONE_ prefix if present
  stripped=${base#DONE_}
  # Extract leading digits
  num=${stripped%%[!0-9]*}
  if [ -n "$num" ]; then
    # Remove leading zeros for arithmetic
    num_val=$((10#$num))
    if [ "$num_val" -gt "$MAX_NUM" ]; then
      MAX_NUM=$num_val
    fi
  fi
done

NEXT_NUM=$((MAX_NUM + 1))
PREFIX=$(printf "%04d" "$NEXT_NUM")

# Convert title to snake_case filename
SNAKE=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_//;s/_$//')

# Truncate to 60 characters
SNAKE=$(echo "$SNAKE" | cut -c1-60 | sed 's/_$//')

FILENAME="${PREFIX}_${SNAKE}.md"
FILEPATH="$TODO_DIR/$FILENAME"

# Escape single quotes in title for YAML single-quoted scalar
YAML_TITLE=$(printf '%s' "$TITLE" | sed "s/'/''/g")

# Write the file
cat > "$FILEPATH" <<EOF
---
title: '${YAML_TITLE}'
status: new
---

## Context

## Tasks

EOF

echo "$FILEPATH"
