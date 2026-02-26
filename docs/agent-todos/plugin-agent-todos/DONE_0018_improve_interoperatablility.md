---
title: "improve interoperatablility"
status: done
---

## Context

The skills in this plugin should also usable in other agentes like codes. but the have non-valid yaml in the frontmatter

## Tasks

- [x] use only valid yaml (see example)
- [x] bump version with patch step

## Progress, Decisions etc.

### 2026-02-26: Implementation complete

**What was done:**

- Fixed 5 SKILL.md files with unquoted `description` values containing double-quote characters (invalid YAML)
- Converted all 5 to `>` folded block scalar style, consistent with `todo-obsidian-icloud-import` and `todo-obsidian-import`
- Files fixed: `todo-creation`, `todo-gh-issue-import`, `todo-migrate-to-obsidian`, `todo-moving`, `todo-overview`
- 4 files were already valid: `todo-init`, `todo-obsidian-icloud-import`, `todo-obsidian-import`, `todo-processing`
- Bumped `agent-todos` version `0.5.0` → `0.5.1` in `plugin.json` and `marketplace.json`

## Example

### Non Valid

```yaml
description: This skill should be used when the user asks to "create a todo", "add a todo", "new todo", "make a todo", "new task", "create a task", "add a task file", or wants to create a new agent todo file in the configured todos directory (default: docs/agent-todos/).
```

### Valid

```yaml
description: "This skill should be used when the user asks to `create a todo`, `add a todo`, `new todo`, `make a todo`, `new task`, `create a task`, `add a task file`, or
wants to create a new agent todo file in the configured todos directory (default: docs/agent-todos/)."
```
