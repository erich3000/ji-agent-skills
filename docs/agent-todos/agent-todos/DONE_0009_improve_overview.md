---
title: "improve overview"
status: done
---

## Context

For users it is better to see first the kanban for an overview and then the list with links to todos

## Tasks

- got to `plugins/agent-todos/skills/todo-overview/SKILL.md`
- change the order of the overview table and kanban board. the kanban should come first
- change skill and script
- bunp the version of the plugin (patch)

## Progress, Decisions etc.

### 2026-02-07: Reordered overview output and bumped plugin patch version

**What was done:**

- Updated `plugins/agent-todos/skills/todo-overview/scripts/update-overview.sh` to render `## Todo Kanban` before the todo table.
- Added an explicit `## Todo List` section so the ordering is clear and stable.
- Updated `plugins/agent-todos/skills/todo-overview/SKILL.md` to describe Kanban-first output and table second.
- Bumped `agent-todos` plugin version from `0.1.2` to `0.1.3` in:
  - `plugins/agent-todos/.claude-plugin/plugin.json`
  - `.claude-plugin/marketplace.json`
- Regenerated `docs/agent-todos/TODO_OVERVIEW.md`.

**Decisions made:**

- Kept both Kanban and list sections because Kanban improves quick scanning while the list preserves direct links and status values.
