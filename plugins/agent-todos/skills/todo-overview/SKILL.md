---
name: todo-overview
description: This skill should be used when the user asks to "create todo overview", "update todo overview", "generate TODO_OVERVIEW.md", "list all todos by status", "show todo table", or wants a markdown table overview for docs/agent-todos.
allowed-tools: Bash, Read, Write, Edit
invocation: user
---

# todo-overview

Create or update `docs/agent-todos/TODO_OVERVIEW.md` with a markdown table of all todo files.

## Output Format

Write a table with exactly these columns:

- `category`
- `todo`
- `status`

Each row should represent one todo file from category subdirectories under `docs/agent-todos/`.

## Workflow

1. Verify `docs/agent-todos/` exists.
2. Run the bundled script:

```bash
bash <base_directory>/scripts/update-overview.sh "<project_root>"
```

Where:

- `<base_directory>` is the path shown in "Base directory for this skill:" at invocation time.
- `<project_root>` is the current project root.

3. Confirm the generated file path from script output.
4. Optionally read `docs/agent-todos/TODO_OVERVIEW.md` to verify rows and status values.

## Notes

- Include both open and completed todos.
- Exclude `docs/agent-todos/README.md` and `docs/agent-todos/TODO_OVERVIEW.md` from the row scan.
- Preserve status values from YAML frontmatter when present.
- Infer `status: done` for `DONE_` files that lack frontmatter.
