---
name: todo-processing
description: Work with AI agent todo files in docs/agents-todos
invocation: none
---

# todo-processing

This skill describes how to work with todo files located in `docs/agents-todos/`. These files track tasks for AI agents working on this project.

## Directory Structure

Todo files are organized in category subdirectories. Categories are flexible and can be created as needed.

```
docs/agents-todos/
├── [category]/     # e.g., data, menu, misc, tags, thai-food-dict
│   ├── 001_task-description.md
│   ├── DONE_002_completed-task.md
│   └── ...
└── [another-category]/
```

## File Naming Conventions

### Open Tasks

- `[3-digit-number]_[description].md` - e.g., `001_create-new-feature.md`
- `TODO-[DESCRIPTION].md` - alternative format for quick todos

### Completed Tasks

- `DONE_[original-filename].md` - Add `DONE_` prefix when task is complete
- Example: `001_create-feature.md` → `DONE_001_create-feature.md`

### Supporting Files

Tasks may have supporting files (CSV, JSON, images, etc.) with the same number prefix:

- `001_fix-soft-404.md` - the task file
- `001_Tabelle.csv` - supporting data for the task

When marking a task as done, also rename supporting files with the `DONE_` prefix.

## Todo File Structure

Each todo file should contain:

```markdown
# Task Title

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

## Workflow

### 1. Reading a Todo

When assigned a task:

1. Read the todo file to understand the task
2. Note any prerequisites or context
3. Check for existing progress entries

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

1. Add a final progress entry documenting completion
2. If the file has checkboxes, mark them all as `[x]`
3. Rename the file with `DONE_` prefix

## Best Practices

1. **Be verbose in progress notes** - Future agents will read these
2. **Date all entries** - Use format `YYYY-MM-DD`
3. **Document failures too** - "Attempted X, did not work because Y"
4. **Link to related files** - Reference files that were created/modified
5. **Ask before assuming** - Add questions to the file and ask the user
6. **Update internal docs** - After completing a task, update relevant documentation

## Finding Tasks

To list all open (not done) tasks:

```bash
find docs/agents-todos -name "*.md" ! -name "DONE_*" -type f
```

To list all completed tasks:

```bash
find docs/agents-todos -name "DONE_*.md" -type f
```
