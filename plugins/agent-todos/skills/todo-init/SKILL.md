---
name: todo-init
description: >
  This skill should be used when the user asks to "set up agent todos", "initialize
  the todo store", "configure todos", "run todo init", "set up .agent-todos.local.json",
  or wants to set up or reconfigure the todo store for this project.
allowed-tools: Bash, Read, Write, AskUserQuestion
invocation: user
---

# todo-init

Set up the agent todos configuration for this project. Creates `.agent-todos.local.json` in the project root and initializes the todo store directory.

The default todo store is `docs/agent-todos/` inside the project. Users with Obsidian can point `todosRoot` to a vault path instead.

## Workflow

### Step 1: Check for Existing Config

Read `.agent-todos.local.json` in the project root, if it exists.

If a config file is found, show the current settings and ask the user whether to reconfigure or abort.

### Step 2: Determine Todo Store Path

Ask the user where to store todos:

- **Default** — `docs/agent-todos/` inside the project (works everywhere, no external tools needed)
- **Custom path** — any absolute path, e.g. a path inside an Obsidian vault

Use `AskUserQuestion` to let the user choose.

### Step 3: Optionally Configure Obsidian Kanban

If the user chose a custom path (not the project default), ask whether they use Obsidian and want a Kanban board:

- **Yes** — ask for the `kanbanFile` path (an `.md` file in their vault, e.g. `~/Obsidian/my-vault/agent-todos/my-project-kanban.md`)
- **No** — skip; no Kanban will be generated

If the `todosRoot` path is inside a recognizable Obsidian vault (i.e. a parent directory contains `.obsidian/`), detect the vault root automatically and suggest a `kanbanFile` path like `<vault_root>/agent-todos/<project-name>-kanban.md`. Present this suggestion in the prompt so the user can confirm or override it.

The `vaultRoot` field is set to the nearest parent directory that contains `.obsidian/`.

### Step 4: Write Config File

Create `.agent-todos.local.json` in the project root:

```json
{
  "todosRoot": "<todos_root>"
}
```

If Obsidian Kanban was configured, include:

```json
{
  "todosRoot": "<todos_root>",
  "vaultRoot": "<vault_root>",
  "kanbanFile": "<kanban_file>"
}
```

All paths should use `~` for the home directory when applicable.

### Step 5: Create Todo Store Directory

Create the `todosRoot` directory if it does not already exist:

```bash
mkdir -p "<todos_root>"
```

### Step 6: Ask for Initial Categories

Ask the user which category subdirectories to create (multi-select). Suggest common ones:

- `misc/` — Miscellaneous tasks
- `data/` — Data-related tasks
- `content/` — Content creation and editing tasks

Create the selected subdirectories inside `todosRoot`.

### Step 7: Copy README Template

Copy `<base_directory>/resources/README.md` into the `todosRoot` directory (only if this is the first-time setup, not a reconfiguration).

Where `<base_directory>` is the path shown in "Base directory for this skill:" at the top of the skill invocation.

## Notes

- `.agent-todos.local.json` is project-specific and should be added to `.gitignore` when `todosRoot` points outside the project
- If `todosRoot` is inside the project (e.g. `docs/agent-todos`), it can be checked in
- All todo skills (`/todo-creation`, `/todo-overview`, `/todo-processing`, etc.) read this config automatically
- To use a different store later, re-run `/todo-init` or edit `.agent-todos.local.json` directly
- Without `.agent-todos.local.json`, all skills fall back to `docs/agent-todos/` in the project root
