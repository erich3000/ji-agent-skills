---
name: todo-obsidian-import
description: >
  This skill should be used when the user asks to "import from obsidian",
  "import obsidian todos", "sync obsidian todos", "get todos from obsidian",
  "import with configured vault", or wants to pull todos from a local Obsidian
  vault into the project's todos directory (default: docs/agent-todos/).
  Supports any vault via vaultRoot in .claude/agent-todos.local.json, and falls
  back to iCloud Drive discovery on macOS when no path is configured. Preferred
  over todo-obsidian-icloud-import when a configured vault path may be present.
allowed-tools: Bash, Read, Write, Edit, Skill, AskUserQuestion
invocation: user
argument-hint: "[source-category]"
---

# todo-obsidian-import

Import agent todo markdown files from a local Obsidian vault into the project's configured todos directory (default: `docs/agent-todos/`).

The vault path is read from `.claude/agent-todos.local.json` (`vaultRoot`). If not configured, the skill falls back to iCloud Drive vault discovery on macOS, or asks the user to enter a path on other platforms.

## Workflow

### 1. Resolve Vault Path

Run the bundled script to check for a configured vault path:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --get-vault-path "$PWD"
```

- **Output is non-empty** — use that path as `vault_path` directly; skip all vault prompts.
- **Output is empty on macOS** — list available vaults and ask the user to choose:

  ```bash
  bash <base_directory>/scripts/import-obsidian-todos.sh --list-vaults "$PWD"
  ```

  Present the results via AskUserQuestion. Pass the selected vault name as `vault_path` in all subsequent script calls — the script's `vault_path()` function prepends the iCloud base path automatically when the value is not an absolute path.

- **Output is empty on non-macOS** — ask the user to enter the full absolute path to the Obsidian vault. Use that as `vault_path`.

### 2. Gather Source Category

If a source category was provided as a skill argument (e.g., `/todo-obsidian-import misc`), use it directly and skip the prompt.

Otherwise, list available categories in the vault:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --list-categories "<vault_path>"
```

Present the results via AskUserQuestion and ask the user to choose (or enter a new one).

### 3. List Available Todos

List open todo files in the chosen category:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --list "<vault_path>" "<source-category>"
```

This prints one absolute file path per line for each open (non-`DONE_`) markdown file. If no files are found, inform the user and stop.

### 4. Choose Destination Category

The source category in the Obsidian vault may differ from the desired local category. List existing categories by scanning subdirectories of the configured todos directory in the project root. Present them via AskUserQuestion, allowing the user to pick an existing category or type a new one.

### 5. Import Each Todo

For each listed file:

1. **Read the file** from the Obsidian vault path to extract its title and content.
2. **Use `/todo-creation`** to create a new local todo file in the chosen destination category:
   ```
   Skill: todo-creation
   Args: <destination-category> <title-from-file>
   ```
3. **Populate the created file** with the content from the Obsidian source file:
   - Copy the body content (Problem/Context, Tasks, etc.)
   - Update the frontmatter `status` from `new` to `ready` (since imported files already have content)

### 6. Delete Source Files (Optional)

After all files are successfully imported, ask the user whether to delete the source files from the Obsidian vault.

If the user confirms, run for each imported file:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --delete "<vault_path>" "<source-category>" "<filename>"
```

This moves the file to `~/.Trash/` for safety rather than permanent deletion.

If the user declines, skip this step.

### 7. Update Overview

After importing all todos, run `/todo-overview` to refresh `docs/agent-todos/TODO_OVERVIEW.md`.

## Example

Importing with `vaultRoot` set to `/Users/alice/vaults/Work` in `.claude/agent-todos.local.json`:

1. `--get-vault-path` returns `/Users/alice/vaults/Work` — vault prompt skipped.
2. `--list-categories /Users/alice/vaults/Work` returns `misc`, `data`.
3. User picks `misc` as source category.
4. `--list` finds `0001_fix_layout.md` and `0002_update_docs.md`.
5. User picks `misc` as destination category.
6. `/todo-creation misc "Fix layout"` creates the local todo; content is copied and status set to `ready`.
7. User confirms deletion; both source files are moved to Trash.

## Notes

- Only open todos (not prefixed with `DONE_`) are imported.
- The local sequential numbering is independent of the Obsidian numbering — `/todo-creation` handles this.
- Source files are moved to Trash (not permanently deleted) for safety.
- On non-macOS, set `vaultRoot` in `.claude/agent-todos.local.json` to use this skill.
- iCloud Drive may sync files with delay; ensure files are downloaded locally before importing.
- The vault's `agent-todos/` directory structure mirrors the local todos directory convention.
