---
name: todo-processing
description: >
  Work with AI agent todo files in the configured todos directory
  (default: docs/agent-todos)
invocation: none
---

# todo-processing

This skill describes how to work with todo files located in the configured todos directory (default: `docs/agent-todos/`). These files track tasks for AI agents working on this project.

## Directory Structure

Todo files are organized in category subdirectories. Categories are flexible and can be created as needed.

The todos directory is configurable via `.claude/agent-todos.local.json` (default: `docs/agent-todos/`).

```
<todos-directory>/
├── [category]/     # e.g., data, menu, misc, tags, thai-food-dict
│   ├── 0001_task-description.md
│   ├── DONE_0002_completed-task.md
│   └── ...
└── [another-category]/
```

## File Naming Conventions

### Open Tasks

- `[4-digit-number]_[description].md` - e.g., `0001_create-new-feature.md`
- `TODO-[DESCRIPTION].md` - alternative format for quick todos

### Completed Tasks

- `DONE_[original-filename].md` - Add `DONE_` prefix when task is complete
- Example: `0001_create-feature.md` → `DONE_0001_create-feature.md`

### Supporting Files

Tasks may have supporting files (CSV, JSON, images, etc.) with the same number prefix:

- `0001_fix-soft-404.md` - the task file
- `0001_Tabelle.csv` - supporting data for the task

When marking a task as done, also rename supporting files with the `DONE_` prefix.

## Todo File Structure

Each todo file should contain:

```markdown
---
title: Task Title
status: ready
---

## Problem / Context

Description of the problem or context for the task.

## Tasks

- [ ] Task item 1
- [ ] Task item 2
- [ ] Ask questions if anything is uncertain

## Progress, Decisions etc.

### YYYY-MM-DD: Progress Entry Title

Description of what was done, decisions made, etc.
```

## Frontmatter Fields

Every todo file starts with YAML frontmatter (`---` delimiters) containing:

### `title`

A human-readable title derived from the filename:

1. Strip `DONE_` prefix if present
2. Strip the numeric prefix (e.g. `0001_`)
3. Replace hyphens and underscores with spaces
4. Capitalize the first letter

Example: `DONE_0042_fix-soft-404-errors.md` → `Fix soft 404 errors`

### `status`

Tracks the lifecycle of a todo. Values and transitions:

| Status     | Meaning                         | Transitions to  |
| ---------- | ------------------------------- | --------------- |
| `new`      | Created but not yet fleshed out | `ready`         |
| `ready`    | Has content, ready to work on   | `doing`         |
| `doing`    | Currently being worked on       | `done`, `ready` |
| `done`     | Completed                       | `archived`      |
| `archived` | Archived (reserved)             | —               |

- A file with the `DONE_` prefix should always have `status: done`.
- When a file has meaningful content (problem description, tasks), use `ready`.
- A freshly created empty file uses `new`.

## Workflow

### 1. Reading a Todo

When assigned a task:

1. Read the todo file to understand the task
2. Update the frontmatter status from `ready` → `doing`
3. Note any prerequisites or context
4. Check for existing progress entries
5. Run `/todo-overview` after status changes to refresh the todo overview

### 2. Working on a Task

While working:

1. **Ask questions** if anything is unclear - add user's answers to the file
2. **Document decisions** made during implementation
3. **Track progress** with dated entries

### 3. Adding Progress Notes

Add progress entries with this format:

```markdown
### YYYY-MM-DD: Brief Description

**What was done:**

- Item 1
- Item 2

**Decisions made:**

- Decision 1 (with reasoning)

**Outstanding questions:** (if any)

1. Question 1?
```

### 4. Marking as Done

When task is complete:

1. Update the frontmatter status to `done`
2. Add a final progress entry documenting completion
3. If the file has checkboxes, mark them all as `[x]`
4. Rename the file with `DONE_` prefix
5. Run `/todo-overview` after marking done to refresh the todo overview

## Best Practices

1. **Be verbose in progress notes** - Future agents will read these
2. **Date all entries** - Use format `YYYY-MM-DD`
3. **Document failures too** - "Attempted X, did not work because Y"
4. **Link to related files** - Reference files that were created/modified
5. **Ask before assuming** - Add questions to the file and ask the user
6. **Update internal docs** - After completing a task, update relevant documentation
7. **Keep overview current** — Trigger `/todo-overview` whenever todo status changes

## Finding Tasks

Replace `docs/agent-todos` with your configured todos directory if using Obsidian mode (see `.claude/agent-todos.local.json`).

To list all open (not done) tasks:

```bash
find docs/agent-todos -name "*.md" ! -name "DONE_*" -type f
```

To list all completed tasks:

```bash
find docs/agent-todos -name "DONE_*.md" -type f
```

To find tasks ready to be picked up (by frontmatter status):

```bash
grep -rl "^status: ready" docs/agent-todos/
```
