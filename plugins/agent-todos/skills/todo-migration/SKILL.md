---
name: todo-migration
description: This skill should be used when the user asks to "migrate agent todos", "rename docs/agents-todos", "change todo file prefixes to 4 digits", "add frontmatter to todos", "upgrade todo naming", or "run a todo migration" for existing projects.
allowed-tools: Bash, Read, Write, AskUserQuestion
invocation: user
---

# todo-migration

Migrate existing projects to the 4-digit todo naming scheme, add YAML frontmatter, and use the canonical `docs/agent-todos/` folder.

## Workflow

1. Check for legacy folder name:
   - If `docs/agents-todos/` exists and `docs/agent-todos/` does not, rename the folder.
   - If both exist, ask how to merge and stop until a decision is provided.
   - If only `docs/agent-todos/` exists, continue.

2. Rename todo files to 4-digit prefixes:
   - Update open todo files from `NNN_` to `NNNN_`.
   - Update completed todo files from `DONE_NNN_` to `DONE_NNNN_`.
   - Apply the same prefix change to supporting files that share the numeric prefix.

3. Add YAML frontmatter to files that lack it:
   - Scan all `.md` files in `docs/agent-todos/` subdirectories (exclude README files).
   - Skip files that already start with `---` (they already have frontmatter).
   - Derive the `title` from the filename:
     1. Strip `DONE_` prefix if present
     2. Strip the numeric prefix (e.g. `0001_`)
     3. Strip the `.md` extension
     4. Replace hyphens and underscores with spaces
     5. Capitalize the first letter
   - Determine the `status`:
     - If filename starts with `DONE_` → `done`
     - If file has meaningful content (beyond just a heading) → `ready`
     - If file is empty or minimal → `new`
   - Prepend the frontmatter block (`---\ntitle: ...\nstatus: ...\n---\n\n`) to the file.

4. Verify the results:
   - List remaining 3-digit files and confirm none remain.
   - List any `.md` files (excluding READMEs) that still lack frontmatter.
   - Summarize what was renamed and what frontmatter was added.

## Suggested Commands

```bash
# Rename legacy folder name if needed
if [ -d docs/agents-todos ] && [ ! -d docs/agent-todos ]; then
  mv docs/agents-todos docs/agent-todos
fi

# Rename DONE_ prefixed files first
find docs/agent-todos -type f -name 'DONE_[0-9][0-9][0-9]_*' -print0 | \
  while IFS= read -r -d '' file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    tail=${base#DONE_}
    num=${tail%%_*}
    rest=${tail#*_}
    mv "$file" "$dir/DONE_0${num}_${rest}"
  done

# Rename non-DONE files
find docs/agent-todos -type f -name '[0-9][0-9][0-9]_*' -print0 | \
  while IFS= read -r -d '' file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    num=${base%%_*}
    rest=${base#*_}
    mv "$file" "$dir/0${num}_${rest}"
  done

# Verify no 3-digit prefixes remain
find docs/agent-todos -type f \( -name '[0-9][0-9][0-9]_*' -o -name 'DONE_[0-9][0-9][0-9]_*' \)

# Add frontmatter to .md files that lack it
find docs/agent-todos -type f -name '*.md' ! -iname 'README*' -print0 | \
  while IFS= read -r -d '' file; do
    # Skip files that already have frontmatter
    head -1 "$file" | grep -q '^---$' && continue

    base=$(basename "$file" .md)
    # Strip DONE_ prefix for title derivation
    title_base=${base#DONE_}
    # Strip numeric prefix (e.g. 0001_)
    title_base=$(echo "$title_base" | sed 's/^[0-9]*_//')
    # Replace hyphens and underscores with spaces, capitalize first letter
    title=$(echo "$title_base" | tr '_-' '  ' | sed 's/^./\U&/')

    # Determine status
    if echo "$base" | grep -q '^DONE_'; then
      status="done"
    elif [ -s "$file" ]; then
      status="ready"
    else
      status="new"
    fi

    # Prepend frontmatter
    tmpfile=$(mktemp)
    printf '%s\n' "---" "title: $title" "status: $status" "---" "" | cat - "$file" > "$tmpfile"
    mv "$tmpfile" "$file"
  done

# Verify all todo .md files have frontmatter
find docs/agent-todos -type f -name '*.md' ! -iname 'README*' -exec sh -c \
  'head -1 "$1" | grep -q "^---$" || echo "Missing frontmatter: $1"' _ {} \;
```

## Notes

- Prefer asking before overwriting when name collisions occur.
- Keep supporting files (CSV, JSON, images) in sync with their todo file prefix.
- Avoid renaming files that already use 4-digit prefixes.
