---
name: todo-creation
description: This skill should be used when the user asks to "create a todo", "add a todo", "new todo", "make a todo", "new task", "create a task", "add a task file", or wants to create a new agent todo file in docs/agent-todos/.
allowed-tools: Bash, Read, Write, Edit, AskUserQuestion
invocation: user
argument-hint: "[category] [title]"
---

# todo-creation

Create a new todo file in `docs/agent-todos/` with proper sequential numbering and YAML frontmatter.

## Workflow

### 1. Gather Input

Collect the category and title. These may come from skill arguments or by asking the user.

- **Category** — The subdirectory name under `docs/agent-todos/` (e.g., `data`, `misc`, `agent-todos`). If the directory does not exist, it will be created.
- **Title** — A human-readable title for the todo (e.g., "Fix soft 404 errors").

If both values are provided as arguments (e.g., `/todo-creation data Fix soft 404 errors`), parse the first word as the category and the rest as the title.

If arguments are missing, ask the user using AskUserQuestion.

### 2. Create the File

Run the bundled script to create the todo file:

```bash
bash <base_directory>/scripts/create-todo.sh "<category>" "<title>" "<project_root>"
```

Where `<base_directory>` is the path shown in "Base directory for this skill:" at the top of the skill invocation, and `<project_root>` is the root of the current project.

The script:

1. Scans all files in the category directory (including `DONE_` files) to find the highest numeric prefix
2. Assigns the next sequential 4-digit number
3. Converts the title to snake_case, truncated to 60 characters
4. Creates the file with YAML frontmatter (`title`, `status: new`) and an H1 heading
5. Prints the created file path to stdout

If the script exits with a non-zero status, report the error output to the user and stop.

### 3. Prompt for Description

After the file is created, inform the user of the file path and ask them to add a description or task details. Once content is added, update the frontmatter status from `new` to `ready`.

### 4. Update Overview

After creating the todo (and again after switching `status` to `ready`), run `/todo-overview` to refresh `docs/agent-todos/TODO_OVERVIEW.md`.

## File Format

The created file follows this structure:

```markdown
---
title: Fix soft 404 errors
status: new
---

## Context

## Tasks
```

After the user provides content, the recommended structure is:

```markdown
---
title: Fix soft 404 errors
status: ready
---

# Fix soft 404 errors

## Problem / Context

(user-provided description)

## Tasks

- [ ] Task item 1
- [ ] Task item 2
```

## Notes

- The sequential number accounts for both open and completed (`DONE_`) files to avoid collisions.
- If the category directory does not exist, it is created automatically.
- The filename is truncated to 60 characters (before the `.md` extension) to keep paths manageable.
- After the user adds content, update the status to `ready` so the todo is recognized as actionable under the conventions defined by `todo-processing`.
- Keep `docs/agent-todos/TODO_OVERVIEW.md` in sync by invoking `/todo-overview` after creation and status updates.
