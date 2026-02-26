---
name: todo-migrate-to-obsidian
description: >
  This skill should be used when the user asks to "migrate todos to obsidian",
  "move agent todos to obsidian vault", "use obsidian as primary todo store",
  "move docs/agent-todos to obsidian", or wants to configure Obsidian as the
  primary store for this project's todos.
allowed-tools: Bash, Read, Write, Edit, AskUserQuestion, Skill
invocation: user
argument-hint: "[vault-name] [project-name]"
compatibility: macOS only (requires locally accessible Obsidian vault)
---

# todo-migrate-to-obsidian

Migrate `docs/agent-todos/` to an Obsidian vault and configure the plugin to write all future todos directly to the vault.

## Workflow

### 1. Check Existing Config

Read `.claude/agent-todos.local.json` in the project root, if it exists. Check for `vaultRoot` and `todosRoot` keys.

**If both keys are present:**

1. Check whether `docs/agent-todos/` still exists in the project root. If it does not, the migration was already completed and the source was deleted — inform the user and stop.
2. Otherwise, the vault is already configured but migration can be re-run (e.g. to copy newly added todos). Skip vault discovery — use the existing `vaultRoot` value as the vault path argument to the migration script. Derive `project_name` from the `todosRoot` value (strip any trailing slash, then take the last path component, e.g. `my-project` from `.../agent-todos/my-project`). Proceed directly to Step 3 (Run Migration Script).

**If the config is missing or incomplete:** Continue with Step 2.

### 2. Gather Input

Collect the vault name and project name. These may come from skill arguments or by asking the user.

- **Vault name** — The Obsidian vault directory name under iCloud Drive's Obsidian folder. List available vaults:

  ```bash
  ls ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/
  ```

- **Project name** — Subdirectory name under `agent-todos/` in the vault. Defaults to the current project root directory name (e.g., `my-project`).

If both values are provided as arguments (e.g., `/todo-migrate-to-obsidian vault-of-jens my-project`), parse the first word as vault name and the rest as project name.

If the vault argument starts with `/` or `~` (an absolute path), do not split on spaces — treat the entire argument as the vault path. When in doubt, use AskUserQuestion to collect vault path and project name separately.

If arguments are missing, ask the user using AskUserQuestion.

### 3. Run Migration Script

```bash
bash <base_directory>/scripts/migrate-to-obsidian.sh "<project_root>" "<vault_name>" "<project_name>"
```

Where `<base_directory>` is the path shown in "Base directory for this skill:" at the top of the skill invocation, and `<project_root>` is the current project root.

The script:

1. Verifies this is macOS and the vault exists
2. Creates `<vault>/agent-todos/<project_name>/<category>/` directories
3. Copies all todo files preserving `DONE_` prefixes and sequential numbering
4. Prints three config values to stdout in `key=value` format:
   - `todos_root=<path>`
   - `vault_root=<path>`
   - `kanban_file=<path>`

Parse the output lines to extract these three values.

If the script exits with a non-zero status, report the error and stop.

### 4. Write Config File

Create `.claude/agent-todos.local.json` in the project root using the three values from the script output:

```json
{
  "todosRoot": "<todos_root value>",
  "vaultRoot": "<vault_root value>",
  "kanbanFile": "<kanban_file value>"
}
```

Use the Write tool to create this file at `<project_root>/.claude/agent-todos.local.json`.

### 5. Generate Initial Kanban Board

Run `/todo-overview` to generate the initial Obsidian Kanban board at the configured `kanban_file` path. Confirm the output path from the script's stdout.

### 6. Ask About Source Deletion

Ask the user whether to delete `docs/agent-todos/` from the codebase:

> The todos have been copied to the Obsidian vault at `<todos_root>`. Would you like to delete `docs/agent-todos/` from the codebase?

If the user confirms, delete the directory:

```bash
rm -rf "<project_root>/docs/agent-todos"
```

If the user declines, leave the directory in place. Note that all todo skills will now write to the vault path; `docs/agent-todos/` will not receive new files.

## Notes

- macOS only — requires an Obsidian vault accessible on the local filesystem
- Migration copies files — it does not move them; the user decides about source deletion
- Sequential numbering and `DONE_` prefixes are preserved exactly
- After migration, all skills (`/todo-creation`, `/todo-overview`, `/todo-moving`) use the vault path automatically via `.claude/agent-todos.local.json`
- To revert, delete `.claude/agent-todos.local.json` — skills will fall back to `docs/agent-todos/`
- iCloud Drive may delay local availability of files; ensure the vault is fully synced before migrating
