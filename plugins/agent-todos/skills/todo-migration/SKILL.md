---
name: todo-migration
description: This skill should be used when the user asks to "migrate agent todos", "rename docs/agents-todos", "change todo file prefixes to 4 digits", "upgrade todo naming", or "run a todo migration" for existing projects.
allowed-tools: Bash, Read, Write, AskUserQuestion
invocation: user
---

# todo-migration

Migrate existing projects to the 4-digit todo naming scheme and the canonical `docs/agent-todos/` folder.

## Workflow

1. Check for legacy folder name:
   - If `docs/agents-todos/` exists and `docs/agent-todos/` does not, rename the folder.
   - If both exist, ask how to merge and stop until a decision is provided.
   - If only `docs/agent-todos/` exists, continue.

2. Rename todo files to 4-digit prefixes:
   - Update open todo files from `NNN_` to `NNNN_`.
   - Update completed todo files from `DONE_NNN_` to `DONE_NNNN_`.
   - Apply the same prefix change to supporting files that share the numeric prefix.

3. Verify the results:
   - List remaining 3-digit files and confirm none remain.
   - Summarize what was renamed.

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
```

## Notes

- Prefer asking before overwriting when name collisions occur.
- Keep supporting files (CSV, JSON, images) in sync with their todo file prefix.
- Avoid renaming files that already use 4-digit prefixes.
