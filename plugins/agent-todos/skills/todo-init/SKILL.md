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

**Upgrade path — missing `projectName`:** If the existing config is kept (user chooses not to reconfigure) but `projectName` is absent, ask: "Would you like to add a `projectName` to your config? This value is included in the `projects:` frontmatter of every new todo (e.g. `[[my-project]]`)." If yes, ask for the value and write it to the config file.

### Step 2: Determine Todo Store Path

Ask the user where to store todos:

- **Default** — `docs/agent-todos/` inside the project (works everywhere, no external tools needed)
- **Custom path** — any absolute path, e.g. a path inside an Obsidian vault

Use `AskUserQuestion` to let the user choose.

### Step 2b: Determine Project Name (optional)

After the todo store path is set, ask the user whether they want to associate todos with a project name:

> Would you like to add a `projectName` to tag every new todo? This is included in the `projects:` frontmatter field (e.g. `[[my-project]]` for Obsidian task-notes integration). Leave blank to skip.

This field is optional. If the user provides a value, include it in the config.

### Step 3: Write Config File

Create `.agent-todos.local.json` in the project root:

```json
{
  "todosRoot": "<todos_root>"
}
```

If the user provided a `projectName`, include it:

```json
{
  "todosRoot": "<todos_root>",
  "projectName": "<project_name>"
}
```

All paths should use `~` for the home directory when applicable.

### Step 4: Create Todo Store Directory

Create the `todosRoot` directory if it does not already exist:

```bash
mkdir -p "<todos_root>"
```

### Step 5: Ask for Initial Categories

Ask the user which category subdirectories to create (multi-select). Suggest common ones:

- `misc/` — Miscellaneous tasks
- `data/` — Data-related tasks
- `content/` — Content creation and editing tasks

Create the selected subdirectories inside `todosRoot`.

## Notes

- `.agent-todos.local.json` is project-specific and should be added to `.gitignore` when `todosRoot` points outside the project
- If `todosRoot` is inside the project (e.g. `docs/agent-todos`), it can be checked in
- All todo skills (`/todo-creation`, `/todo-processing`, etc.) read this config automatically
- To use a different store later, re-run `/todo-init` or edit `.agent-todos.local.json` directly
- Without `.agent-todos.local.json`, all skills fall back to `docs/agent-todos/` in the project root
