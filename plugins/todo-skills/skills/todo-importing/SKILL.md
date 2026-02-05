---
name: todo-importing
description: Import Todos from GitHub Issues
allowed-tools: Bash, Read, Write, Skill
invocation: user
---

# todo-importing

Import open GitHub issues into local todo files.

## Workflow

1. Use `gh issue list` to fetch all open issues from the current repository
2. For each issue, create a local todo file using the `/todo-processing` skill
3. Use GitHub labels to determine the appropriate category (e.g., label "data" → category `data/`)
4. After creating the todo file, close the GitHub issue with a comment referencing the created filename

## Notes

- Only import open issues (closed issues are already done)
- If no label matches a category, ask the user or use `misc/`
- The comment on the closed issue should include the path like: `Imported to docs/agents-todos/data/001_task-name.md`
