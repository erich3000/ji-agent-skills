---
name: todo-init
description: Initialize the docs/agents-todos folder structure
allowed-tools: Bash, Read, Write, AskUserQuestion
invocation: user
---

# todo-init

Initialize the `docs/agents-todos/` folder structure for AI agent task tracking.

## Workflow

1. Check if `docs/agents-todos/` already exists
   - If yes, inform the user and ask if they want to add more categories
   - If no, create the base directory

2. Ask the user which category subdirectories to create (multi-select):
   - `data/` - Data-related tasks
   - `content/` - Content creation and editing tasks
   - `misc/` - Miscellaneous tasks
   - Custom categories as needed

3. Create the selected subdirectories

4. Copy the `<base_directory>/resources/README.md` into `docs/agents-todos/` in order to explain the structure (only on initial setup)

Where `<base_directory>` is the path shown in "Base directory for this skill:" at the top of the skill invocation.

## README Template

```markdown
# Agent Todos

This folder contains task files for AI agents working on this project.

## Structure

- Each subdirectory represents a category of tasks
- Task files use the naming convention: `[NNN]_[description].md`
- Completed tasks are prefixed with `DONE_`

## Related Skills

- `/todo-importing` - Import GitHub issues as todo files
- `/todo-processing` - Work with and update todo files

See the skill documentation for details on file format and workflow.
```

## Notes

- This skill only creates the folder structure
- Use `/todo-importing` to populate with tasks from GitHub issues
- Use `/todo-processing` to work with existing todo files
