---
title: "make trello-vault path configurable"
status: done
---

## Context

For the `plugins/agent-todos/skills/todo-obsidian-icloud-import` skill we use a harcoded path for the obsidian vault synced via icloud. we want a more generic approach for importing todo from obsidian

## Tasks

- create a new skill with script called `todo-obsidian-import``
- this should hacve a similar bevabioir like `plugins/agent-todos/skills/todo-obsidian-icloud-import` but the paths should also be configurabe like we do for the obsidian as primary todo storage
- can we use the same settings?
- plan before you build
- [x] create a new skill with script called `todo-obsidian-import`
- [x] configurable paths via `vaultRoot` in `.claude/agent-todos.local.json`, falling back to iCloud Drive discovery
- [x] bump version of plugin with minor (0.5.x → 0.6.0)
