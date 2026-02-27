---
name: todo-overview
description: >
  This skill should be used when the user asks to "update the kanban board",
  "regenerate the kanban", "refresh the todo overview", "update obsidian kanban",
  or wants to rebuild the Obsidian Kanban board file for the configured todo store.
allowed-tools: Bash, Read, Write
invocation: user
---

# todo-overview

Regenerate the Obsidian Kanban board for the configured todo store.

Requires `kanbanFile` to be set in `.agent-todos.local.json`. If not configured, the script outputs a message to stderr and exits without writing any file — relay that message to the user and suggest running `/todo-init` to configure one.

## Workflow

1. Run the bundled script:

```bash
bash <base_directory>/scripts/update-overview.sh "<project_root>"
```

Where:

- `<base_directory>` is the path shown in "Base directory for this skill:" at invocation time.
- `<project_root>` is the current project root.

2. Check the script output:
   - **Success** — the script prints the path of the written Kanban file. Confirm this path to the user.
   - **stderr message about missing kanbanFile** — relay it to the user and suggest running `/todo-init` to configure a Kanban file path.
   - **stderr error about missing todos directory** — relay it to the user and suggest running `/todo-init` to set up the todo store.

## Notes

- Reads `.agent-todos.local.json` to determine todos directory and kanban file path.
- If `kanbanFile` is not configured, the script exits 0 with a stderr message — no file is written.
- Includes all todos (open and `DONE_`), mapping frontmatter `status` to Kanban lanes: New, Ready, Doing, Done.
- Infers `status: done` for `DONE_` prefixed files without frontmatter.
- To configure a kanban file, re-run `/todo-init` or add `"kanbanFile"` to `.agent-todos.local.json`.
