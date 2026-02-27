---
name: todo-overview
description: >
  This skill should be used when the user asks to "create todo overview", "update
  todo overview", "generate TODO_OVERVIEW.md", "list all todos by status", "show
  todo table", "update kanban board", or wants a markdown table or Obsidian Kanban
  overview for the configured todos directory (default: docs/agent-todos).
allowed-tools: Bash, Read, Write, Edit
invocation: user
---

# todo-overview

Generate or update the todo overview from the configured todos directory (default: `docs/agent-todos/`).

**Default mode** — generates `TODO_OVERVIEW.md` with a Mermaid Kanban and a markdown table.

**Obsidian mode** (when `.agent-todos.local.json` sets `kanban_file`) — generates an Obsidian Kanban board file at the `kanban_file` path instead.

## Output Format

### Default mode

Writes sections in this order:

1. `## Todo Kanban` with lanes `new`, `ready`, `doing`, and `done` (Mermaid)
2. `## Todo List` table with columns `category`, `todo`, `status`

### Obsidian mode

Generates an Obsidian Kanban plugin board file with columns New, Ready, Doing, Done. DONE_ files appear as `- [x]` checked cards in the Done column.

## Workflow

1. Run the bundled script:

```bash
bash <base_directory>/scripts/update-overview.sh "<project_root>"
```

Where:

- `<base_directory>` is the path shown in "Base directory for this skill:" at invocation time.
- `<project_root>` is the current project root.

2. Confirm the generated file path from script output.
3. Optionally read the output file to verify Kanban and status values.

## Notes

- Reads `.agent-todos.local.json` to determine todos directory and output format.
- Include both open and completed todos.
- Preserve status values from YAML frontmatter when present.
- Infer `status: done` for `DONE_` files that lack frontmatter.
- In default mode, generate todo links with a leading slash (`/docs/...`) so links resolve correctly on GitHub.
