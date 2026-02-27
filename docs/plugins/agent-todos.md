# agent-todos

`agent-todos` provides structured todo workflows for AI agents. By default, todos are stored under `docs/agent-todos/` inside the project. For workplaces where committing AI task files is not acceptable, todos can be stored in an Obsidian vault instead — configured per project via `.agent-todos.local.json`.

## What It Does

- Standardizes todo file creation, naming, and frontmatter.
- Guides agents through a status lifecycle (`new`, `ready`, `doing`, `done`, `archived`).
- Generates project-level todo overviews: Mermaid Kanban (default) or Obsidian Kanban board (Obsidian mode).
- Moves open todos between categories and renumbers open items without colliding with DONE items.
- Supports importing todos from GitHub issues and Obsidian/iCloud vaults.
- Migrates an existing `docs/agent-todos/` to an Obsidian vault in one step.

## Skills

| Skill | Description |
| --- | --- |
| `/todo-init` | Initializes the todos folder structure with category subdirectories. |
| `/todo-creation` | Creates a new todo file with sequential 4-digit numbering and YAML frontmatter. |
| `/todo-processing` | Reference skill defining todo file conventions, naming, and progress tracking. |
| `/todo-overview` | Generates or updates the todo overview (Mermaid `TODO_OVERVIEW.md` or Obsidian Kanban board). |
| `/todo-moving` | Moves selected open todos between categories and renumbers open todos in both folders. |
| `/todo-gh-issue-import` | Imports open GitHub issues into local todo files using `gh issue list`. |
| `/todo-obsidian-icloud-import` | Imports todos from a local Obsidian vault synced via iCloud Drive (macOS). |
| `/todo-migrate-to-obsidian` | Copies `docs/agent-todos/` to an Obsidian vault and writes the config file (macOS). |

## Configuration

### Default (no configuration)

All skills read from and write to `docs/agent-todos/` inside the project root. No setup needed.

### Obsidian mode

Create `.agent-todos.local.json` in the project root (this file is gitignored by Claude Code conventions):

```json
{
  "todosRoot": "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/<vault-name>/agent-todos/<project-name>",
  "vaultRoot": "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/<vault-name>",
  "kanbanFile": "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/<vault-name>/agent-todos/<project-name>-kanban.md"
}
```

| Field | Required | Description |
| --- | --- | --- |
| `todosRoot` | yes | Absolute path to the todos root (holds category subdirectories). Replaces `docs/agent-todos/`. |
| `vaultRoot` | no | Obsidian vault root. Used to compute wiki-link paths in the Kanban board. |
| `kanbanFile` | no | Obsidian Kanban output path. Defaults to `$(dirname todosRoot)/$(basename todosRoot)-kanban.md`. |

`~` in paths is expanded to `$HOME` at runtime.

When `kanban_file` is set (or derived from a non-default `todos_root`), `/todo-overview` generates an Obsidian Kanban board file instead of `TODO_OVERVIEW.md`.

### Switching back to default

Delete `.agent-todos.local.json`. All skills fall back to `docs/agent-todos/` immediately — no other changes needed.

### Migrating existing todos to Obsidian

Run `/todo-migrate-to-obsidian` to copy `docs/agent-todos/` to the vault and write the config file automatically. The skill also generates the initial Kanban board and optionally removes `docs/agent-todos/` from the codebase.

## Obsidian Kanban output format

When in Obsidian mode, `/todo-overview` generates a board compatible with the [Obsidian Kanban plugin](https://github.com/mgmeyers/obsidian-kanban):

````markdown
---
kanban-plugin: board
---

## New
- [ ] [[agent-todos/my-project/misc/0001_some_task|Some task]]

## Ready
- [ ] [[agent-todos/my-project/misc/0002_other_task|Other task]]

## Doing

## Done
- [x] [[agent-todos/my-project/misc/DONE_0003_done_task|Done task]]

***

## Archive

%% kanban:settings
```json
{"kanban-plugin":"board"}
```
%%
````

Wiki-link paths are computed as the file path relative to `vault_root` with the `.md` extension stripped.

## Status Lifecycle

```mermaid
timeline
  title Todo Status Lifecycle
  new : Created but not yet fleshed out
  ready : Has content and can be picked up
  doing : Active work in progress
  done : Completed (also rename file with DONE_ prefix)
  archived : Reserved for future archiving
```
