---
name: todo-obsidian-icloud-import
description: >
  Import agent todos from a local Obsidian vault synced via iCloud Drive. Use when
  the user asks to "import from obsidian", "import obsidian todos", "sync obsidian
  todos", "get todos from obsidian", or wants to pull todos from an Obsidian vault
  into docs/agent-todos/.
compatibility: macOS only (requires iCloud Drive with Obsidian vault)
allowed-tools: Bash, Read, Write, Edit, Skill, AskUserQuestion
invocation: user
argument-hint: "[vaultname] [source-category]"
---

# todo-obsidian-icloud-import

Import agent todo markdown files from a local Obsidian vault stored on iCloud Drive into the project's `docs/agent-todos/` workflow.

## Prerequisites

This skill only works on **macOS** with an Obsidian vault synced via iCloud Drive. Obsidian vaults are stored at:

```
~/Library/Mobile Documents/iCloud~md~obsidian/Documents/<vaultname>/
```

The vault must contain an `agent-todos/<category>/` subdirectory with markdown todo files to import.

## Workflow

### 1. Verify Platform

Run the bundled script with the `--check-platform` flag:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --check-platform
```

If it exits non-zero, inform the user:

> This skill only works on macOS with iCloud Drive. Your current platform is not supported.

Do not proceed.

### 2. Gather Input

Collect the **vault name** and **source category**. These may come from skill arguments or by asking the user.

- **Vault name** — The name of the Obsidian vault (directory name under iCloud Drive's Obsidian folder)
- **Source category** — The subdirectory name under `agent-todos/` inside the vault (e.g., `misc`, `data`)

If both values are provided as arguments (e.g., `/todo-obsidian-icloud-import MyVault misc`), parse the first word as the vault name and the second as the source category.

If arguments are missing, ask the user using AskUserQuestion. To help the user choose, you can list available vaults and categories:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --list-vaults
```

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --list-categories "<vaultname>"
```

### 3. List Available Todos

Run the script to list todo files available for import:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --list "<vaultname>" "<source-category>"
```

This prints one file path per line for each markdown file in the vault's `agent-todos/<source-category>/` directory. Only files **not** prefixed with `DONE_` are listed (open todos).

If no files are found, inform the user and stop.

### 4. Choose Destination Category

The source category in the Obsidian vault may not match the desired local category. Ask the user which local `docs/agent-todos/` category the imported todos should be placed in.

List existing local categories by scanning subdirectories of `docs/agent-todos/` in the project root. Present them as options via AskUserQuestion, allowing the user to pick an existing category or type a new one.

### 5. Import Each Todo

For each listed file:

1. **Read the file** from the Obsidian vault path to extract its title and content
2. **Use `/todo-creation`** to create a new local todo file in the chosen **destination category**:
   ```
   Skill: todo-creation
   Args: <destination-category> <title-from-file>
   ```
3. **Populate the created file** with the content from the Obsidian source file:
   - Copy the body content (Problem/Context, Tasks, etc.)
   - Update the frontmatter `status` from `new` to `ready` (since imported files already have content)

### 6. Delete Source Files (Optional)

After all files are successfully imported, ask the user whether to delete the source files from the Obsidian vault.

If the user confirms, run:

```bash
bash <base_directory>/scripts/import-obsidian-todos.sh --delete "<vaultname>" "<source-category>" "<filename>"
```

For each imported file. This moves the file to trash (macOS `mv` to `~/.Trash/`) for safety rather than permanent deletion.

If the user declines, skip this step.

### 7. Update Overview

After importing all todos, run `/todo-overview` to refresh `docs/agent-todos/TODO_OVERVIEW.md`.

## Example

Importing from vault "WorkNotes" source category "my-project":

1. Script finds `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/WorkNotes/agent-todos/my-project/0001_fix_layout.md`
2. User is asked to choose a destination category from existing local folders (e.g., `misc`, `data`) or type a new one
3. User picks `misc` as the destination
4. `/todo-creation misc "Fix layout"` creates `docs/agent-todos/misc/0005_fix_layout.md`
5. Content is copied from the Obsidian file to the local todo
6. Status is updated to `ready`
7. User confirms deletion; source file is moved to Trash

## Notes

- Only open todos (not prefixed with `DONE_`) are imported
- The local sequential numbering is independent of the Obsidian numbering — `/todo-creation` handles this
- Source files are moved to Trash (not permanently deleted) for safety
- If the Obsidian vault path does not exist, the script will report an error
- iCloud Drive may sync files with delay; ensure files are downloaded locally before importing
- The vault's `agent-todos/` directory structure mirrors the local `docs/agent-todos/` convention
- Keep `docs/agent-todos/TODO_OVERVIEW.md` in sync by invoking `/todo-overview` after imports
