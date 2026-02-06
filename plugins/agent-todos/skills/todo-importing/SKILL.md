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
2. For each issue, create a local todo file using the `/todo-processing` skill format. Include YAML frontmatter with `title` (from the issue title) and `status: ready` (since imported issues already have content)
3. Use GitHub labels to determine the appropriate category (e.g., label "data" → category `data/`)
4. After creating the todo file, close the GitHub issue with a comment referencing the created filename

## Example

An imported issue titled "Fix soft 404 errors" with label "data" becomes `docs/agent-todos/data/0042_fix-soft-404-errors.md`:

```markdown
---
title: Fix soft 404 errors
status: ready
---

# Fix soft 404 errors

## Problem / Context

(content from the GitHub issue body)

## Tasks

- [ ] ...
```

## Notes

- Only import open issues (closed issues are already done)
- If no label matches a category, ask the user or use `misc/`
- The comment on the closed issue should include the path like: `Imported to docs/agent-todos/data/0001_task-name.md`
